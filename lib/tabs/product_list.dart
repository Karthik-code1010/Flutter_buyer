import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';

import 'package:page_transition/page_transition.dart';

import '../main.dart';
import '../model/product_model.dart';
import '../product_details/view_product.dart';
import 'dashboard.dart';
import 'myaccount.dart';

class productList extends StatefulWidget {
  const productList({Key? key}) : super(key: key);

  @override
  _productListState createState() => _productListState();
}

class _productListState extends State<productList> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  int _selectedIndex = 2;
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print('Tap');
      print(_selectedIndex);
      if (_selectedIndex == 2) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: productList()));
      }
      if (_selectedIndex == 0) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: productPage()));
      }

      if (_selectedIndex == 1) {
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: myaccountpage()));
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
          padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 9.0),
          child: Column(
            children: [
              SizedBox(
                height: 1.0,
              ),
              Row(children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 4,
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
                                onPressed: () {},
                                color: Colors.white,
                                iconSize: 23,
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
                margin: EdgeInsets.only(left: 20, top: 0, right: 20, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Product List',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF005EA2),
                      ),
                    ),
                    Text(
                      'Show filters',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Color(0xFF005EA2),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                height: 10,
                thickness: 2,
                indent: 10,
                endIndent: 0,
                color: Color(0xFD2E5EEFF),
              ),
              SingleChildScrollView(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: productData.length,
                  itemBuilder: (context, i) => Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 1.0, color: Colors.grey),
                      ),
                      color: Colors.white,
                    ),
                    margin:
                        EdgeInsets.only(left: 10, top: 0, right: 0, bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            height: 150,
                            width: 100,
                            child: Image.asset(productData[i].pimg),
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
                                  productData[i].title,
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
                                  'SKU :' + productData[i].sku,
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
                                  productData[i].stock,
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    color: Colors.green,
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
                                      'Quantity',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 23,
                                    ),
                                    Text(':'),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      productData[i].quant,
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
                                    Text(
                                      'Status',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                    ),
                                    Text(':'),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      productData[i].status,
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
                                    left: 0, top: 0, right: 0, bottom: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Created at',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(':'),
                                    SizedBox(
                                      width: 20,
                                    ),
                                    Text(
                                      productData[i].cdate,
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 28,
                                    width: 80,
                                    child: FlatButton(
                                      child: Text(
                                        'View',
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      color: Color(0xFF005EA2),
                                      textColor: Colors.white,
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            PageTransition(
                                                type: PageTransitionType
                                                    .rightToLeft,
                                                child: viewProduct()));
                                      },
                                    ),
                                  ),
                                  SizedBox(
                                    width: 18,
                                  ),
                                  Container(
                                    height: 28,
                                    width: 80,
                                    child: FlatButton(
                                      child: Text(
                                        'Edit',
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      color: Color(0xFF005EA2),
                                      textColor: Colors.white,
                                      onPressed: () {},
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
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
              AssetImage("images/package.png"),
              size: 29.0,
              color: Colors.black,
            ),
            activeIcon: ImageIcon(
              AssetImage("images/package.png"),
              size: 29.0,
              color: Color(0xFF006EC1),
            ),
            label: 'Products',
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
