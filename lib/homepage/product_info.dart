import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';

import 'package:page_transition/page_transition.dart';

import '../main.dart';
import '../shopcart/cart.dart';
import '../tabs/dashboard.dart';
import '../tabs/myaccount.dart';
import 'home.dart';

class productInfoHomePage extends StatefulWidget {
  const productInfoHomePage({Key? key}) : super(key: key);

  @override
  _productInfoHomePageState createState() => _productInfoHomePageState();
}

class _productInfoHomePageState extends State<productInfoHomePage> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  int _selectedIndex = 0;
  int count = 1;
  countIncrment() {
    setState(() {
      print(count);
      count = count + 1;
    });
  }

  countDecrement() {
    setState(() {
      print(count);
      count = count - 1;
    });
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
                  Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: MyApp()));
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
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 9.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 5,
                          child: Container(
                            height: 34.0,
                            child: TextField(
                              decoration: InputDecoration(
                                  labelText: 'Search products',
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
                          flex: 0,
                          child: Container(
                            height: 34.0,
                            width: 58,
                            decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(0.0),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(0.0)),
                            ),
                            child: FlatButton(
                              child: IconButton(
                                icon: Icon(Icons.search),
                                onPressed: () {},
                                color: Colors.white,
                                iconSize: 22,
                              ),
                              color: Color(0xFF005EA2),
                              textColor: Colors.white,
                              onPressed: () {},
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ]),
              Container(
                margin: EdgeInsets.only(left: 10, top: 0, right: 20, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Product information',
                      style: GoogleFonts.poppins(
                        color: Color(0xFF005EA2),
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Divider(
                height: 0,
                thickness: 1,
                indent: 0,
                endIndent: 0,
                color: Colors.grey.shade400,
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 0, right: 20, bottom: 0),
                child: Text(
                  'Happilo 100% Natural Premium Californian Almonds Value Pack Pouch, Dried, 500g',
                  style: GoogleFonts.poppins(
                    color: Color(0xFF005EA2),
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Container(
                  width: 160,
                  height: 150,
                  child: Image(
                      image: AssetImage(
                        'images/p3.png',
                      ),
                      width: 300,
                      height: 150,
                      fit: BoxFit.fill),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(90),
                    //0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: const [
                    TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'M.R.P :',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '\$39.99',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Price   :',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          '\$29.99',
                          style: TextStyle(
                            color: Color(0xFF005EA2),
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ]),
                  ],
                  border: TableBorder.all(width: 0, color: Colors.white),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 0, right: 20, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Product information',
                      style: GoogleFonts.poppins(
                        color: Color(0xFF005EA2),
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(1),
                child: Table(
                  columnWidths: const {
                    0: FixedColumnWidth(110),
                    //0: FlexColumnWidth(),
                    1: FlexColumnWidth(),
                  },
                  children: const [
                    TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Weight',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('500 grams'),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Brand',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Happilo'),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Type',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Vegetarian'),
                      ),
                    ]),
                    TableRow(children: [
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Form',
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Dried'),
                      ),
                    ]),
                  ],
                  border: TableBorder.all(width: 0, color: Colors.white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 0, right: 20, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'In Stock',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.green,
                        fontSize: 20,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 0, right: 20, bottom: 0),
                child: Row(
                  // mainAxisAlignment:
                  //     MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Quantity',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: const BorderRadius.only(
                          topLeft: const Radius.circular(14.0),
                          bottomLeft: const Radius.circular(14.0),
                          // topRight: const Radius.circular(4.0),
                          // bottomRight:
                          //     const Radius.circular(4.0)
                        ),
                        border: Border.all(
                          width: 1,
                          color: Color(0xFF005EA2),
                        ),
                      ),
                      height: 30,
                      width: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                        onPressed: () {
                          countDecrement();
                        },
                        child: const Text('-'),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          width: 1,
                          color: Color(0xFF005EA2),
                        ),
                      ),
                      height: 30,
                      width: 50,
                      child: Center(
                        child: Text(
                          '$count',
                          style:
                              TextStyle(color: Color(0xFF005EA2), fontSize: 18),
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: const BorderRadius.only(
                              topRight: const Radius.circular(14.0),
                              bottomRight: const Radius.circular(14.0)),
                          border: Border.all(
                            width: 1,
                            color: Color(0xFF005EA2),
                          )),
                      height: 30,
                      width: 40,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: const TextStyle(fontSize: 14),
                        ),
                        onPressed: () {
                          countIncrment();
                        },
                        child: const Text('+'),
                      ),
                    ),
                    SizedBox(
                      width: 50.0,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              Center(
                child: Container(
                  width: 200,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: shoppingCard()));
                    },
                    color: const Color(0xFF005EA2),
                    textColor: Colors.white,
                    splashColor: Colors.blue,
                    child: Text('Add to cart'),
                  ),
                ),
              ),
              SizedBox(
                height: 20.0,
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
