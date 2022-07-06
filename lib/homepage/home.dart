import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_breadcrumb/flutter_breadcrumb.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:localstorage/localstorage.dart';

import 'package:page_transition/page_transition.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../main.dart';
import '../model/product_model.dart';
import '../services/apiservices.dart';
import '../shopcart/cart.dart';
import '../tabs/dashboard.dart';
import '../tabs/myaccount.dart';
import 'product_info.dart';
import 'package:http/http.dart' as http;

// Future<List<Photo>> fetchPhotos(var searchItem) async {
//   // final response = await client
//   //     .get(Uri.parse('https://jsonplaceholder.typicode.com/photos'));
//   // final response = await client.get(Uri.parse(
//   //     'http://192.168.1.2:8000/api/service/entities?type=Order&options=keyValues'));
//
//   //Use the compute function to run parsePhotos in a separate isolate.
//   //print('search name');
//   //print(searchItem);
//
//   var response = await http.post(
//     Uri.parse(dotenv.get('API_URL') +
//         '/api/service/filterProducts?limit=&offset=&categoryId=&search=' +
//         searchItem),
//     headers: <String, String>{
//       'Content-Type': 'application/json; charset=UTF-8',
//     },
//   );
//   print('hi innoart');
//   //print(response.body);
//   final responseF2 = json.decode(response.body);
//   final data2 = responseF2["data"];
//   //print(data2);
//   return compute(parsePhotos, jsonEncode(data2));
// }
//
// // A function that converts a response body into a List<Photo>.
// List<Photo> parsePhotos(String responseBody) {
//   final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();
//   print('parsed');
//   print(parsed);
//
//   return parsed.map<Photo>((json) => Photo.fromJson(json)).toList();
// }
//
// class Photo {
//   String? name;
//   String? id;
//   String? type;
//   String? createdAt;
//   String? modifiedAt;
//   String? skuId;
//   String? status;
//   String? isFeatured;
//   String? newArrival;
//   String? brand;
//   String? shortDescription;
//   String? longDescription;
//   List<SmallImage>? smallImage;
//   List<SmallImage>? largeImage;
//   String? refCatalogue;
//   String? refProductType;
//   String? refUser;
//   String? refApplicationId;
//   String? refAccountId;
//   String? managedInventory;
//   String? minimumQuantityToOrder;
//   String? maximumQuantityToOrder;
//   String? lowInventoryThreshold;
//   String? highlightLowInventory;
//   String? tax;
//   RefProductPrice? refProductPrice;
//   String? attributeName1;
//   String? attributeName2;
//   String? refInventory;
//
//   Photo(
//       {this.name,
//       this.id,
//       this.type,
//       this.createdAt,
//       this.modifiedAt,
//       this.skuId,
//       this.status,
//       this.isFeatured,
//       this.newArrival,
//       this.brand,
//       this.shortDescription,
//       this.longDescription,
//       this.smallImage,
//       this.largeImage,
//       this.refCatalogue,
//       this.refProductType,
//       this.refUser,
//       this.refApplicationId,
//       this.refAccountId,
//       this.managedInventory,
//       this.minimumQuantityToOrder,
//       this.maximumQuantityToOrder,
//       this.lowInventoryThreshold,
//       this.highlightLowInventory,
//       this.tax,
//       this.refProductPrice,
//       this.attributeName1,
//       this.attributeName2,
//       this.refInventory});
//
//   Photo.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     id = json['id'];
//     type = json['type'];
//     createdAt = json['createdAt'];
//     modifiedAt = json['modifiedAt'];
//     skuId = json['skuId'];
//     status = json['status'];
//     isFeatured = json['isFeatured'];
//     newArrival = json['newArrival'];
//     brand = json['brand'];
//     shortDescription = json['shortDescription'];
//     longDescription = json['longDescription'];
//     if (json['smallImage'] != null) {
//       smallImage = <SmallImage>[];
//       json['smallImage'].forEach((v) {
//         smallImage!.add(new SmallImage.fromJson(v));
//       });
//     }
//     if (json['largeImage'] != null) {
//       largeImage = <SmallImage>[];
//       json['largeImage'].forEach((v) {
//         largeImage!.add(new SmallImage.fromJson(v));
//       });
//     }
//     refCatalogue = json['refCatalogue'];
//     refProductType = json['refProductType'];
//     refUser = json['refUser'];
//     refApplicationId = json['refApplicationId'];
//     refAccountId = json['refAccountId'];
//     managedInventory = json['managedInventory'];
//     minimumQuantityToOrder = json['minimumQuantityToOrder'];
//     maximumQuantityToOrder = json['maximumQuantityToOrder'];
//     lowInventoryThreshold = json['lowInventoryThreshold'];
//     highlightLowInventory = json['highlightLowInventory'];
//     tax = json['tax'];
//     refProductPrice = json['refProductPrice'] != null
//         ? new RefProductPrice.fromJson(json['refProductPrice'])
//         : null;
//     attributeName1 = json['attributeName1'];
//     attributeName2 = json['attributeName2'];
//     refInventory = json['refInventory'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['id'] = this.id;
//     data['type'] = this.type;
//     data['createdAt'] = this.createdAt;
//     data['modifiedAt'] = this.modifiedAt;
//     data['skuId'] = this.skuId;
//     data['status'] = this.status;
//     data['isFeatured'] = this.isFeatured;
//     data['newArrival'] = this.newArrival;
//     data['brand'] = this.brand;
//     data['shortDescription'] = this.shortDescription;
//     data['longDescription'] = this.longDescription;
//     if (this.smallImage != null) {
//       data['smallImage'] = this.smallImage!.map((v) => v.toJson()).toList();
//     }
//     if (this.largeImage != null) {
//       data['largeImage'] = this.largeImage!.map((v) => v.toJson()).toList();
//     }
//     data['refCatalogue'] = this.refCatalogue;
//     data['refProductType'] = this.refProductType;
//     data['refUser'] = this.refUser;
//     data['refApplicationId'] = this.refApplicationId;
//     data['refAccountId'] = this.refAccountId;
//     data['managedInventory'] = this.managedInventory;
//     data['minimumQuantityToOrder'] = this.minimumQuantityToOrder;
//     data['maximumQuantityToOrder'] = this.maximumQuantityToOrder;
//     data['lowInventoryThreshold'] = this.lowInventoryThreshold;
//     data['highlightLowInventory'] = this.highlightLowInventory;
//     data['tax'] = this.tax;
//     if (this.refProductPrice != null) {
//       data['refProductPrice'] = this.refProductPrice!.toJson();
//     }
//     data['attributeName1'] = this.attributeName1;
//     data['attributeName2'] = this.attributeName2;
//     data['refInventory'] = this.refInventory;
//     return data;
//   }
// }
//
// class SmallImage {
//   String? name;
//   String? id;
//   String? type;
//   String? createdAt;
//   String? modifiedAt;
//   String? startDate;
//   String? endDate;
//   String? description;
//   String? path;
//   String? refConnector;
//   String? mediaType;
//   String? refApplicationId;
//   String? refAccountId;
//
//   SmallImage(
//       {this.name,
//       this.id,
//       this.type,
//       this.createdAt,
//       this.modifiedAt,
//       this.startDate,
//       this.endDate,
//       this.description,
//       this.path,
//       this.refConnector,
//       this.mediaType,
//       this.refApplicationId,
//       this.refAccountId});
//
//   SmallImage.fromJson(Map<String, dynamic> json) {
//     name = json['name'];
//     id = json['id'];
//     type = json['type'];
//     createdAt = json['createdAt'];
//     modifiedAt = json['modifiedAt'];
//     startDate = json['startDate'];
//     endDate = json['endDate'];
//     description = json['description'];
//     path = json['path'];
//     refConnector = json['refConnector'];
//     mediaType = json['mediaType'];
//     refApplicationId = json['refApplicationId'];
//     refAccountId = json['refAccountId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['name'] = this.name;
//     data['id'] = this.id;
//     data['type'] = this.type;
//     data['createdAt'] = this.createdAt;
//     data['modifiedAt'] = this.modifiedAt;
//     data['startDate'] = this.startDate;
//     data['endDate'] = this.endDate;
//     data['description'] = this.description;
//     data['path'] = this.path;
//     data['refConnector'] = this.refConnector;
//     data['mediaType'] = this.mediaType;
//     data['refApplicationId'] = this.refApplicationId;
//     data['refAccountId'] = this.refAccountId;
//     return data;
//   }
// }
//
// class RefProductPrice {
//   String? mrp;
//   String? id;
//   String? type;
//   String? createdAt;
//   String? modifiedAt;
//   String? sellingPrice;
//   String? currency;
//   String? refApplicationId;
//   String? refAccountId;
//
//   RefProductPrice(
//       {this.mrp,
//       this.id,
//       this.type,
//       this.createdAt,
//       this.modifiedAt,
//       this.sellingPrice,
//       this.currency,
//       this.refApplicationId,
//       this.refAccountId});
//
//   RefProductPrice.fromJson(Map<String, dynamic> json) {
//     mrp = json['mrp'];
//     id = json['id'];
//     type = json['type'];
//     createdAt = json['createdAt'];
//     modifiedAt = json['modifiedAt'];
//     sellingPrice = json['sellingPrice'];
//     currency = json['currency'];
//     refApplicationId = json['refApplicationId'];
//     refAccountId = json['refAccountId'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['mrp'] = this.mrp;
//     data['id'] = this.id;
//     data['type'] = this.type;
//     data['createdAt'] = this.createdAt;
//     data['modifiedAt'] = this.modifiedAt;
//     data['sellingPrice'] = this.sellingPrice;
//     data['currency'] = this.currency;
//     data['refApplicationId'] = this.refApplicationId;
//     data['refAccountId'] = this.refAccountId;
//     return data;
//   }
// }

class homePage extends StatefulWidget {
  final String searchvalue;
  const homePage({Key? key, required this.searchvalue}) : super(key: key);

  @override
  _homePageState createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  final LocalStorage storage = new LocalStorage('localstorage_app');
  final _formKey = GlobalKey<FormState>();
  var searchname = "";
  int _selectedIndex = 0;

  //var searchItem;

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

  logout() {
    storage.deleteItem('appid');
    storage.deleteItem('orgid');
    storage.deleteItem('people');
    Navigator.push(context,
        PageTransition(type: PageTransitionType.rightToLeft, child: MyApp()));
  }

  Future search() async {
    print('hi karthik');
    print(searchname);
    if (searchname == '') {
      //print('if part' + searchname);
      getDashboardData();
    } else {
      // print('else' + searchname);
      getsearchData(searchname);
    }
  }
  //late Future<Album> futureAlbum;

  // late Future<Products> futureAlbum;
//
  @override
  void initState() {
    super.initState();
    //getDashboardData();
    if (widget.searchvalue == '') {
      //print('if part' + searchname);
      getDashboardData();
    } else {
      // print('else' + searchname);
      getsearchData(widget.searchvalue);
    }
    //fetchPhotos(searchname = "");
    //widget.searchvalue
    getProductBrand();
  }

  getsearchData(searchnamevalue) async {
    var response = await http.post(
      Uri.parse(dotenv.get('API_URL') +
          '/api/service/filterProducts?limit=9&offset=0&categoryId=&search=' +
          searchnamevalue),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('hi innoart');
    //print(response.body);
    final responseF2 = json.decode(response.body);
    final data2 = responseF2["data"];
    print('Dashboard data');
    setState(() {
      dashboardProduct = data2;
    });

    print(data2);
  }

  var dashboardProduct = [];
  getDashboardData() async {
    var response = await http.get(
      Uri.parse(
          dotenv.get('API_URL') + '/api/service/getProducts?limit=&offset='),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('hi innoart');
    //print(response.body);
    final responseF2 = json.decode(response.body);
    final data2 = responseF2["data"];
    print('Dashboard data');
    setState(() {
      dashboardProduct = data2;
    });

    print(data2);
  }

  Future addToCart(pid, refInventId, refProductPriceId) async {
    print('Add to Cart' + pid);
    print('Add to Cart' + refInventId);
    print('Add to Cart' + refProductPriceId);
    print(storage.getItem('people'));
    //List loginId = storage.getItem('people').toList();
    //var value = storage.getItem('people').values.toList();
    // print(value);
    print(storage.getItem('people'));
    print(storage.getItem('people')["refUserId"]);
    var refUserId = storage.getItem('people')["refUserId"];
    var refAccountId = storage.getItem('people')["refAccountId"];
    print(refAccountId);
    print(storage.getItem('appid'));

    var res = await http.get(
      Uri.parse(dotenv.get('API_URL') +
          '/api/service/entities?type=ShoppingCart&q=refUser==' +
          refUserId +
          ';refProduct==' +
          pid),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    final responseFormat = json.decode(res.body);
    final data = responseFormat["data"];
    if (data.length > 0) {
      // print(data);
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "Product already in cart",
        ),
      );
    } else {
      // print('else part');
      //print(data);
      var postObjdata = {
        "type": "ShoppingCart",
        "refProduct": {"type": "Relationship", "value": pid},
        "refInventory": {"type": "Relationship", "value": refInventId},
        "quantity": {"type": "Property", "value": "1"},
        "refProductPrice": {"type": "Relationship", "value": refProductPriceId},
        "refUser": {"type": "Relationship", "value": refUserId},
        "refAccountId": {"type": "Relationship", "value": refAccountId},
        "refApplicationId": {
          "type": "Relationship",
          "value": storage.getItem('appid')
        }
      };
      var postres = await http.post(
        Uri.parse(dotenv.get('API_URL') + '/api/service/entities'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(postObjdata),
      );
      final responseF_res = json.decode(postres.body);
      final pdata2 = responseF_res["data"];
      if (pdata2.length > 0) {
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: "Product added to cart",
          ),
        );
        Navigator.push(
            context,
            PageTransition(
                type: PageTransitionType.rightToLeft, child: shoppingCard()));
      }
    }
  }

  bool valuefirst = false;
  bool valuesecond = false;
  List fliterProductBrand = [];
  getProductBrand() async {
    print(storage.getItem('people'));
    var refUserId = storage.getItem('people')["refUserId"];
    var refAccountId = storage.getItem('people')["refAccountId"];
    var refApplicationId = storage.getItem('people')["refApplicationId"];
    print(refUserId);
    print(refAccountId);
    print(refApplicationId);

    var res = await http.get(
      Uri.parse(dotenv.get('API_URL') +
          '/api/service/entities?options=keyValues&type=ProductBrand'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    //print('response');
    //print(res);
    final responseFormat = json.decode(res.body);
    final data = responseFormat["data"];
    setState(() {
      fliterProductBrand = data.toList();
    });
  }

  var arrivalList = [
    {"id": 2, "name": "Last 30 days", "value": 30},
    {"id": 3, "name": "Last 90 days", "value": 90}
  ];
  var filpostObj;
  fliter() async {
    var tataid = fliterProductBrand[0]["id"];
    var happioid = fliterProductBrand[1]["id"];
    print(tataid);
    print(happioid);
    print('fliter');
    print(tata);
    print(happios);
    print(last30days);
    print(last90days);
    if (tata) {
      filpostObj = {
        "brand": [tataid],
        "arrival": []
      };
    }
    if (happios) {
      filpostObj = {
        "brand": [happioid],
        "arrival": []
      };
    }
    if (tata && happios) {
      filpostObj = {
        "brand": [tataid, happioid],
        "arrival": []
      };
    }
    if (last30days) {
      filpostObj = {
        "brand": [],
        "arrival": ["30"]
      };
    }
    if (last90days) {
      filpostObj = {
        "brand": [],
        "arrival": ["90"]
      };
    }
    if (last30days && last90days) {
      filpostObj = {
        "brand": [],
        "arrival": ["30", "90"]
      };
    }
    if (tata == true &&
        happios == true &&
        last30days == true &&
        last90days == true) {
      filpostObj = {
        "brand": [tataid, happioid],
        "arrival": ["30", "90"]
      };
    }
    var response = await http.post(
      Uri.parse(dotenv.get('API_URL') +
          '/api/service/filterProducts?limit=&offset=&categoryId=&search='),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(filpostObj),
    );
    print('hi innoart');
    //print(response.body);
    final responseF2 = json.decode(response.body);
    final data2 = responseF2["data"];
    print('Dashboard data');
    setState(() {
      dashboardProduct = data2;
    });
    Navigator.pop(context);
  }

  bool _isChecked = false;
  bool tata = false;
  bool happios = false;
  bool last30days = false;
  bool last90days = false;
  // late List<bool> _isChecked;

  dialogbox() async {
    showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(''),
              content: Container(
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Brands',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // ListView.builder(
                    //   itemCount: fliterProductBrand.length,
                    //   itemBuilder: (context, index) {
                    //     return CheckboxListTile(
                    //       title: Text('chk'),
                    //       value: keep,
                    //       onChanged: (bool? value) {
                    //         setState(() {
                    //           keep = value!;
                    //         });
                    //       },
                    //     );
                    //   },
                    // ),

                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: new Color(0xFF005EA2),
                          onChanged: (bool? value) {
                            setState(() {
                              tata = value!;
                            });
                          },
                          value: tata,
                        ),
                        Text('Tata'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: new Color(0xFF005EA2),
                          onChanged: (bool? value) {
                            setState(() {
                              happios = value!;
                            });
                          },
                          value: happios,
                        ),
                        Text('Happios'),
                      ],
                    ),
                    Text(
                      'New Arrivals',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: new Color(0xFF005EA2),
                          onChanged: (bool? value) {
                            setState(() {
                              last30days = value!;
                            });
                          },
                          value: last30days,
                        ),
                        Text('Last 30 days'),
                      ],
                    ),
                    Row(
                      children: [
                        Checkbox(
                          checkColor: Colors.white,
                          activeColor: new Color(0xFF005EA2),
                          onChanged: (bool? value) {
                            setState(() {
                              last90days = value!;
                            });
                          },
                          value: last90days,
                        ),
                        Text('Last 90 days'),
                      ],
                    ),
                  ],
                ),
              ),
              actions: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      height: 28,
                      width: 80,
                      child: FlatButton(
                        child: Text(
                          'Cancel',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        color: Color(0xFF005EA2),
                        textColor: Colors.white,
                        onPressed: () {
                          Navigator.of(context).pop();
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
                          'Ok',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        color: Color(0xFF005EA2),
                        textColor: Colors.white,
                        onPressed: () {
                          fliter();
                        },
                      ),
                    )
                  ],
                ),
              ],
            );
          });
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
          padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 9.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10.0,
              ),
              Form(
                key: _formKey,
                child: Row(children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 5,
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
                                    labelText: 'Search for products',
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(0.0)),
                              ),
                              child: FlatButton(
                                child: IconButton(
                                  icon: Icon(Icons.search),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      search();
                                    } else {
                                      print("not ok");
                                    }
                                  },
                                  color: Colors.white,
                                  iconSize: 22,
                                ),
                                color: Color(0xFF005EA2),
                                textColor: Colors.white,
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    search();
                                  } else {
                                    print("not ok");
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(left: 10, top: 0, right: 20, bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        dialogbox();
                      },
                      child: Text(
                        'Filters',
                        style: GoogleFonts.poppins(
                          color: Color(0xFF005EA2),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              // ListView.builder(
              //   itemCount: availableHobbies.length,
              //   itemBuilder: (context, index) {
              //     return CheckboxListTile(
              //         value: availableHobbies[index]["isChecked"],
              //         title: Text(availableHobbies[index]["name"]),
              //         onChanged: (newValue) {
              //           setState(() {
              //             availableHobbies[index]["isChecked"] = newValue;
              //           });
              //         });
              //   },
              // ),

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
                  'Dry Fruits, Nuts & Spices',
                  style: GoogleFonts.poppins(
                      color: Color(0xFF005EA2),
                      fontSize: 22,
                      fontWeight: FontWeight.w500),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              // Center(
              //   child: FutureBuilder<Products>(
              //     future: futureAlbum,
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         return Text(snapshot.data!.name);
              //       } else if (snapshot.hasError) {
              //         return Text('${snapshot.error}');
              //       }
              //
              //       // By default, show a loading spinner.
              //       return const CircularProgressIndicator();
              //     },
              //   ),
              // ),

              // Center(
              //   child: FutureBuilder(
              //     future: apiProvider().getData(),
              //     builder: (context, snapshopt) {
              //       if (!snapshopt.hasData) {
              //         return const CircularProgressIndicator();
              //       } else {
              //         print(snapshopt.data);
              //         return ListView.builder(
              //           itemCount: 2,
              //           itemBuilder: (context, index) {
              //             final result = snapshopt.data[index];
              //             return ListTile(
              //               title: Text(result["name"]),
              //               subtitle: Text(result["id"]),
              //             );
              //           },
              //         );
              //       }
              //     },
              //   ),
              // ),
              dashboardProduct.length > 0
                  ? SingleChildScrollView(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: dashboardProduct.length,
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
                                  child:
                                      // Image.asset(photos[i].largeImage[0].path),
                                      // Image.network(
                                      //     'http://192.168.1.2:8000/api/service/assets/uploads/file-1646995800361.jpg'),
                                      Image.network(dotenv.get('API_URL') +
                                          '/api/service/' +
                                          (dashboardProduct[i]["largeImage"][0]
                                                  ["path"])
                                              .replaceAll(r'\', '/')),
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
                                      child: GestureDetector(
                                        onTap: () {
                                          // Navigator.push(
                                          //     context,
                                          //     PageTransition(
                                          //         type: PageTransitionType
                                          //             .rightToLeft,
                                          //         child:
                                          //             productInfoHomePage()));
                                        },
                                        child: Text(
                                          dashboardProduct[i]["name"],
                                          style: GoogleFonts.poppins(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          left: 0, top: 0, right: 0, bottom: 5),
                                      child: Text(
                                        dashboardProduct[i]["shortDescription"],
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
                                            dashboardProduct[i]
                                                    ["refProductPrice"]
                                                ["sellingPrice"],
                                        style: GoogleFonts.poppins(
                                          color: Color(0xFF005EA2),
                                          fontSize: 25,
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ),
                                    //Text(photos[i].largeImage[0].path),
                                    SizedBox(
                                      height: 1,
                                    ),
                                    RaisedButton(
                                      onPressed: () {
                                        var productId =
                                            dashboardProduct[i]["id"];
                                        var refInventory =
                                            dashboardProduct[i]["refInventory"];
                                        var refProductPriceId =
                                            dashboardProduct[i]
                                                ["refProductPrice"]["id"];
                                        print(productId);
                                        print(refInventory);
                                        print(refProductPriceId);
                                        // Navigator.push(
                                        //     context,
                                        //     PageTransition(
                                        //         type: PageTransitionType
                                        //             .rightToLeft,
                                        //         child: shoppingCard()));

                                        addToCart(productId, refInventory,
                                            refProductPriceId);
                                      },
                                      color: new Color(0xFF005EA2),
                                      textColor: Colors.white,
                                      splashColor: Colors.blue,
                                      child: Text('Add to cart'),
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
                    )
                  : dashboardProduct.length == 0
                      ? Center(
                          child: Text(
                            ' ',
                            style: TextStyle(color: Colors.red),
                          ),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),

              // FutureBuilder<List<Photo>>(
              //   future: fetchPhotos(searchname),
              //   builder: (context, snapshot) {
              //     if (snapshot.hasError) {
              //       return const Center(
              //         child: Text('An error has occurred!'),
              //       );
              //     } else if (snapshot.hasData) {
              //       //print(snapshot.data);
              //       print('grid');
              //       List photos = snapshot.data!;
              //       print(photos);
              //
              //       // return PhotosList(photos: snapshot.data!);
              //       return SingleChildScrollView(
              //         child: ListView.builder(
              //           physics: NeverScrollableScrollPhysics(),
              //           scrollDirection: Axis.vertical,
              //           shrinkWrap: true,
              //           itemCount: photos.length,
              //           itemBuilder: (context, i) => Container(
              //             decoration: BoxDecoration(
              //               // border: Border(
              //               //   bottom: BorderSide(width: 1.0, color: Colors.grey),
              //               // ),
              //               border: Border.all(width: 1, color: Colors.grey),
              //               borderRadius: BorderRadius.all(Radius.circular(5)),
              //               color: Colors.white,
              //             ),
              //             margin: EdgeInsets.only(
              //                 left: 10, top: 0, right: 0, bottom: 10),
              //             child: Row(
              //               children: [
              //                 Expanded(
              //                   flex: 4,
              //                   child: Container(
              //                     margin: EdgeInsets.only(
              //                         left: 0, top: 0, right: 10, bottom: 0),
              //                     height: 150,
              //                     width: 100,
              //                     child:
              //                         // Image.asset(photos[i].largeImage[0].path),
              //                         // Image.network(
              //                         //     'http://192.168.1.2:8000/api/service/assets/uploads/file-1646995800361.jpg'),
              //                         Image.network(dotenv.get('API_URL') +
              //                             '/api/service/' +
              //                             (photos[i].largeImage[0].path)
              //                                 .replaceAll(r'\', '/')),
              //                   ),
              //                 ),
              //                 Expanded(
              //                   flex: 7,
              //                   child: Column(
              //                     mainAxisAlignment: MainAxisAlignment.start,
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: [
              //                       Container(
              //                         margin: EdgeInsets.only(
              //                             left: 0,
              //                             top: 15,
              //                             right: 0,
              //                             bottom: 5),
              //                         child: GestureDetector(
              //                           onTap: () {
              //                             Navigator.push(
              //                                 context,
              //                                 PageTransition(
              //                                     type: PageTransitionType
              //                                         .rightToLeft,
              //                                     child:
              //                                         productInfoHomePage()));
              //                           },
              //                           child: Text(
              //                             photos[i].name,
              //                             style: GoogleFonts.poppins(
              //                               fontSize: 20,
              //                               fontWeight: FontWeight.bold,
              //                             ),
              //                           ),
              //                         ),
              //                       ),
              //                       Container(
              //                         margin: EdgeInsets.only(
              //                             left: 0, top: 0, right: 0, bottom: 5),
              //                         child: Text(
              //                           photos[i].shortDescription,
              //                           style: GoogleFonts.poppins(
              //                             fontSize: 14,
              //                             fontWeight: FontWeight.normal,
              //                           ),
              //                         ),
              //                       ),
              //                       Container(
              //                         margin: EdgeInsets.only(
              //                             left: 0, top: 0, right: 0, bottom: 5),
              //                         child: Text(
              //                           '\$' +
              //                               photos[i]
              //                                   .refProductPrice!
              //                                   .sellingPrice,
              //                           style: GoogleFonts.poppins(
              //                             color: Color(0xFF005EA2),
              //                             fontSize: 25,
              //                             fontWeight: FontWeight.normal,
              //                           ),
              //                         ),
              //                       ),
              //                       //Text(photos[i].largeImage[0].path),
              //                       SizedBox(
              //                         height: 1,
              //                       ),
              //                       RaisedButton(
              //                         onPressed: () {
              //                           var productId = photos[i].id;
              //                           var refInventory =
              //                               photos[i].refInventory;
              //                           var refProductPriceId =
              //                               photos[i].refProductPrice.id;
              //                           print(productId);
              //                           print(refInventory);
              //                           print(refProductPriceId);
              //                           // Navigator.push(
              //                           //     context,
              //                           //     PageTransition(
              //                           //         type: PageTransitionType
              //                           //             .rightToLeft,
              //                           //         child: shoppingCard()));
              //
              //                           addToCart(productId, refInventory,
              //                               refProductPriceId);
              //                         },
              //                         color: new Color(0xFF005EA2),
              //                         textColor: Colors.white,
              //                         splashColor: Colors.blue,
              //                         child: Text('Add to cart'),
              //                       ),
              //                       SizedBox(
              //                         height: 10,
              //                       ),
              //                     ],
              //                   ),
              //                 ),
              //               ],
              //             ),
              //           ),
              //         ),
              //       );
              //     } else {
              //       return const Center(
              //         child: CircularProgressIndicator(),
              //       );
              //     }
              //   },
              // ),
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

// class PhotosList extends StatelessWidget {
//   const PhotosList({Key? key, required this.photos}) : super(key: key);
//
//   final List<Photo> photos;
//
//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: 2,
//       ),
//       itemCount: photos.length,
//       itemBuilder: (context, index) {
//         return Column(
//           children: [
//             Image.network(photos[index].thumbnailUrl),
//             Text(photos[index].title),
//           ],
//         );
//       },
//     );
//   }
// }
