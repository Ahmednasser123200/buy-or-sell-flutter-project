import 'package:buysell/forms/forms_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../services/firebase_service.dart';
import '../../provider/cat_provider.dart';
class SellerSUbCatList extends StatelessWidget {
 static const String id = 'seller-subcat-screen';

  @override
  Widget build(BuildContext context) {

    DocumentSnapshot args = ModalRoute.of(context)!.settings.arguments as DocumentSnapshot;
    FirebaseService _service = FirebaseService();
    var _catProvider = Provider.of<CategoryProvider>(context);



    return  Scaffold(
      appBar: AppBar(
        elevation: 0,
        shape: Border(
          bottom: BorderSide(color: Colors.grey),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          args["catName"],
          style: TextStyle(color: Colors.black,fontSize: ScreenUtil().setSp(18)),
        ),
      ),
      body:Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: _service.categories.doc(args.id).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Container();
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            var data = snapshot.data!['subCat'];
            return Container(
                child: ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {

                      return Padding(
                        padding:  EdgeInsets.only(left: 8.w,right: 8.w),
                        child: ListTile(
                          onTap: (){
                            _catProvider.getSubCategory(data[index]);
                            Navigator.pushNamed(context, FormsScreen.id);
                          },

                          title: Text(
                            data[index],
                            style: TextStyle(fontSize: ScreenUtil().setSp(15)),
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
