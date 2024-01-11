import 'package:buysell/Screens/product_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:search_page/search_page.dart';

import '../Screens/product_details_screen.dart';
import '../Screens/product_list_home.dart';

class Products {
  final String? title, description, category, subCat, price;
  final num? postedDate;
  final DocumentSnapshot? document;

  Products({
    this.title,
    this.description,
    this.category,
    this.subCat,
    this.price,
    this.postedDate,
    this.document,
  });
}

class SearchService {
  search({context, productList, address,provider,sellerDetails}) {
    showSearch(
      context: context,
      delegate: SearchPage<Products>(
          onQueryUpdate: print,
          items: productList,
          searchLabel: 'Search prodcuts',
          suggestion: SingleChildScrollView(child: ProductListhome()),
          failure: const Center(
            child: Text('No prodcuts found :('),
          ),
          filter: (product) => [
                product.title,
                product.description,
                product.subCat,
                product.category,
              ],
          builder: (product) {
            final _format = NumberFormat('##,##,##0');
            var _price =
                int.parse(product.price!); // Corrected field name to 'price'
            String _formattedPrice = '\$ ${_format.format(_price)}';

            var date =
                DateTime.fromMicrosecondsSinceEpoch(product.postedDate as int);
            var _date = DateFormat.yMMMd().format(date);

            return InkWell(
              onTap: (){
                provider.getProductDetails(product.document);
                provider.getSellerDetails(sellerDetails);
                Navigator.pushNamed(context, ProductDetailsScreen.id);
              },
              child: Container(
                height: 130.h,
                width: MediaQuery.of(context).size.width,
                child: Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          width: 100,
                          height: 120,
                          child: Image.network(product.document!['image'][0]),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _formattedPrice,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold, fontSize: 20),
                                ),
                                Text(product.title!)
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Posted at : $_date'),
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.location_on,
                                      size: 14,
                                      color: Colors.black38,
                                    ),
                                    Flexible(
                                        child: Container(
                                          width: MediaQuery.of(context).size.width-148,
                                            child: Text(address,overflow: TextOverflow.ellipsis,)))
                                  ],
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
