import 'package:buysell/forms/user_review_screen.dart';
import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gallery_image_viewer/gallery_image_viewer.dart';
import 'package:galleryimage/galleryimage.dart';
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:provider/provider.dart';

import '../widgets/imagePivker_widget.dart';

class SellercarForm extends StatefulWidget {
  static const String id = "car_form";

  @override
  State<SellercarForm> createState() => _SellercarFormState();
}

class _SellercarFormState extends State<SellercarForm> {
  final _formkay = GlobalKey<FormState>();

  FirebaseService _service = FirebaseService();

  var _brandController = TextEditingController();
  var _yearController = TextEditingController();
  var _pricController = TextEditingController();
  var _fuleController = TextEditingController();
  var _transmissionController = TextEditingController();
  var _KmController = TextEditingController();
  var _noOfOwnerController = TextEditingController();
  var _descController = TextEditingController();
  var _addressController = TextEditingController();
  var _titelController = TextEditingController();
  String _address = '';

  validate(CategoryProvider provider) {
    if (_formkay.currentState!.validate()) {
      if (provider.urlList.isNotEmpty) {
        provider.datasToFirestore.addAll({
          'category': provider.selectedCategory,
          'subCar': provider.selectedSubCat,
          'brand': _brandController.text,
          'year': _yearController.text,
          'price': _pricController.text,
          'fual': _fuleController.text,
          'transmission': _transmissionController.text,
          'kmDrive': _KmController.text,
          "noOfOwners": _noOfOwnerController.text,
          'title': _titelController.text,
          'description': _descController.text,
          'sellerUid': _service.user?.uid,
          'image': provider.urlList,
          'postedAt':DateTime.now().microsecondsSinceEpoch,

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

  List<String> _fualList = ['Diesel', 'Petroi', 'ELectric', 'LPG'];
  List<String> _Transmission = ['Manually', 'Automatic'];
  List<String> _noOfOwner = ['1', '2nd', '3rd', '4th', '4th+'];

  @override
  void didChangeDependencies() {
    var _catProvider = Provider.of<CategoryProvider>(context);
    if (_catProvider.datasToFirestore != null &&
        _catProvider.datasToFirestore.isNotEmpty) {
      setState(() {
        _brandController.text = _catProvider.datasToFirestore['brand'] ?? '';
        _yearController.text = _catProvider.datasToFirestore['year'] ?? '';
        _pricController.text = _catProvider.datasToFirestore['price'] ?? '';
        _fuleController.text = _catProvider.datasToFirestore['fual'] ?? '';
        _transmissionController.text =
            _catProvider.datasToFirestore['transmission'] ?? '';
        _KmController.text = _catProvider.datasToFirestore['kmDrive'] ?? '';
        _noOfOwnerController.text =
            _catProvider.datasToFirestore['noOfOwners'] ?? '';
        _titelController.text = _catProvider.datasToFirestore['title'] ?? '';
        _descController.text =
            _catProvider.datasToFirestore['description'] ?? '';
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var _catProvider = Provider.of<CategoryProvider>(context);

    Widget _appBar(title, fieldValue) {
      return AppBar(
        backgroundColor: Colors.white,
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
        iconTheme: IconThemeData(color: Colors.black),
        automaticallyImplyLeading: false,
        title: Text(
          '$title > $fieldValue',
          style:
              TextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(14)),
        ),
      );
    }

    Widget _brandList() {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, 'brands'),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _catProvider.doc != null
                    ? _catProvider.doc!['models'].length
                    : 0,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      setState(() {
                        _brandController.text =
                            _catProvider.doc!['models'][index];
                      });
                      Navigator.pop(context);
                    },
                    title: Text(_catProvider.doc != null
                        ? _catProvider.doc!['models'][index].toString()
                        : ''),
                  );
                },
              ),
            )
          ],
        ),
      );
    }

    Widget _listView({fieldValue, list, textController}) {
      return Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _appBar(_catProvider.selectedCategory, fieldValue),
            ListView.builder(
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    onTap: () {
                      textController.text = list[index];
                      Navigator.pop(context);
                    },
                    title: Text(list[index]),
                  );
                })
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0,
        title: Text(
          'Add some details',
          style: TextStyle(color: Colors.black),
        ),
        shape: Border(bottom: BorderSide(color: Colors.grey.shade300)),
      ),
      body: SafeArea(
        child: Form(
          key: _formkay,
          child: Padding(
            padding: EdgeInsets.all(8.sp),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "CAR",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _brandList();
                          });
                    },
                    child: TextFormField(
                      controller: _brandController,
                      enabled: false,
                      decoration:
                          InputDecoration(labelText: 'Brand / Model / Variant'),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        if(value .length<5){
                          return 'Required minimum proce';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _yearController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'year'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
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
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'Fual',
                                list: _fualList,
                                textController: _fuleController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _fuleController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Fuel',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'Transmission',
                                list: _Transmission,
                                textController: _transmissionController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _transmissionController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Transmission',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    autofocus: false,
                    controller: _KmController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'KM Driven'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      return null;
                    },
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _listView(
                                fieldValue: 'No.of Owners',
                                list: _noOfOwner,
                                textController: _noOfOwnerController);
                          });
                    },
                    child: TextFormField(
                      enabled: false,
                      controller: _noOfOwnerController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'No. of owners',
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please complete required field';
                        }
                        return null;
                      },
                    ),
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
                      if(value.length<10){
                        return 'need atleast 10 charectors';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    maxLength: 4000,
                    minLines: 1,
                    maxLines: 30,
                    autofocus: false,
                    controller: _descController,
                    decoration: InputDecoration(
                        labelText: 'Description',
                        helperText:
                            'Include condition , features , reason for selling'),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Please complete required field';
                      }
                      if(value.length<30){
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
                    child: _catProvider.urlList.length == 0
                        ? Padding(
                            padding: EdgeInsets.all(10.sp),
                            child: Text(
                              'No image selected',
                              textAlign: TextAlign.center,
                            ),
                          )
                        : GalleryImage(
                            imageUrls: _catProvider.urlList,
                            numOfShowImages: _catProvider.urlList.length),
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
                          child: Text(_catProvider.urlList.length > 0
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
                    validate(_catProvider);
                    print(
                        "============================${_catProvider.datasToFirestore}");
                  }),
            ),
          )
        ],
      ),
    );
  }
}
