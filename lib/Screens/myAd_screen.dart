// ... (previous imports)

import 'package:buysell/Screens/sellitems/seller_category_list.dart';
import 'package:buysell/services/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../services/firebase_service.dart';
import '../widgets/product_card.dart';

class MyAdsScreen extends StatelessWidget {
  const MyAdsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _format = NumberFormat('##,##,##0');

    String _KmFormatted(km) {
      var _km = int.parse(km);
      var _formattedkm = _format.format(_km);
      return _formattedkm;
    }

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,

          elevation: 0,
          title: Text(
            'My Ads',
            style: TextStyle(color: Colors.black),
          ),
          bottom: TabBar(
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            indicatorWeight: 6,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(
                child: Text('ADS',style: TextStyle(color: Theme.of(context).primaryColor),),
              ),
              Tab(
                child: Text("FAVOURITES",style: TextStyle(color: Theme.of(context).primaryColor),),
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 'ADS' Tab
         

            // 'FAVOURITES' Tab
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: FutureBuilder<QuerySnapshot>(
                    future: _service.products.where('sellerUid',isEqualTo: _service.user!.uid).orderBy('postedAt').get(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }
              
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 140, right: 140),
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                            backgroundColor: Colors.grey,
                          ),
                        );
                      }
              
                      if (snapshot.data!.docs.length == 0) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'No Ads given yet',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, SellerCategory.id);
                                },
                                child: Text('Ad Products',style: TextStyle(color: Colors.white),),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor)),
                              )
                            ],
                          ),
                        );
                      }
              
                      return Column(
                        children: [
                          Container(
                            height: 56,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('Fresh Recommendations', style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 2 / 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: snapshot.data!.size,
                            itemBuilder: (BuildContext context, int i) {
                              var data = snapshot.data!.docs[i];
                              var _price = int.parse(data['price']); // Corrected field name to 'price'
                              String _formattedPrice = '\$ ${_format.format(_price)}';
                              return ProductCard(data: data, formattedPrice: _formattedPrice);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _service.products.where('favourites',arrayContains: _service.user!.uid).snapshots(),
                    builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Text('Something went wrong');
                      }

                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 140, right: 140),
                          child: LinearProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                            backgroundColor: Colors.grey,
                          ),
                        );
                      }

                      if (snapshot.data!.docs.length == 0) {
                        return Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'No favourites yet',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, MainScreen.id);
                                },
                                child: Text('Ad Favourites',style: TextStyle(color: Colors.white),),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).primaryColor)),
                              )
                            ],
                          ),
                        );
                      }

                      return Column(
                        children: [
                          Container(
                            height: 56,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('My Ads', style: TextStyle(fontWeight: FontWeight.bold),),
                            ),
                          ),
                          GridView.builder(
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 2 / 3,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 10,
                            ),
                            itemCount: snapshot.data!.size,
                            itemBuilder: (BuildContext context, int i) {
                              var data = snapshot.data!.docs[i];
                              var _price = int.parse(data['price']); // Corrected field name to 'price'
                              String _formattedPrice = '\$ ${_format.format(_price)}';
                              return ProductCard(data: data, formattedPrice: _formattedPrice);
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
