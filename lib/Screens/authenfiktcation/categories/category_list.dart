import 'package:buysell/Screens/authenfiktcation/categories/subCat_screen.dart';
import 'package:buysell/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:buysell/Screens/product_by_category_screen.dart';
import 'package:provider/provider.dart';

import '../../../provider/cat_provider.dart';


class categoryListScreen extends StatelessWidget {
  static const String id = 'category-list-screens';

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    FirebaseService _service = FirebaseService();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          'Categories',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        child: FutureBuilder<QuerySnapshot>(
          future: _service.categories.get(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            return Container(
                child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = snapshot.data!.docs[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(

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
                          leading: Image.network(
                            doc['image'],
                            width: 40.w,
                          ),
                          title: Text(
                            doc['catName'],
                            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 15,
                          ),
                        ),
                      );
                    }));
          },
        ),
      ),
    );
  }
}
