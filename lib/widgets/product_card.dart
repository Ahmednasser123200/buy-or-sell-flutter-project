import 'package:buysell/provider/product_provider.dart';
import 'package:buysell/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';

import '../Screens/product_details_screen.dart';

class ProductCard extends StatefulWidget {
  const ProductCard({
    super.key,
    required this.data,
    required String formattedPrice,
  }) : _formattedPrice = formattedPrice;

  final QueryDocumentSnapshot<Object?> data;
  final String _formattedPrice;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  FirebaseService _service = FirebaseService();
  final _format = NumberFormat('##,##,##0');

  String address = '';
  DocumentSnapshot? sellerDetails;
  bool _isLiked = false;
  List fav = [];

  String _KmFormatted(km) {
    var _km = int.parse(km);
    var _formattedkm = _format.format(_km);
    return _formattedkm;
  }

  @override
  void initState() {
    getFevouritems();
    getSellerData();
    super.initState();
  }
  getSellerData(){
    _service.getSellerData(widget.data['sellerUid']).then((value) {
      if (mounted) {
        setState(() {
          address = value['address'];
          sellerDetails=value;
        });
      }
    });
  }

  getFevouritems(){
    _service.products.doc(widget.data.id).get().then((value) {
      if(mounted){
        setState(() {
          fav = value['favourites'];
        });
      }
      if(fav.contains(_service.user!.uid)){
        if(mounted){
          setState(() {
            _isLiked=true;
          });
        }
      }else{
       if(mounted){
         setState(() {
           _isLiked=false;
         });
       }
      }
    });
  }

  @override



  Widget build(BuildContext context) {
    var _provider = Provider.of<ProductProvider>(context);

    return InkWell(
      onTap: () {
        _provider.getProductDetails(widget.data);
        _provider.getSellerDetails(sellerDetails);
        Navigator.pushNamed(context, ProductDetailsScreen.id);
      },
      child: Container(

        decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).primaryColor.withOpacity(.8),
            ),
            borderRadius: BorderRadius.circular(4)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 Container(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         height: 100,
                         child: Center(
                           child: Image.network(widget.data['image'][0]),
                         ),
                       ),
                       SizedBox(
                         height: 10,
                       ),
                       Text(
                         widget._formattedPrice,
                         style: TextStyle(fontWeight: FontWeight.bold),
                       ),
                       Text(
                         widget.data['title'],
                         maxLines: 1,
                         overflow: TextOverflow.ellipsis,
                       ),
                       widget.data['category'] == 'cars'
                           ? Text(
                           '${widget.data['year']} - ${_KmFormatted(widget.data['kmDrive'])} Km')
                           : Text(''),
                       SizedBox(
                         height: 10,
                       ),
                     ],
                   ),
                 ),
                  Row(
                    children: [
                      Icon(
                        Icons.location_pin,
                        size: 14,
                        color: Colors.black38,
                      ),
                      Flexible(
                          child: Text(
                        address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                    ],
                  )
                ],
              ),
              Positioned(
                right: 0.0,
                child:IconButton(
                  icon: Icon(_isLiked?Icons.favorite:Icons.favorite_border),
                  color: _isLiked?Colors.red:Colors.black,
                  onPressed: (){
                    setState(() {
                      _isLiked=!_isLiked;
                    });
                    _service.updateFavourite(_isLiked, widget.data.id, context);
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
