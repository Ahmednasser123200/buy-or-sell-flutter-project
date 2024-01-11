import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class ProductProvider with ChangeNotifier{
  DocumentSnapshot? prosuctData;
  DocumentSnapshot? sellerDetails;

  getProductDetails(details){
    this.prosuctData=details;
    notifyListeners();
  }
  getSellerDetails(details){
    this.sellerDetails=details;
    notifyListeners();
  }
}