import 'dart:async';
import 'dart:ffi';

import 'package:buysell/provider/product_provider.dart';
import 'package:buysell/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:map_launcher/map_launcher.dart'as launcher;
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'chat/chat_conversation_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  static const String id = 'product-details-screen';

  const ProductDetailsScreen({super.key});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late GoogleMapController _controller;
  FirebaseService _service = FirebaseService();
  bool _loading = true;
  int _index = 0;
  bool _isLiked = false;
  List fav = [];

  final _format = NumberFormat('##,##,##0');

  @override
  void initState() {
    Timer(Duration(seconds: 2), () {
      setState(() {
        _loading = false;
      });
    });
    super.initState();
  }
  _maplauncher(location) async {
    final availableMaps = await launcher. MapLauncher.installedMaps;
    print(availableMaps); // [AvailableMap { mapName: Google Maps, mapType: google }, ...]

    await availableMaps.first.showMarker(
      coords: launcher.Coords(location.latitude, location.longitude),
      title: "Seller Location is here",
    );
  }
  _callSeller(number){
    launch(number);
  }

  createChatRoom(ProductProvider _provider){
    Map <String,dynamic>product = {
      'productId':_provider.prosuctData!.id,
      'productImage' : _provider.prosuctData!['image'][0],
      'price' : _provider.prosuctData!['price'],
      'title' : _provider.prosuctData!['title'],
      'seller': _provider.prosuctData!['sellerUid'],
    };
    List<String>users = [
      _provider.sellerDetails!['uid'],
      _service.user!.uid
    ];
    String chatRoomId = '${_provider.sellerDetails!['uid']}.${ _service.user!.uid}.${_provider.prosuctData!.id}';
    Map<String,dynamic> chatData = {
     'users':users,
      'chatRoomId':chatRoomId,
      'read':false,
      'product':product,
      'lastChat':null,
      'lastChatTime':DateTime.now().microsecondsSinceEpoch
    };
    _service.createChatRoom(
      chatData: chatData
    );
    Navigator.push (
      context,
      MaterialPageRoute (
        builder: (BuildContext context) =>  ChatConvesation(chatRoomId: chatRoomId),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    var _productProvider = Provider.of<ProductProvider>(context);

    getFevouritems(_productProvider);
    super.didChangeDependencies();
  }

  getFevouritems( ProductProvider _productProvider){
    _service.products.doc(_productProvider.prosuctData!.id).get().then((value) {
      setState(() {
        fav = value['favourites'];
      });
      if(fav.contains(_service.user!.uid)){
        setState(() {
          _isLiked=true;
        });
      }else{
        setState(() {
          _isLiked=false;
        });
      }
    });
  }

  Widget build(BuildContext context) {
    var _productProvider = Provider.of<ProductProvider>(context);
    GeoPoint _location = _productProvider.sellerDetails!['location'];

    var data = _productProvider.prosuctData;
    var _peice = int.parse(data!['price']);
    String price = _format.format(_peice);

    var date = DateTime.fromMicrosecondsSinceEpoch(data['postedAt']);
    var _date = DateFormat.yMMMd().format(date);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.share_outlined,
                color: Colors.black,
              )),
          IconButton(
            icon: Icon(_isLiked?Icons.favorite:Icons.favorite_border),
            color: _isLiked?Colors.red:Colors.black,
            onPressed: (){
              setState(() {
                _isLiked=!_isLiked;
              });
              _service.updateFavourite(_isLiked, data.id, context);
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 12, right: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 300,
                  color: Colors.grey.shade300,
                  child: _loading
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                              Text('Loading your Ad'),
                            ],
                          ),
                        )
                      : Stack(
                          children: [
                            Center(
                              child: PhotoView(
                                backgroundDecoration:
                                    BoxDecoration(color: Colors.grey.shade300),
                                imageProvider:
                                    NetworkImage(data['image'][_index]),
                              ),
                            ),
                            Positioned(
                              bottom: 0.0,
                              child: Container(
                                height: 50.h,
                                width: MediaQuery.of(context).size.width,
                                child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: data['image'].length,
                                    itemBuilder: (BuildContext context, int i) {
                                      return InkWell(
                                        onTap: () {
                                          setState(() {
                                            _index = i;
                                          });
                                        },
                                        child: Container(
                                          height: 60.h,
                                          width: 60.w,
                                          child:
                                              Image.network(data['image'][i]),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              border: Border.all(
                                                  color: Theme.of(context)
                                                      .primaryColor)),
                                        ),
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                _loading
                    ? Container()
                    : Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  data['title'].toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                if (data['category'] == 'cars')
                                  Text('(${data['year']})')
                              ],
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              '\$ $price',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            if (data['category'] == 'cars')
                              Container(
                                color: Colors.grey.shade300,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 10, bottom: 10),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.filter_alt_outlined,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(
                                                data['fual'],
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.av_timer_outlined,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(
                                                _format.format(
                                                    int.parse(data['kmDrive'])),
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.account_tree_outlined,
                                                size: 12,
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(
                                                data['transmission'],
                                                style: TextStyle(fontSize: 12),
                                              )
                                            ],
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: Colors.grey,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 12, right: 12),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Icon(
                                                  CupertinoIcons.person,
                                                  size: 12,
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                                Text(
                                                  data['noOfOwners'],
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              width: 20.w,
                                            ),
                                            Expanded(
                                              child: Container(
                                                child: AbsorbPointer(
                                                  absorbing: true,
                                                  child: TextButton.icon(
                                                      onPressed: () {},
                                                      style: ButtonStyle(
                                                          alignment:
                                                              Alignment.center),
                                                      icon: Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        size: 12,
                                                        color: Colors.black,
                                                      ),
                                                      label: Text(
                                                        _productProvider
                                                                    .sellerDetails ==
                                                                null
                                                            ? ""
                                                            : _productProvider
                                                                    .sellerDetails![
                                                                'address'],
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )),
                                                ),
                                              ),
                                            ),
                                            Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'POSTED DATE',
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  Text(
                                                    _date,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'Description',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    color: Colors.grey.shade300,
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          if (data['subCar'] ==
                                                  'Mobiles Phone' ||
                                              data['subCar'] == null)
                                            Text('Brand: ${data['brand']}'),
                                          if (data['subCar'] == 'Accessories' ||
                                              data['subCar'] == 'Tablets' ||
                                              data['subCar'] ==
                                                  'For Sales : House & Buildings' ||
                                              data['subCar'] ==
                                                  'For Rent : House & Buildings')
                                            Text('Type: ${data['type']}'),
                                          if (data['subCar'] ==
                                                  'For Sales : House & Buildings' ||
                                              data['subCar'] ==
                                                  'For Rent : House & Buildings')
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(data['description']),
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                    'Badrooms: ${data['badrooms']}'),
                                                Text(
                                                    'Bathrooms: ${data['bathroom']}'),
                                                Text(
                                                    'Furnishing: ${data['furnishing']}'),
                                                Text(
                                                    'construction Status: ${data['constructionStatus']}'),
                                                Text(
                                                    'Total Floors: ${data['totalFloors']}'),

                                              ],
                                            ),
                                          SizedBox(height: 20.h,),

                                          Text('Posted at : $_date')
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey,
                            ),
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.blue.shade50,
                                  radius: 40.sp,
                                  child: Icon(
                                    CupertinoIcons.person_alt,
                                    color: Colors.red,
                                    size: 60.sp,
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: ListTile(
                                    title: Text(
                                      _productProvider.sellerDetails == null
                                          ? ""
                                          : _productProvider
                                              .sellerDetails!['name']
                                              .toUpperCase(),
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    subtitle: Text(
                                      'SEE PROFILE',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.blue),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.arrow_forward_ios,
                                        size: 12,
                                      ),
                                      onPressed: () {},
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Text(
                              'Ad Posted at',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Container(
                              height: 200,
                              color: Colors.grey.shade300,
                              child: Stack(
                                children: [
                                  Center(
                                    child: GoogleMap(
                                      initialCameraPosition: CameraPosition(
                                        zoom: 15,
                                        target: LatLng(_location.latitude,
                                            _location.longitude),
                                      ),
                                      mapType: MapType.normal,
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        setState(() {
                                          _controller = controller;
                                        });
                                      },
                                    ),
                                  ),
                                  Center(
                                      child: Icon(
                                    Icons.location_on,
                                    size: 35,
                                  )),
                                  Center(
                                    child: CircleAvatar(
                                      radius: 60,
                                      backgroundColor: Colors.black12,
                                    ),
                                  ),
                                  Positioned(
                                    right: 4.0,
                                    top: 4.0,
                                    child: Material(
                                      elevation: 4,
                                      shape: Border.all(color: Colors.grey),
                                      child: IconButton(
                                        icon: Icon(Icons.alt_route_outlined),
                                        onPressed: () {
                                          _maplauncher(_location);
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Ad ID : ${data['postedAt']}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                ),
                                TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'REPORT THIS AD',
                                      style: TextStyle(color: Colors.blue),
                                    ))
                              ],
                            ),
                            SizedBox(
                              height: 80,
                            )
                          ],
                        ),
                      ),
              ],
            ),
          ),
        ),
      ),
      bottomSheet: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(1),
          child:_productProvider.prosuctData!['sellerUid']==_service.user!.uid?

          Row(
            children: [
              Expanded(
                  child: NeumorphicButton(
                      padding: EdgeInsets.all(10),
                      width: 100,
                      height: 50,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Edit Product',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      bottomRightShadowColor: Colors.transparent,
                      topLeftShadowColor: Colors.transparent,
                      onTap: () {

                      })),
            ],
          )   : Row(
            children: [
               Expanded(
                  child: NeumorphicButton(
                      padding: EdgeInsets.all(10),
                      width: 100,
                      height: 50,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.chat_bubble,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'Chat',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      bottomRightShadowColor: Colors.transparent,
                      topLeftShadowColor: Colors.transparent,
                      onTap: () {
                        createChatRoom(_productProvider);
                      })),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                  child: NeumorphicButton(
                      padding: EdgeInsets.all(10),
                      width: 100,
                      height: 50,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            CupertinoIcons.phone,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            'call',
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      backgroundColor: Theme.of(context).primaryColor,
                      bottomRightShadowColor: Colors.transparent,
                      topLeftShadowColor: Colors.transparent,
                      onTap: () {
                        _callSeller('tel:${_productProvider.sellerDetails!['mobile']}');
                      })),
            ],
          ),
        ),
      ),
    );
  }
}
