
import 'package:buysell/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProvider with ChangeNotifier {
  FirebaseService _service = FirebaseService();
  DocumentSnapshot? doc;
   DocumentSnapshot? userDetails;
  String? selectedCategory;
  String? selectedSubCat;
  List<String> urlList = [];
  Map<String,dynamic> datasToFirestore={};


  getCategory(selectedCat) {
    print('Selected Category: $selectedCat');
    this.selectedCategory = selectedCat.toString();
    notifyListeners();
  }
  getSubCategory(selectedsibCat) {
    print('Selected Category: $selectedsibCat');
    this.selectedSubCat = selectedsibCat.toString();
    notifyListeners();
  }

  getCatSnapshot(snapshot) {
    this.doc = snapshot;
    notifyListeners();
  }

  getImages(url) {
    this.urlList.add(url);
    notifyListeners();
  }
  getData(data){
    this.datasToFirestore=data;
    notifyListeners();

  }
  getUserDetails(){
    _service.getUserData().then((value) {
      this.userDetails=value;
      notifyListeners();
    });
  }
  clearData(){
    this.urlList=[];
    datasToFirestore={};
    notifyListeners();
  }
  clearSelectedCat(){
    this.selectedCategory=null;
    this.selectedSubCat=null;
    notifyListeners();
  }
}
