import 'package:buysell/Screens/home_screen.dart';
import 'package:buysell/Screens/location_screen.dart';
import 'package:buysell/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Screens/LoginScreen.dart';
import '../provider/product_provider.dart';
import '../services/search_service.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  FirebaseService _service = FirebaseService();
  SearchService _search = SearchService();
  static List<Products> products = [];

  String address = '';
  DocumentSnapshot? sellerDetails;

  @override
  void initState() {
    _service.products.get().then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((doc) {
        setState(() {
          products.add(
            Products(
                document: doc,
                title: doc['title'],
                category: doc['category'],
                description: doc['description'],
                subCat: doc['subCar'],
                postedDate: doc['postedAt'],
                price: doc['price']),
          );
          getSellerAddress(doc['sellerUid']);
        });
      });
    });
    super.initState();
  }

  getSellerAddress(sellerId) {
    _service.getSellerData(sellerId).then((value) {
     if(mounted){
       setState(() {
         address = value['address'];
         sellerDetails = value;
       });
     }
    });
  }

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return FutureBuilder<DocumentSnapshot>(
      future: _service.users.doc(_service.user!.uid).get(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.hasError) {
          return Text("something went wrong");
        }

        if (snapshot.hasData && !snapshot.data!.exists) {
          return Text("Address not selected");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          if (data['address'] == null) {
            GeoPoint latlong = data['location'];
            _service
                .getAddress(latlong.latitude, latlong.longitude)
                .then((adres) {
              return appBar(adres, context, _provider, sellerDetails);
            });
          } else {
            return appBar(data['address'], context, _provider, sellerDetails);
          }
        }

        return appBar('Fetching location', context, _provider, sellerDetails);
      },
    );
  }

  Widget appBar(address, context, _provider,sellerDetails) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: address == null
          ? CircularProgressIndicator()
          : InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Locationscreen(
                              popScreen: HomeScreen.id,
                            )));
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.only(top: 8.h, bottom: 8.h),
                  child: Row(
                    children: [
                      Icon(
                        CupertinoIcons.location_solid,
                        color: Colors.black,
                        size: ScreenUtil().setWidth(18),
                      ),
                      Text(
                        address!,
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: ScreenUtil().setSp(12),
                            fontWeight: FontWeight.bold),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down_outlined,
                        color: Colors.black,
                        size: ScreenUtil().setWidth(18),
                      )
                    ],
                  ),
                ),
              ),
            ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: InkWell(
          onTap: () {},
          child: Container(
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: ScreenUtil().setHeight(30),
                    child: TextField(
                      onTap: () {
                        _search.search(
                            context: context,
                            productList: products,
                            address: address,
                            provider: _provider,
                            sellerDetails: sellerDetails);
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.search),
                          labelText: 'Find Cars,Mobiles and many more',
                          labelStyle:
                              TextStyle(fontSize: ScreenUtil().setSp(12)),
                          contentPadding:
                              EdgeInsets.only(left: 10.w, right: 10.w),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(
                                  ScreenUtil().setSp(6)))),
                    ),
                  ),
                ),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                Icon(Icons.notifications_none),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
