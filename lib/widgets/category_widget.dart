import 'package:buysell/Screens/authenfiktcation/categories/category_list.dart';
import 'package:buysell/Screens/sellitems/seller_subCat.dart';
import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/services/firebase_service.dart';
import 'package:buysell/Screens/product_by_category_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../Screens/authenfiktcation/categories/subCat_screen.dart';

class Categorywidget extends StatelessWidget {
  const Categorywidget({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);

    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.orderBy("sortId",descending: false).get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            return Container(
              height: 180,
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(child: Text('Categories')),
                      TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, categoryListScreen.id);
                          },
                          child: Row(
                            children: [
                              Text(
                                "See all",
                                style: TextStyle(color: Colors.black),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: ScreenUtil().setSp(12),
                                color: Colors.black,
                              )
                            ],
                          ))
                    ],
                  ),
                  Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (BuildContext context, int index) {
                            var doc = snapshot.data!.docs[index];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: (){
                                  _catProvider.getCategory(doc['catName']);
                                  _catProvider.getCatSnapshot(doc);
                                  if (doc['subCat'] == null) {
                                    _catProvider.getSubCategory(null);
                                    Navigator.pushNamed(context, productByCategory.id);
                                  } else {
                                    Navigator.pushNamed(context, SubCatList.id, arguments: doc);
                                  }

                                },
                                child: Container(
                                  width: 80.w,
                                  height: 50.h,
                                  child: Column(
                                    children: [
                                      Image.network(doc['image'], width: 40),
                                      Flexible(
                                          child: Text(
                                        doc['catName'],
                                        maxLines: 2,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: ScreenUtil().setSp(10)),
                                      ))
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }))
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
