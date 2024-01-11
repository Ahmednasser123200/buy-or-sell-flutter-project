import 'package:buysell/forms/form_class.dart';
import 'package:buysell/forms/user_review_screen.dart';
import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:provider/provider.dart';

import '../widgets/imagePivker_widget.dart';

class FormsScreen extends StatefulWidget {
  static const String id = "form-screen";

  @override
  State<FormsScreen> createState() => _FormsScreenState();
}

class _FormsScreenState extends State<FormsScreen> {
  final _formkay = GlobalKey<FormState>();
  FirebaseService _service = FirebaseService();

  var _brandtext = TextEditingController();
  var _titelController = TextEditingController();
  var _descController = TextEditingController();
  var _pricController = TextEditingController();
  var _typeText = TextEditingController();
  var _badrooms = TextEditingController();
  var _Bathroom = TextEditingController();
  var _furnishing = TextEditingController();
  var _consStatus = TextEditingController();
  var _buildingSqft = TextEditingController();
  var _CarpetSqft = TextEditingController();
  var _totalFloors = TextEditingController();

  validate(CategoryProvider provider) {
    if (_formkay.currentState!.validate()) {
      if (provider.urlList.isNotEmpty) {
        provider.datasToFirestore.addAll({
          'category': provider.selectedCategory,
          'subCar': provider.selectedSubCat,
          'brand': _brandtext.text,
          'type': _typeText.text,
          'price': _pricController.text,
          'title': _titelController.text,
          'badrooms': _badrooms.text,
          'bathroom': _Bathroom.text,
          'furnishing': _furnishing.text,
          'constructionStatus': _consStatus.text,
          'buildingSqft': _buildingSqft.text,
          'CarpetSqft': _CarpetSqft.text,
          'totalFloors': _totalFloors.text,
          'description': _descController.text,
          'sellerUid': _service.user?.uid,
          'image': provider.urlList,
          'postedAt': DateTime.now().microsecondsSinceEpoch,
          'favourites':[]
        });

        print(provider.datasToFirestore);
        Navigator.pushNamed(context, UserReviewScreen.id);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("image not uploaded")));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Please complate required fields..")));
    }
  }

  FormClass _formClass = FormClass();

  @override
  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);
    showBrandDialog(list, _textController) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _formClass.appBar(_provider),
                  Expanded(
                    child: ListView.builder(
                        itemCount: list.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              setState(() {
                                _textController.text = list[index];
                              });
                              Navigator.pop(context);
                            },
                            title: Text(list[index]),
                          );
                        }),
                  )
                ],
              ),
            );
          });
    }

    showFormDialog(list, _textController) {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _formClass.appBar(_provider),
                  ListView.builder(
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          onTap: () {
                            setState(() {
                              _textController.text = list[index];
                            });
                            Navigator.pop(context);
                          },
                          title: Text(list[index]),
                        );
                      })
                ],
              ),
            );
          });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Add some details',
            style: TextStyle(color: Colors.black),
          ),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: Form(
        key: _formkay,
        child: Padding(
          padding: EdgeInsets.all(8.0.sp),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                    '${_provider!.selectedCategory!} > ${_provider.selectedSubCat}'),
                if (_provider.selectedSubCat == 'Mobiles Phone')
                  InkWell(
                    onTap: () {
                      showBrandDialog(_provider.doc!['brands'], _brandtext);
                    },
                    child: TextFormField(
                      controller: _brandtext,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Brands',
                      ),
                    ),
                  ),
                if (_provider.selectedSubCat == 'Accessories' ||
                    _provider.selectedSubCat == 'Tablets' ||
                    _provider.selectedSubCat == 'For Sales : House & Buildings'||_provider.selectedSubCat == 'For Rent : House & Buildings')
                  InkWell(
                    onTap: () {
                      if (_provider.selectedSubCat == 'Tablets') {
                        showFormDialog(_formClass.tabType, _typeText);
                      }
                      if (_provider.selectedSubCat ==
                          'For Sales : House & Buildings'||_provider.selectedSubCat == 'For Rent : House & Buildings') {
                        showFormDialog(_formClass.apartmentType, _typeText);
                      } else {
                        showFormDialog(_formClass.accessories, _typeText);
                      }
                    },
                    child: TextFormField(
                      controller: _typeText,
                      enabled: false,
                      decoration: InputDecoration(
                        labelText: 'Type',
                      ),
                    ),
                  ),
                if (_provider.selectedSubCat == 'For Sales : House & Buildings'||_provider.selectedSubCat == 'For Rent : House & Buildings')
                  Container(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            showFormDialog(_formClass.number, _badrooms);
                          },
                          child: TextFormField(
                            controller: _badrooms,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Badrooms',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showFormDialog(_formClass.number, _Bathroom);
                          },
                          child: TextFormField(
                            controller: _Bathroom,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Bathroom',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showFormDialog(_formClass.furnishing, _furnishing);
                          },
                          child: TextFormField(
                            controller: _furnishing,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Furnishing',
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            showFormDialog(_formClass.consStantus, _consStatus);
                          },
                          child: TextFormField(
                            controller: _consStatus,
                            enabled: false,
                            decoration: InputDecoration(
                              labelText: 'Construction Status',
                            ),
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,

                          controller: _buildingSqft,
                          decoration: InputDecoration(
                            labelText: 'Build SQFT',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,

                          controller: _CarpetSqft,
                          decoration: InputDecoration(
                            labelText: 'Carpet SQFT',
                          ),
                        ),
                        TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _totalFloors,
                          decoration: InputDecoration(
                            labelText: 'Total Floors',
                          ),
                        ),
                      ],
                    ),
                  ),
                TextFormField(
                  autofocus: false,
                  controller: _pricController,
                  keyboardType: TextInputType.number,
                  decoration:
                      InputDecoration(labelText: 'Price', prefixText: 'Rs'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please complete required field';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  maxLength: 50,
                  autofocus: false,
                  controller: _titelController,
                  decoration: InputDecoration(
                      labelText: 'Add title',
                      helperText:
                          'Mention the key features (e.g brand ,model)'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please complete required field';
                    }

                    return null;
                  },
                ),
                TextFormField(
                  maxLength: 4000,
                  minLines: 1,
                  maxLines: 30,
                  controller: _descController,
                  decoration: InputDecoration(
                      labelText: 'Description',
                      helperText:
                          'Include condition , features , reason for selling'),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please complete required field';
                    }
                    if (value.length < 30) {
                      return 'need to atleast 30 charectors';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 20.h,
                ),
                Divider(
                  color: Colors.grey,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: Colors.grey),
                  child: _provider.urlList.length == 0
                      ? Padding(
                          padding: EdgeInsets.all(10.sp),
                          child: Text(
                            'No image selected',
                            textAlign: TextAlign.center,
                          ),
                        )
                      : GalleryImage(
                          imageUrls: _provider.urlList,
                          numOfShowImages: _provider.urlList.length),
                ),
                SizedBox(
                  height: 10,
                ),
                NeumorphicButton(
                    width: double.infinity,
                    height: 60.h,
                    child: Container(
                      height: 40.h,
                      child: Center(
                        child: Text(_provider.urlList.length > 0
                            ? 'Uplode more image'
                            : "Uplode image"),
                      ),
                    ),
                    backgroundColor: Colors.black12,
                    bottomRightShadowColor: Colors.transparent,
                    topLeftShadowColor: Colors.transparent,
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return ImagePickerWidget();
                          });
                    }),
                SizedBox(
                  height: 100.h,
                )
              ],
            ),
          ),
        ),
      ),
      bottomSheet: Row(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(20.sp),
              child: NeumorphicButton(
                  borderColor: Theme.of(context).primaryColor,
                  padding: EdgeInsets.all(10.sp),
                  width: 70,
                  height: 40,
                  child: Text(
                    "Save",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  bottomRightShadowColor: Colors.transparent,
                  topLeftShadowColor: Colors.transparent,
                  onTap: () {
                    validate(_provider);
                  }),
            ),
          )
        ],
      ),
    );
  }
}
