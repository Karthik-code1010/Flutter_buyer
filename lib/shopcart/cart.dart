import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../homepage/home.dart';
import '../main.dart';
import '../model/product_model.dart';
import '../orders/order_details.dart';
import '../orders/order_info.dart';
import '../tabs/dashboard.dart';
import '../tabs/myaccount.dart';
import '../tabs/product_list.dart';
import 'checkout.dart';
import 'package:http/http.dart' as http;

class shoppingCard extends StatefulWidget {
  const shoppingCard({Key? key}) : super(key: key);

  @override
  _shoppingCardState createState() => _shoppingCardState();
}

class _shoppingCardState extends State<shoppingCard> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  final _formKey = GlobalKey<FormState>();
  var searchname = "";
  int _selectedIndex = 3;
  List cardData = [];
  int orderCount = 0;
  bool outOfStockFlag = false;
  var subtotal;
  getCardInfo() async {
    print(storage.getItem('people'));
    var refUserId = storage.getItem('people')["refUserId"];
    var refAccountId = storage.getItem('people')["refAccountId"];
    var refApplicationId = storage.getItem('people')["refApplicationId"];
    print(refUserId);
    print(refAccountId);
    print(refApplicationId);

    var res = await http.get(
      Uri.parse(dotenv.get('API_URL') +
          '/api/service/getShoppingCart?userId=' +
          refUserId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    //print('response');
    //print(res);
    final responseFormat = json.decode(res.body);
    final data = responseFormat["data"];

    // Map<String, dynamic> map = jsonDecode(data);
    // print(map);
    // //map.forEach((k, v) => cardData.add(cardDataModel(k, v)));
    // map.entries.forEach((e) => cardData.add(cardDataModel()));
    // print(cardData);
    //print(cardData);

    //print(data["list"]);
    setState(() {
      outOfStockFlag = false;
    });
    setState(() {
      orderCount = data["list"].length;
    });
    for (var i = 0; i < data["list"].length; i++) {
      var myObj = data["list"][i];
      if (outOfStockFlag == false &&
          (int.parse(myObj['refInventory']['quantity'].toString()) <
                  int.parse(myObj['quantity'].toString()) ||
              int.parse(myObj["refProduct"]["minimumQuantityToOrder"]
                      .toString()) >
                  int.parse(myObj['quantity'].toString()) ||
              int.parse(myObj["refProduct"]["maximumQuantityToOrder"]
                      .toString()) <
                  int.parse(myObj['quantity'].toString()))) {
        setState(() {
          outOfStockFlag = true;
        });
      }
    }
    setState(() {
      cardData = data["list"].toList();
    });
    print(cardData);
    print(data["total"]);
    setState(() {
      subtotal = data["total"]["subtotal"];
    });

    print(subtotal);
  }

  void initState() {
    // getCardInfo().then((data) {
    //   // setState(() {
    //   //   cardData = data;
    //   //   print(cardData);
    //   // });
    // });
    getCardInfo();
    super.initState();
  }

  deleteCartItem(cartItemId) async {
    print(cartItemId);
    var resdelete = await http.delete(
      Uri.parse(dotenv.get('API_URL') +
          '/api/service/entities/' +
          cartItemId +
          '/ShoppingCart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(resdelete);
    showTopSnackBar(
      context,
      CustomSnackBar.success(
        message: "Product deleted from cart",
      ),
    );
    //addressInfo
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft, child: shoppingCard()));
  }

  incdecOnchangeFunc(numvalue, shopid) async {
    print('increment value');
    print(numvalue);
    print(shopid);
    var postObjPeople = {
      "quantity": {"type": "Property", "value": numvalue}
    };
    var res = await http.patch(
      Uri.parse(dotenv.get('API_URL') +
          '/api/service/entities/' +
          shopid +
          '/ShoppingCart'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postObjPeople),
    );
    final responseFormat = json.decode(res.body);
    final data = responseFormat["data"];
    initState();
  }

  String qtans = '';
  String qtan1 = '';
  String qtan2 = '';
  getStockError(card) {
    //print(card);

    // print(card['refInventory']['quantity']);
    print('qunatity');
    print(int.parse(card['refInventory']['quantity']));
    print(card['quantity'].toString());
    print(int.parse(card['quantity'].toString()));

    // print(int.parse(card['refInventory']['quantity']) <
    //  int.parse(card['quantity']));

    if (int.parse(card['refInventory']['quantity'].toString()) <
        int.parse(card['quantity'].toString())) {
      qtans = "Out Of Stock (Available Quantity " +
          card['refInventory']['quantity'] +
          ")";
      return qtans;
      // return qtans;
    } else if (int.parse(
            card["refProduct"]["minimumQuantityToOrder"].toString()) >
        int.parse(card['quantity'].toString())) {
      qtan1 = "Minimum order quantity is " +
          card["refProduct"]["minimumQuantityToOrder"];

      return qtan1;
    } else if (int.parse(
            card["refProduct"]["maximumQuantityToOrder"].toString()) <
        int.parse(card['quantity'].toString())) {
      qtan2 = "Maximum order quantity is " +
          card["refProduct"]["maximumQuantityToOrder"];
      return qtan2;
    } else {
      return "";
    }
    //return 'karthik';
  }

  logout() {
    storage.deleteItem('appid');
    storage.deleteItem('orgid');
    storage.deleteItem('people');
    Navigator.push(context,
        PageTransition(type: PageTransitionType.rightToLeft, child: MyApp()));
  }

  checkout() {
    //initState();
    print('checkout');
    print(outOfStockFlag);
    print(!outOfStockFlag);
    if (!outOfStockFlag) {
      Navigator.push(
          context,
          PageTransition(
              type: PageTransitionType.rightToLeft, child: checkoutPage()));
    } else {
      if (qtans != '') {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: qtans,
          ),
        );
      }
      if (qtan1 != '') {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: qtan1,
          ),
        );
      }
      if (qtan2 != '') {
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: qtan2,
          ),
        );
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Tap');
      print(_selectedIndex);
      if (_selectedIndex == 2) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: myaccountpage()));
      }
      if (_selectedIndex == 0) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft,
                child: homePage(
                  searchvalue: '',
                )));
      }

      if (_selectedIndex == 1) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: productPage()));
      }
      if (_selectedIndex == 3) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: shoppingCard()));
      }
    });
  }

  search() {
    print('hi');
    print(searchname);
    Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.rightToLeft,
            child: homePage(searchvalue: searchname)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          transform: Matrix4.translationValues(-58.0, 0.0, 0.0),
          margin: EdgeInsets.only(left: 0, top: 0, right: 20, bottom: 0),
          height: 50,
          width: 140,
          color: Colors.white,
          child: Image(
            image: AssetImage('images/innoart.png'),
          ),
        ),
        elevation: 1,
        actions: [
          Row(
            children: [
              Text(
                'Hello, ' + storage.getItem('people')["name"],
                // style: TextStyle(color: Colors.black)
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              SizedBox(
                width: 2.0,
              ),
              IconButton(
                icon: Icon(Icons.notifications_active),
                onPressed: () {},
                color: Color(0xFF005EA2),
              ),
              IconButton(
                icon: ImageIcon(
                  AssetImage("images/logout.png"),
                  size: 24.0,
                  color: Color(0xFF005EA2),
                ),
                onPressed: () {
                  logout();
                  // Navigator.push(
                  //     context,
                  //     PageTransition(
                  //         type: PageTransitionType.rightToLeft,
                  //         child: MyApp()));
                },
                color: Color(0xFF005EA2),
              ),
              SizedBox(
                width: 5.0,
              )
            ],
          ),
        ],
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Container(
          // Symetric Padding
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 5.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 0.0,
              ),
              Row(children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 0,
                          child: IconButton(
                            icon: Icon(Icons.arrow_back),
                            onPressed: () {
                              //orderInfo

                              Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: homePage(
                                        searchvalue: '',
                                      )));
                            },
                            color: Colors.black,
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Container(
                            height: 34.0,
                            child: TextFormField(
                              controller:
                                  TextEditingController(text: searchname),
                              onChanged: (value) {
                                searchname = value;
                                print(searchname);
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                  labelText: 'Search for orders',
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xFF005EA2)),
                                    borderRadius: BorderRadius.circular(0),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        width: 1, color: Color(0xFF005EA2)),
                                    borderRadius: BorderRadius.circular(0),
                                  )),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Container(
                            height: 34.0,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(0.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(0.0)),
                            ),
                            child: FlatButton(
                              child: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {
                                  search();
                                },
                                color: Colors.white,
                                iconSize: 23,
                              ),
                              color: Color(0xFF005EA2),
                              textColor: Colors.white,
                              onPressed: () {
                                search();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              Container(
                height: 40.0,
                color: Color(0xFFE5F6F5),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.location_on),
                      onPressed: () {},
                      color: Colors.black,
                    ),
                    Text(
                      'Set delivery location',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 0, right: 0, bottom: 0),
                child: Text(
                  'Shopping Cart',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF005EA2),
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                  margin:
                      EdgeInsets.only(left: 14, top: 0, right: 0, bottom: 0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Subtotal (' + orderCount.toString() + ' items):',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF005EA2),
                        ),
                      ),
                      SizedBox(
                        width: 100.0,
                      ),
                      subtotal != null
                          ? Text(
                              '\$' + subtotal.toDouble().toStringAsFixed(2),
                              //double.parse((subtotal)).toStringAsFixed(2),
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF005EA2),
                              ),
                            )
                          : Text(''),
                    ],
                  )),
              SizedBox(
                height: 10.0,
              ),
              cardData.length > 0
                  ? SingleChildScrollView(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: cardData.length,
                        itemBuilder: (context, i) => Container(
                          decoration: BoxDecoration(
                            // border: Border(
                            //   bottom: BorderSide(width: 1.0, color: Colors.grey),
                            // ),
                            border: Border.all(width: 1, color: Colors.grey),
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            color: Colors.white,
                          ),
                          margin: EdgeInsets.only(
                              left: 10, top: 0, right: 0, bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 4,
                                child: Container(
                                  margin: EdgeInsets.only(
                                      left: 0, top: 0, right: 10, bottom: 0),
                                  height: 150,
                                  width: 100,
                                  child: Image.network(dotenv.get('API_URL') +
                                      '/api/service/' +
                                      (cardData[i]["refProduct"]["smallImage"]
                                              [0]["path"])
                                          .replaceAll(r'\', '/')),
                                  // Image.asset(productData[i].pimg),
                                ),
                              ),
                              Expanded(
                                flex: 7,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 0,
                                          top: 15,
                                          right: 0,
                                          bottom: 5),
                                      child: Text(
                                        cardData[i]["refProduct"]["name"],
                                        style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 0, top: 0, right: 0, bottom: 5),
                                      child: Text(
                                        'by ' +
                                            cardData[i]["refProduct"]["brand"]
                                                ["name"],
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 0, top: 0, right: 0, bottom: 5),
                                      child: Text(
                                        '\$' +
                                            double.parse(cardData[i]
                                                            ["refProductPrice"]
                                                        ["sellingPrice"]
                                                    .toString())
                                                .toStringAsFixed(2),
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF005EA2),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 0, top: 0, right: 0, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            'SKU : ' +
                                                cardData[i]["refProduct"]
                                                    ["skuId"],
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 0, top: 0, right: 0, bottom: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          cardData[i]["inventoryStatus"]
                                                      ["value"] ==
                                                  'In stock'
                                              ? Text(
                                                  cardData[i]["inventoryStatus"]
                                                      ["value"],
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.green,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              : Text(
                                                  cardData[i]["inventoryStatus"]
                                                      ["value"],
                                                  style: GoogleFonts.poppins(
                                                    color: Colors.red,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          height: 30,
                                          width: 100,
                                          clipBehavior: Clip.hardEdge,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade300,
                                            borderRadius: new BorderRadius.only(
                                                topLeft:
                                                    const Radius.circular(15.0),
                                                bottomLeft:
                                                    const Radius.circular(15.0),
                                                topRight:
                                                    const Radius.circular(15.0),
                                                bottomRight:
                                                    const Radius.circular(
                                                        15.0)),
                                            border: Border.all(
                                              width: 1,
                                              color: Color(0xFF005EA2),
                                            ),
                                          ),
                                          //BoxDecoration
                                          child: NumberInputPrefabbed
                                              .roundedButtons(
                                            controller: TextEditingController(),
                                            min: 1,
                                            initialValue: 1,
                                            onIncrement:
                                                (num newlyIncrementedValue) {
                                              print(
                                                  'Newly incremented value is $newlyIncrementedValue');
                                              incdecOnchangeFunc(
                                                  newlyIncrementedValue,
                                                  cardData[i]["id"]);
                                            },
                                            onDecrement:
                                                (num newlyDecrementedValue) {
                                              print(
                                                  'Newly decremented value is $newlyDecrementedValue');
                                              incdecOnchangeFunc(
                                                  newlyDecrementedValue,
                                                  cardData[i]["id"]);
                                            },
                                            onChanged:
                                                (num newlyIncrementedValue) {
                                              incdecOnchangeFunc(
                                                  newlyIncrementedValue,
                                                  cardData[i]["id"]);
                                            },
                                            scaleHeight: 1.0,
                                            scaleWidth: 1.0,
                                            incDecBgColor: Colors.grey.shade300,
                                            incIcon: Icons.add,
                                            decIcon: Icons.remove,
                                            incIconSize: 25,
                                            decIconSize: 25,
                                            style:
                                                TextStyle(color: Colors.black),
                                            buttonArrangement: ButtonArrangement
                                                .incRightDecLeft,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 50.0,
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            deleteCartItem(cardData[i]["id"]);
                                          },
                                          child: Text(
                                            'Delete',
                                            style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.red),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      getStockError(cardData[i]),
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.red),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    // Row(
                                    //   // mainAxisAlignment:
                                    //   //     MainAxisAlignment.spaceBetween,
                                    //   children: [
                                    //     Container(
                                    //       decoration: BoxDecoration(
                                    //         color: Colors.grey.shade300,
                                    //         borderRadius: new BorderRadius.only(
                                    //           topLeft: const Radius.circular(14.0),
                                    //           bottomLeft: const Radius.circular(14.0),
                                    //           // topRight: const Radius.circular(4.0),
                                    //           // bottomRight:
                                    //           //     const Radius.circular(4.0)
                                    //         ),
                                    //         border: Border.all(
                                    //           width: 1,
                                    //           color: Color(0xFF005EA2),
                                    //         ),
                                    //       ),
                                    //       height: 30,
                                    //       width: 30,
                                    //       child: Center(
                                    //         child: Text(
                                    //           '-',
                                    //           style: TextStyle(
                                    //               color: Color(0xFF005EA2),
                                    //               fontSize: 28),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Container(
                                    //       decoration: BoxDecoration(
                                    //         border: Border.all(
                                    //           width: 1,
                                    //           color: Color(0xFF005EA2),
                                    //         ),
                                    //       ),
                                    //       height: 30,
                                    //       width: 50,
                                    //       child: Center(
                                    //         child: Text(
                                    //           '1',
                                    //           style: TextStyle(
                                    //               color: Color(0xFF005EA2),
                                    //               fontSize: 18),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     Container(
                                    //       decoration: BoxDecoration(
                                    //           color: Colors.grey.shade300,
                                    //           borderRadius: new BorderRadius.only(
                                    //               topRight:
                                    //                   const Radius.circular(14.0),
                                    //               bottomRight:
                                    //                   const Radius.circular(14.0)),
                                    //           border: Border.all(
                                    //             width: 1,
                                    //             color: Color(0xFF005EA2),
                                    //           )),
                                    //       height: 30,
                                    //       width: 30,
                                    //       child: Center(
                                    //         child: Text(
                                    //           '+',
                                    //           style: TextStyle(
                                    //               color: Color(0xFF005EA2),
                                    //               fontSize: 22),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     SizedBox(
                                    //       width: 50.0,
                                    //     ),
                                    //   ],
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : cardData.length == 0
                      ? Center(
                          child: Text(' '),
                        )
                      : Center(

                          // child: CircularProgressIndicator(
                          //     semanticsLabel: ' Please ass to cart'),
                          ),
              SizedBox(
                height: 40.0,
              ),
              cardData.length > 0
                  ? Center(
                      child: RaisedButton(
                        onPressed: () {
                          checkout();
                          // Navigator.push(
                          //     context,
                          //     PageTransition(
                          //         type: PageTransitionType.rightToLeft,
                          //         child: checkoutPage()));
                        },
                        color: new Color(0xFF005EA2),
                        textColor: Colors.white,
                        splashColor: Colors.blue,
                        child: Text('Proceed to Checkout'),
                      ),
                    )
                  : SizedBox(
                      height: 40.0,
                    ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        selectedFontSize: 16,
        unselectedFontSize: 16,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/home.png"),
              size: 29.0,
              color: Colors.black,
            ),
            activeIcon: ImageIcon(
              AssetImage("images/home.png"),
              size: 29.0,
              color: Color(0xFF006EC1),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/dashboard.png"),
              size: 29.0,
              color: Colors.black,
            ),
            activeIcon: ImageIcon(
              AssetImage("images/dashboard.png"),
              size: 29.0,
              color: Color(0xFF006EC1),
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/user.png"),
              size: 29.0,
              color: Colors.black,
            ),
            activeIcon: ImageIcon(
              AssetImage("images/user.png"),
              size: 29.0,
              color: Color(0xFF006EC1),
            ),
            label: 'My Account',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(
              AssetImage("images/shcart.png"),
              size: 29.0,
              color: Colors.black,
            ),
            activeIcon: ImageIcon(
              AssetImage("images/shcart.png"),
              size: 29.0,
              color: Color(0xFF006EC1),
            ),
            label: 'Cart',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xFF006EC1),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
