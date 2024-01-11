import 'package:buysell/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../provider/cat_provider.dart';
import '../widgets/product_card.dart';

class ProductListhome extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    final _format = NumberFormat('##,##,##0');
    var _catProvider = Provider.of<CategoryProvider>(context);

    String _KmFormatted(km) {
      var _km = int.parse(km);
      var _formattedkm = _format.format(_km);
      return _formattedkm;
    }

    return Container(
      width: MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: FutureBuilder<QuerySnapshot>(
          future:
           _service.products
              .orderBy('postedAt').get(),
          // _service.products
          //     .orderBy('postedAt')
          //     .where('subCar', isEqualTo: _catProvider.selectedSubCat)
          //     .get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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

            if (snapshot.data?.docs.length == 0) {
              return Container(
                  height: MediaQuery.of(context).size.width,
                  child: Center(
                    child: Text('No Products added \n under selected this category',textAlign: TextAlign.center,),
                  ));
            }

            return Column(
              children: [

                  Container(
                    height: 56,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Fresh Recommendations',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
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
                    var _price = int.parse(
                        data['price']); // Corrected field name to 'price'
                    String _formattedPrice = '\$ ${_format.format(_price)}';
                    return ProductCard(
                        data: data, formattedPrice: _formattedPrice);
                  },
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
