import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';
import 'package:number_inc_dec/number_inc_dec.dart';
import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../address/editaddress.dart';
import '../model/product_model.dart';
import '../orders/order_info.dart';
import 'cart.dart';
import 'package:http/http.dart' as http;

class checkoutPage extends StatefulWidget {
  const checkoutPage({Key? key}) : super(key: key);

  @override
  _checkoutPageState createState() => _checkoutPageState();
}

enum addressRadio { deliveraddress, homeaddress }

enum paymentMethod { debitCredit, netBanking, emi, wireTransfer }

class _checkoutPageState extends State<checkoutPage> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  // Initial Selected Value
  String dropdownValue = 'HDFC';
  List cardData = [];
  bool outOfStockFlag = false;
  int subtotal = 0;
  int totaltax = 0;
  int grandtotal = 0;

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
    print('subtotal');
    print(data["total"]["subtotal"]);
    print(subtotal);
    setState(() {
      totaltax = data["total"]["totaltax"];
    });
    print(totaltax);
    setState(() {
      grandtotal = data["total"]["grandtotal"];
    });
    print(grandtotal);
  }

  List addInfo = [];
  getAddressInfo() async {
    print(storage.getItem('people'));
    var refUserId = storage.getItem('people')["refUserId"];
    var refAccountId = storage.getItem('people')["refAccountId"];
    var refApplicationId = storage.getItem('people')["refApplicationId"];
    print(refUserId);
    print(refAccountId);
    print(refApplicationId);

    var res = await http.get(
      Uri.parse(dotenv.get('API_URL') +
          '/api/service/getMyAddress?shippingAddress=yes&userId=' +
          refUserId +
          '&accountId=' +
          refAccountId +
          '&applicationId=' +
          refApplicationId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    //print('response');
    //print(res);
    final responseFormat = json.decode(res.body);
    final data = responseFormat["data"];
    setState(() {
      addInfo = data.toList();
    });
    print('addfress ');
    print(addInfo);
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

  void initState() {
    // getCardInfo().then((data) {
    //   // setState(() {
    //   //   cardData = data;
    //   //   print(cardData);
    //   // });
    // });
    getCardInfo();
    getAddressInfo();
    super.initState();
  }

  addressRadio? _addressradio = addressRadio.deliveraddress;

  paymentMethod? _paytype = paymentMethod.debitCredit;
  var selectedRadio;
  changeValue(val) {
    setState(() {
      selectedRadio = val;
      print(selectedRadio);
    });
  }

  placeOrder() async {
    if (!outOfStockFlag) {
      print('placeorder');
      print(outOfStockFlag);
      print(storage.getItem('people'));
      var refUserId = storage.getItem('people')["refUserId"];
      var refAccountId = storage.getItem('people')["refAccountId"];
      var refApplicationId = storage.getItem('people')["refApplicationId"];
      print(refUserId);
      print(refAccountId);
      print(refApplicationId);
      print(selectedRadio);
      print(subtotal);
      print(totaltax);
      print(grandtotal);
      if (selectedRadio != null) {
        var postPlaceOrder = {
          "userId": refUserId,
          "accountId": refAccountId,
          "applicationId": refApplicationId,
          "addressId": selectedRadio,
          "subtotal": subtotal,
          "grandtotal": grandtotal,
          "totaltax": totaltax,
        };
        print(postPlaceOrder);
        var placeorder = await http.post(
          Uri.parse(dotenv.get('API_URL') + '/api/service/placeOrder'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(postPlaceOrder),
        );
        final responseFormatPlace = json.decode(placeorder.body);
        final dataAddress = responseFormatPlace["data"];
        print(dataAddress);
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "Order placed successfully",
          ),
        );
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: orderInfo()));
      }

      // else {
      //   showTopSnackBar(
      //     context,
      //     CustomSnackBar.error(
      //       message: "Please choose your delivery address.",
      //     ),
      //   );
      // }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              SafeArea(
                child: Row(children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
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
                                        child: shoppingCard()));
                              },
                              color: Colors.black,
                            ),
                          ),
                          Expanded(
                              flex: 5,
                              child: Container(
                                child: Text(
                                  'Checkout',
                                  style: GoogleFonts.poppins(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF005EA2),
                                  ),
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              SizedBox(
                height: 5.0,
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(width: 1, color: Colors.grey)),
                child: Container(
                  constraints: BoxConstraints.loose(const Size(600, 220)),
                  margin: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 10.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Order Summary',
                          textAlign: TextAlign.left,
                          style: GoogleFonts.poppins(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF005EA2),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Text(
                                'Item(s) Subtotal',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '\$' + (subtotal.toDouble()).toStringAsFixed(2),
                                //double.parse(subtotal.toString())
                                // .toStringAsFixed(2),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Text(
                                'Total',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '\$' + (subtotal.toDouble()).toStringAsFixed(2),
                                // double.parse(subtotal.toString())
                                //     .toStringAsFixed(2),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Text(
                                'Total Tax',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '\$' + (totaltax.toDouble()).toStringAsFixed(2),
                                // double.parse(totaltax.toString())
                                //     .toStringAsFixed(2),
                                //textAlign: TextAlign.end,
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Text(
                                'Grand Total',
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Text(
                                '\$' +
                                    (grandtotal.toDouble()).toStringAsFixed(2),
                                // double.parse(grandtotal.toString())
                                //     .toStringAsFixed(2),
                                textAlign: TextAlign.right,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 5.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 0, right: 0, bottom: 0),
                child: Text(
                  'Select a delivery address',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(width: 1, color: Colors.grey)),
                child: SingleChildScrollView(
                  child: Container(
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: addInfo.length,
                      itemBuilder: (context, i) => Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Radio<String>(
                                    value: addInfo[i]["id"],
                                    groupValue: selectedRadio,
                                    activeColor: Colors.blue,
                                    onChanged: (val) {
                                      changeValue(val);
                                    },
                                  ),
                                ),
                                Expanded(
                                    flex: 8,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        addInfo[i]["isDefault"] == 'Yes'
                                            ? Text(
                                                'RECENTLY USED',
                                                style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              )
                                            : Text(''),
                                        Text(
                                          addInfo[i]["name"],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          addInfo[i]["postOfficeBoxNumber"] +
                                              ', ' +
                                              addInfo[i]["streetAddress1"],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          addInfo[i]["city"]["name"] +
                                              ', ' +
                                              addInfo[0]["postalCode"],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        Text(
                                          addInfo[i]["country"]["name"],
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ), //isDefault
                                        addInfo[i]["isDefault"] == 'Yes'
                                            ? Container(
                                                width: 300,
                                                height: 40,
                                                child: RaisedButton(
                                                  onPressed: () {},
                                                  color: new Color(0xFF005EA2),
                                                  textColor: Colors.white,
                                                  splashColor: Colors.blue,
                                                  child: Text(
                                                      'Deliver to this address'),
                                                ),
                                              )
                                            : SizedBox(
                                                height: 5,
                                              ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        addInfo[i]["isDefault"] == 'Yes'
                                            ? Container(
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      width: 2,
                                                      color: Color(0xFF005EA2)),
                                                ),
                                                width: 300,
                                                height: 40,
                                                child: RaisedButton(
                                                  onPressed: () {
                                                    //editAddress
                                                    //editAddress
                                                    Navigator.push(
                                                        context,
                                                        PageTransition(
                                                            type:
                                                                PageTransitionType
                                                                    .rightToLeft,
                                                            child: editAddress(
                                                              editid: addInfo[i]
                                                                  ["id"],
                                                            )));
                                                  },
                                                  color: Colors.white,
                                                  textColor: Color(0xFF005EA2),
                                                  splashColor: Colors.blue,
                                                  child:
                                                      Text('Edit this address'),
                                                ),
                                              )
                                            : SizedBox(
                                                height: 5,
                                              ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          Divider(
                            height: 0,
                            thickness: 2,
                            indent: 0,
                            endIndent: 0,
                            color: Colors.grey.shade400,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 0, right: 0, bottom: 0),
                child: Text(
                  'Select a payment method',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(width: 1, color: Colors.grey)),
                child: Container(
                  constraints: BoxConstraints.loose(const Size(400, 55)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Radio<paymentMethod>(
                              value: paymentMethod.debitCredit,
                              groupValue: _paytype,
                              onChanged: (paymentMethod? value) {
                                setState(() {
                                  _paytype = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              'Add Debit/Credit Card',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Color(0xFFE5F6F5),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(width: 1, color: Colors.grey)),
                child: Container(
                  color: Color(0xFFE5F6F5),
                  constraints: BoxConstraints.loose(const Size(400, 100)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Radio<paymentMethod>(
                              value: paymentMethod.netBanking,
                              groupValue: _paytype,
                              onChanged: (paymentMethod? value) {
                                setState(() {
                                  _paytype = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  'Net Banking',
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 2, color: Color(0xFF005EA2)),
                                  ),
                                  width: 300,
                                  height: 45,
                                  child: DropdownButton<String>(
                                    value: dropdownValue,
                                    icon: const Icon(Icons.arrow_drop_down),
                                    iconSize: 24,
                                    elevation: 16,
                                    style: const TextStyle(color: Colors.black),
                                    underline: Container(
                                      height: 2,
                                      color: Color(0xFFE5F6F5),
                                    ),
                                    onChanged: (String? newValue) {
                                      setState(() {
                                        dropdownValue = newValue!;
                                      });
                                    },
                                    items: <String>[
                                      'HDFC',
                                      'ICICI',
                                      'SBI',
                                    ].map<DropdownMenuItem<String>>(
                                        (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(width: 1, color: Colors.grey)),
                child: Container(
                  constraints: BoxConstraints.loose(const Size(400, 55)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Radio<paymentMethod>(
                              value: paymentMethod.emi,
                              groupValue: _paytype,
                              onChanged: (paymentMethod? value) {
                                setState(() {
                                  _paytype = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              'EMI',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(width: 1, color: Colors.grey)),
                child: Container(
                  constraints: BoxConstraints.loose(const Size(400, 55)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Radio<paymentMethod>(
                              value: paymentMethod.wireTransfer,
                              groupValue: _paytype,
                              onChanged: (paymentMethod? value) {
                                setState(() {
                                  _paytype = value;
                                });
                              },
                            ),
                          ),
                          Expanded(
                            flex: 8,
                            child: Text(
                              'Wire Transfer',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Center(
                child: RaisedButton(
                  onPressed: () {},
                  color: new Color(0xFF005EA2),
                  textColor: Colors.white,
                  splashColor: Colors.blue,
                  child: Text('Use this payment method'),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 0, right: 0, bottom: 0),
                child: Text(
                  'Items & Delivery',
                  textAlign: TextAlign.left,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SingleChildScrollView(
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
                    margin:
                        EdgeInsets.only(left: 10, top: 0, right: 0, bottom: 10),
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
                                (cardData[i]["refProduct"]["smallImage"][0]
                                        ["path"])
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
                                    left: 0, top: 15, right: 0, bottom: 5),
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'SKU : ' +
                                          cardData[i]["refProduct"]["skuId"],
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    cardData[i]["inventoryStatus"]["value"] ==
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
                                          topLeft: const Radius.circular(15.0),
                                          bottomLeft:
                                              const Radius.circular(15.0),
                                          topRight: const Radius.circular(15.0),
                                          bottomRight:
                                              const Radius.circular(15.0)),
                                      border: Border.all(
                                        width: 1,
                                        color: Color(0xFF005EA2),
                                      ),
                                    ),
                                    //BoxDecoration
                                    //int v = int.parse(cardData[i]["quantity"])
                                    child: NumberInputPrefabbed.roundedButtons(
                                      controller: TextEditingController(),
                                      min: 1,
                                      initialValue: int.parse(
                                          cardData[i]["quantity"].toString()),
                                      // int.parse(cardData[i]["quantity"]),
                                      //1, //cardData[i]["quantity"], // 3, //int.parse(cardData[i]["quantity"]),
                                      onIncrement: (num newlyIncrementedValue) {
                                        print(
                                            'Newly incremented value is $newlyIncrementedValue');
                                        incdecOnchangeFunc(
                                            newlyIncrementedValue,
                                            cardData[i]["id"]);
                                      },
                                      onDecrement: (num newlyDecrementedValue) {
                                        print(
                                            'Newly decremented value is $newlyDecrementedValue');
                                        incdecOnchangeFunc(
                                            newlyDecrementedValue,
                                            cardData[i]["id"]);
                                      },
                                      onChanged: (num newlyIncrementedValue) {
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
                                      style: TextStyle(color: Colors.black),
                                      buttonArrangement:
                                          ButtonArrangement.incRightDecLeft,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 50.0,
                                  ),
                                  // TextButton(
                                  //   onPressed: () {
                                  //     deleteCartItem(cardData[i]["id"]);
                                  //   },
                                  //   child: Text(
                                  //     'Delete',
                                  //     style: GoogleFonts.poppins(
                                  //         fontSize: 14,
                                  //         fontWeight: FontWeight.w500,
                                  //         color: Colors.red),
                                  //   ),
                                  // ),
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
              ),
              Center(
                child: Container(
                  width: 250,
                  child: RaisedButton(
                    onPressed: () {
                      placeOrder();
                      //orderInfo
                      // Navigator.push(
                      //     context,
                      //     PageTransition(
                      //         type: PageTransitionType.rightToLeft,
                      //         child: orderInfo()));
                    },
                    color: new Color(0xFF005EA2),
                    textColor: Colors.white,
                    splashColor: Colors.blue,
                    child: Text('Place order'),
                  ),
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
