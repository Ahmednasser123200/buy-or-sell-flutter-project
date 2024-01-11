import 'package:buysell/Screens/product_list.dart';
import 'package:buysell/provider/cat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class productByCategory extends StatelessWidget {
  static const String id = 'product-by-cat';

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          _catProvider.selectedSubCat == null
              ? 'cars'
              :'${ _catProvider.selectedCategory!} > ${ _catProvider.selectedCategory!}',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(child: ProductList(true)),
    );
  }
}
