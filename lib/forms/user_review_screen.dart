import 'package:buysell/Screens/authenfiktcation/categories/category_list.dart';
import 'package:buysell/Screens/location_screen.dart';
import 'package:buysell/provider/cat_provider.dart';
import 'package:buysell/services/firebase_service.dart';
import 'package:buysell/services/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neumorphic_button/neumorphic_button.dart';
import 'package:provider/provider.dart';

class UserReviewScreen extends StatefulWidget {
  static const String id = 'user-review-screen';

  @override
  State<UserReviewScreen> createState() => _UserReviewScreenState();
}

class _UserReviewScreenState extends State<UserReviewScreen> {
  final _formkay = GlobalKey<FormState>();
  bool _loading = false;
  FirebaseService _service = FirebaseService();
  var _nameController = TextEditingController();
  var _countryCodeController = TextEditingController(text: '+20');
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _addressController = TextEditingController();

  @override
  void initState() {
    _service.getUserData().then((value) {
      setState(() {
        _nameController.text = value['name'] ?? '';
        _phoneController.text =
            value['mobile'] != null ? value['mobile'].substring(3) ?? '' : '';
        _emailController.text = value['email'] ?? '';
        _addressController.text = value['address'] ?? '';
      });
    });
    super.initState();
  }

  Future<void> updateUser(provider, Map<String, dynamic> data, context) async {
    try {
      await _service.users.doc(_service.user?.uid).update(data).then((value) {
        saveProductToDb(provider, context);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to Update user data")),
      );
    }
  }

  Future<void> saveProductToDb(CategoryProvider provider, context) async {
    try {
      await _service.products

          .add(provider.datasToFirestore)
          .then((value) {
        provider.clearData();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text(
                  "we have received your products and will be notified you once get approved")),
        );
        Navigator.pushReplacementNamed(
            context, MainScreen.id);
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to Update user data")),
      );
    }
  }

  void didChangeDependencies() {
    var _provider = Provider.of<CategoryProvider>(context);
    _provider.getUserDetails();
    setState(() {
      _nameController.text = _provider.userDetails?['name'] ?? '';
      _phoneController.text = _provider.userDetails?['mobile'] ?? '';
      _emailController.text = _provider.userDetails?['email'] ?? '';
      _addressController.text = _provider.userDetails?['address'] ?? '';
    });
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    var _provider = Provider.of<CategoryProvider>(context);
    showConfirmDialog() {
      return showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "confirm",
                      style: TextStyle(
                          fontSize: ScreenUtil().setSp(18),
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text('Are you sure , you want to save below product'),
                    SizedBox(
                      height: 10.h,
                    ),
                    ListTile(
                      leading: _provider.datasToFirestore != null &&
                              _provider.datasToFirestore['image'] != null
                          ? Image.network(_provider.datasToFirestore?['image']
                                  [0] ??
                              'fallback_image_url')
                          : Text("no foto"),
                      title: Text(
                        _provider.datasToFirestore['title'],
                        maxLines: 1,
                      ),
                      subtitle: Text(
                        _provider.datasToFirestore['price'],
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        NeumorphicButton(
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                          borderColor: Theme.of(context).primaryColor,
                          backgroundColor: Colors.transparent,
                          bottomRightShadowColor: Colors.transparent,
                          topLeftShadowColor: Colors.transparent,
                          height: 35,
                          width: 90,
                          child: Text('Cancel'),
                          onTap: () {
                            setState(() {
                              _loading = false;
                            });
                            Navigator.pop(context);
                          },
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        NeumorphicButton(
                          padding:
                              EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                          backgroundColor: Theme.of(context).primaryColor,
                          bottomRightShadowColor: Colors.transparent,
                          topLeftShadowColor: Colors.transparent,
                          height: 35,
                          width: 90,
                          child: Text(
                            'confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                          onTap: () {
                            print('Button tapped!');
                            setState(() {
                              _loading = true;
                            });

                            updateUser(
                                    _provider,
                                    {
                                      'contactDetails': {
                                        'contactMobile': _phoneController.text,
                                        'contactEmail': _emailController.text
                                      },
                                      'name': _nameController.text,
                                    },
                                    context)
                                .then((value) {
                              setState(() {
                                _loading = false;
                              });

                            });
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    if (_loading)
                      Center(
                          child: CircularProgressIndicator(
                        color: Theme.of(context).primaryColor,
                      ))
                  ],
                ),
              ),
            );
          });
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
      body: Form(
        key: _formkay,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        radius: 40.sp,
                        child: Icon(
                          CupertinoIcons.person_alt,
                          color: Colors.red,
                          size: 60.sp,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        child: TextFormField(
                          controller: _nameController,
                          decoration: InputDecoration(labelText: 'your Name'),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter your name';
                            }
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Text(
                    "contact Details",
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(30),
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                          flex: 1,
                          child: TextFormField(
                            controller: _countryCodeController,
                            enabled: false,
                            decoration: InputDecoration(
                                labelText: 'country', helperText: ''),
                          )),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          flex: 3,
                          child: TextFormField(
                            controller: _phoneController,
                            decoration: InputDecoration(
                                labelText: 'Mobile number',
                                helperText: 'Enter contact mobile number'),
                            maxLength: 10,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter mobile number';
                              }
                            },
                          )),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: 'Email', helperText: 'Enter contact email'),
                    // validator: (value) {
                    //   final bool isValid =
                    //   EmailValidator.validate(_emailcontroller.text);
                    //   if (value == null || value.isEmpty) {
                    //     return 'Enter email';
                    //   }
                    //   if (value.isEmpty && isValid == false) {
                    //     return 'Enter valid email';
                    //   }
                    //   return null;
                    // },
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          minLines: 2,
                          maxLines: 4,
                          controller: _addressController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              helperText: 'Cnotact address',
                              labelText: ' Address',
                              counterText: 'Seller address'),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => Locationscreen(
                                      popScreen: UserReviewScreen.id,
                                    )),
                          );
                        },
                        icon: Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 150.h,)
                ],
              ),
            ),
          ),
        ),
        // FutureBuilder<DocumentSnapshot>(
        //   future: _service.getUserData(),
        //   builder:
        //       (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        //
        //     if (snapshot.hasError) {
        //       return Text("Something went wrong");
        //     }
        //
        //     if (snapshot.hasData && !snapshot.data!.exists) {
        //       return Text("Document does not exist");
        //     }
        //
        //     if (snapshot.connectionState == ConnectionState.waiting) {
        //       return Center(
        //         child: CircularProgressIndicator(
        //           valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        //         ),
        //       );
        //
        //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
        //       return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        //     }
        //     _nameController.text =snapshot.data?['name'];
        //     _phoneController.text =snapshot.data?['mobile'];
        //     _emailController.text =snapshot.data?['email'];
        //     _addressController.text =snapshot.data?['address'];
        //     return
        //         SingleChildScrollView(
        //           child: Padding(
        //             padding: const EdgeInsets.all(8.0),
        //             child: Column(
        //               crossAxisAlignment: CrossAxisAlignment.start,
        //               children: [
        //                 Row(
        //                   children: [
        //                     CircleAvatar(
        //                       backgroundColor: Colors.blue.shade50,
        //                       radius: 40.sp,
        //                       child: Icon(
        //                         CupertinoIcons.person_alt,
        //                         color: Colors.red,
        //                         size: 60.sp,
        //                       ),
        //                     ),
        //                     SizedBox(
        //                       width: 10.w,
        //                     ),
        //                     Expanded(
        //                       child: TextFormField(
        //                         controller: _nameController,
        //                         decoration: InputDecoration(labelText: 'your Name'),
        //                         validator: (value) {
        //                           if (value!.isEmpty) {
        //                             return 'Enter your name';
        //                           }
        //                         },
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //                 SizedBox(
        //                   height: 30.h,
        //                 ),
        //                 Text(
        //                   "contact Details",
        //                   style: TextStyle(
        //                       fontSize: ScreenUtil().setSp(30),
        //                       fontWeight: FontWeight.bold),
        //                 ),
        //                 SizedBox(
        //                   height: 10.h,
        //                 ),
        //                 Row(
        //                   children: [
        //                     Expanded(
        //                         flex: 1,
        //                         child: TextFormField(
        //                           controller: _countryCodeController,
        //                           enabled: false,
        //                           decoration: InputDecoration(
        //                               labelText: 'country', helperText: ''),
        //                         )),
        //                     SizedBox(
        //                       width: 10,
        //                     ),
        //                     Expanded(
        //                         flex: 3,
        //                         child: TextFormField(
        //                           controller: _phoneController,
        //                           decoration: InputDecoration(
        //                               labelText: 'Mobile number',
        //                               helperText: 'Enter contact mobile number'),
        //                           maxLength: 10,
        //                           validator: (value) {
        //                             if (value!.isEmpty) {
        //                               return 'Enter mobile number';
        //                             }
        //                           },
        //                         )),
        //                   ],
        //                 ),
        //                 SizedBox(
        //                   height: 30.h,
        //                 ),
        //                 TextFormField(
        //                   controller: _emailController,
        //                   decoration: InputDecoration(
        //                       labelText: 'Email', helperText: 'Enter contact email'),
        //                   // validator: (value) {
        //                   //   final bool isValid =
        //                   //   EmailValidator.validate(_emailcontroller.text);
        //                   //   if (value == null || value.isEmpty) {
        //                   //     return 'Enter email';
        //                   //   }
        //                   //   if (value.isEmpty && isValid == false) {
        //                   //     return 'Enter valid email';
        //                   //   }
        //                   //   return null;
        //                   // },
        //                 ),
        //                 SizedBox(
        //                   height: 20.h,
        //                 ),
        //                 TextFormField(
        //                   enabled: false,
        //                   minLines: 2,
        //                   maxLines: 4,
        //                   controller: _addressController,
        //                   keyboardType: TextInputType.number,
        //                   decoration: InputDecoration(
        //                       helperText: 'Cnotact address',
        //                       labelText: ' Address',
        //                       counterText: 'Seller address'),
        //                   validator: (value) {
        //                     if (value!.isEmpty) {
        //                       return 'Please complete required field';
        //                     }
        //                     return null;
        //                   },
        //                 ),
        //               ],
        //             ),
        //           ),
        //         );
        //
        //
        //   },
        // ),
      ),
      bottomSheet: Padding(
        padding: EdgeInsets.all(20.sp),
        child: Row(
          children: [
            NeumorphicButton(
              backgroundColor: Theme.of(context).primaryColor,
              width: 300,
              height: 50,
              onTap: () {

                if (_formkay.currentState!.validate()) {
                  showConfirmDialog();
                  //
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter required fields")));
                }
              },
              bottomRightShadowColor: Colors.transparent,
              topLeftShadowColor: Colors.transparent,
              child: Text(
                'Confirm',
                textAlign: TextAlign.center,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
