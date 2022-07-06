import 'dart:convert';

import 'package:buyer/orders/order_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';

import 'package:page_transition/page_transition.dart';
//import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';

import '../homepage/home.dart';
import '../main.dart';
import '../shopcart/cart.dart';
import 'myaccount.dart';
import 'package:http/http.dart' as http;
//import 'model/product_model.dart';

class productPage extends StatefulWidget {
  const productPage({Key? key}) : super(key: key);

  @override
  _productPageState createState() => _productPageState();
}

class _productPageState extends State<productPage> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  int _selectedIndex = 1;
  int orderCount = 0;
  int cancelCount = 0;
  Future getOrderCount() async {
    print('hi karthik');
    print(storage.getItem('people'));
    var refUserId = storage.getItem('people')["refUserId"];
    var refAccountId = storage.getItem('people')["refAccountId"];
    print(refUserId);
    print(refAccountId);

    var res = await http.get(
      Uri.parse(dotenv.get('API_URL') +
          '/api/service/entities?type=Order&options=count&q=refUser==' +
          refUserId +
          ';refAccountId==' +
          refAccountId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    //print('response');
    //print(res);
    final responseFormat = json.decode(res.body);
    setState(() {
      orderCount = responseFormat["data"];
    });

    print(orderCount);

    var res1 = await http.get(
      Uri.parse(dotenv.get('API_URL') +
          '/api/service/getCancelOrdersCount?userId=' +
          refUserId +
          ';refAccountId==' +
          refAccountId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    //print('response');
    //print(res);
    final responseFormat1 = json.decode(res1.body);

    setState(() {
      cancelCount = responseFormat1["data"];
    });
    print(cancelCount);
  }

  logout() {
    storage.deleteItem('appid');
    storage.deleteItem('orgid');
    storage.deleteItem('people');
    Navigator.push(context,
        PageTransition(type: PageTransitionType.rightToLeft, child: MyApp()));
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // setState(() {
    //   print(storage.getItem('people'));
    // });
    getOrderCount();
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
            children: [
              SizedBox(
                height: 1.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    margin: new EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Dashboard',
                      style: GoogleFonts.poppins(
                        fontSize: 25,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF005EA2),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 0.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FittedBox(
                    child: Card(
                      color: Color(0xFF005EA2),
                      child: Container(
                        constraints: BoxConstraints.loose(const Size(170, 205)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10.0),
                            ImageIcon(
                              AssetImage("images/shop_card.png"),
                              color: Colors.white,
                              size: 48,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: orderInfo()));
                              },
                              child: Text(
                                'Total Orders',
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              height: 30,
                              width: 80,
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    orderCount.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF006EC1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Padding(
                              padding: EdgeInsets.all(7.0),
                              child: Text(
                                'Total Orders placed as on date',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  FittedBox(
                    child: Card(
                      color: Color(0xFF005EA2),
                      child: Container(
                        constraints: BoxConstraints.loose(const Size(170, 205)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 10.0),
                            ImageIcon(
                              AssetImage("images/cancel.png"),
                              color: Colors.white,
                              size: 48,
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: orderInfo()));
                              },
                              child: Text(
                                'Cancelled Orders',
                                style: GoogleFonts.poppins(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Container(
                              height: 30,
                              width: 80,
                              child: Center(
                                child: FittedBox(
                                  child: Text(
                                    cancelCount.toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              decoration: const BoxDecoration(
                                color: Color(0xFF006EC1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(6)),
                              ),
                            ),
                            SizedBox(height: 5.0),
                            Padding(
                              padding: EdgeInsets.all(7.0),
                              child: Text(
                                'Total cancelled orders as on date',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
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
