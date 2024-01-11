import 'package:buysell/provider/cat_provider.dart';
import 'package:flutter/material.dart';

class FormClass {
  List accessories = [
    'Mobile',
    'Tablets'
  ];
  List tabType = [
    'Ipads',
    'Samsung',
    'Other Tablets'
  ];
  List apartmentType = [
    'Apartment',
    'Farm Houses',
    'Houses & Villas'
  ];
  List furnishing=[
    'Furnished',
    'Sami-Furnished',
    'Unfurnished'
  ];
  List consStantus=[
    'New Launch',
    'Ready to Move',
    'Under Construction'
  ];
  List number= [
    '1','2','3','4','4+'
  ];
  Widget appBar(CategoryProvider _provider) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
      shape: Border(
        bottom: BorderSide(color: Colors.grey.shade300),
      ),
      title: Text(
        _provider?.selectedSubCat ?? 'Default Subcategory',
        style: TextStyle(color: Colors.black),
      ),
    );
  }
}
