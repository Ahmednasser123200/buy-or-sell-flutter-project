import 'package:buysell/Screens/home_screen.dart';
import 'package:buysell/services/firebase_service.dart';
import 'package:buysell/services/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';
import 'package:location/location.dart'
    as location; // Import Location with a prefix
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart';

class Locationscreen extends StatefulWidget {
  static const String id = 'location-screen';
  final String? popScreen;

  Locationscreen({this.popScreen});

  @override
  State<Locationscreen> createState() => _LocationscreenState();
}

class _LocationscreenState extends State<Locationscreen> {
  FirebaseService _service = FirebaseService();
  bool _loading = true;
  location.Location locationInstance =
      location.Location(); // Specify the correct Location class

  late bool _serviceEnabled;
  late PermissionStatus _permissionGranted;
  late location.LocationData _locationData;
  String? _address;
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String? ManualAddress;

  Future<location.LocationData?> getlocation() async {
    _serviceEnabled = await locationInstance.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await locationInstance.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await locationInstance.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await locationInstance.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _locationData = await locationInstance.getLocation();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        _locationData.latitude!, _locationData.longitude!);
    setState(() {
      _address = placemarks.isNotEmpty
          ? "${placemarks[0].country}"
              "/"
              "${placemarks[0].administrativeArea}"
              "/"
              "${placemarks[0].street}"
          : "Unknown";
    });
    print(_locationData);
    return _locationData;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.popScreen==null){
      _service.users
          .doc(_service.user?.uid)
          .get()
          .then((DocumentSnapshot document) {
        if (document.exists) {
          if (document['address'] != null) {
            if(mounted){
              setState(() {
                _loading = true;
              });
            }
            Navigator.pushReplacementNamed(context, MainScreen.id);
          } else {
            setState(() {
              _loading = false;
            });
          }
        }
      });
    }else{
    setState(() {
      _loading=false;
    });
    }


    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      loadingText: "Fetching location",
      progressIndicatorColor: Colors.redAccent,
    );
    showBottemScreen(context) {
      getlocation().then((location) {
        if (location != null) {
          progressDialog.dismiss();
          showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              context: context,
              builder: (context) {
                return Column(
                  children: [
                    SizedBox(
                      height: 26.h,
                    ),
                    AppBar(
                      automaticallyImplyLeading: false,
                      iconTheme: IconThemeData(color: Colors.black),
                      elevation: 1,
                      backgroundColor: Colors.white,
                      title: Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(Icons.clear)),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            'Location',
                            style: TextStyle(color: Colors.black),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.w),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(6)),
                        child: SizedBox(
                          height: 40.h,
                          child: TextFormField(
                            decoration: InputDecoration(
                                hintText: 'Search city ,area or neigbourhood ',
                                hintStyle: TextStyle(color: Colors.grey),
                                icon: Icon(Icons.search)),
                          ),
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        progressDialog.show();
                        getlocation().then((value) {
                          if (value != null) {
                            _service.updateUser({
                              'location':
                                  GeoPoint(value!.latitude!, value!.longitude!),
                              "address": _address
                            }, context,widget.popScreen).then((value) {
                              progressDialog.dismiss();
                             // return Navigator.push(
                             //   context,
                             //   MaterialPageRoute(
                             //     builder: (BuildContext context) =>
                             //         Locationscreen(popScreen: widget.popScreen, locationchanging: true),
                             //   ),
                             // );

                            });
                          }
                        });
                      },
                      leading: Icon(
                        Icons.my_location,
                        color: Colors.blue,
                      ),
                      title: Text(
                        'Use current location',
                        style: TextStyle(
                            color: Colors.blue, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        location == null ? 'Fething location' : _address!,
                        style: TextStyle(fontSize: ScreenUtil().setSp(12)),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey.shade300,
                      child: Padding(
                        padding:
                            EdgeInsets.only(left: 10.w, bottom: 4.h, top: 4.w),
                        child: Text(
                          'CHOOSE CITY',
                          style: TextStyle(
                              color: Colors.blueGrey.shade900,
                              fontSize: ScreenUtil().setSp(12)),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(10.w, 0.w, 10.w, 0.w),
                      child: /* CSCPicker(
                    onCountryChanged: (value) {
                      print("countryChanged $value");
                      if (value != null) {
                        setState(() {
                          countryValue = value!;
                          print("Country: $countryValue");
                        });
                      }
                    },
                    onStateChanged: (value) {
                      print("stateChanged $value");
                      if (value != null) {
                        setState(() {
                          stateValue = value!;
                          print("State: $stateValue");
                        });
                      }
                    },
                    onCityChanged: (value) {
                      print("cityChanged $value");
                      if (value != null) {
                        setState(() {
                          cityValue = value!;
                          print("City: $cityValue");
                        });
                      }
                    },
                    // ... rest of the code
                  ),*/
                          CSCPicker(
                        layout: Layout.vertical,
                        dropdownDecoration:
                            BoxDecoration(shape: BoxShape.rectangle),
                        flagState: CountryFlag.DISABLE,
                        onCountryChanged: (value) {
                          print("countryChanged $value");
                          if (value != null) {
                            setState(() {
                              countryValue = value!;
                              print("Country: $countryValue");
                            });
                          }
                        },
                        onStateChanged: (value) {
                          print("stateChanged $value");
                          if (value != null) {
                            setState(() {
                              stateValue = value!;
                              print("State: $stateValue");
                            });
                          }
                        },
                        onCityChanged: (value) {
                          print("cityChanged $value");
                          if (value != null) {
                            setState(() {
                              cityValue = value!;

                              ManualAddress =
                                  "$cityValue,$stateValue,$countryValue";
                            });
                          }
                          if (value != null) {
                            _service.updateUser({
                              'address': ManualAddress,
                              'state': stateValue,
                              'city': cityValue,
                              'country': countryValue
                            }, context,widget.popScreen);
                          }
                        },
                      ),
                    ),
                  ],
                );
              });
        } else {
          progressDialog.dismiss();
        }
      });
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Column(
          children: [
            Image.asset("images/Location.jpg"),
            SizedBox(
              height: 20.h,
            ),
            Text(
              "Where do went\nto buy/sell products",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(25)),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "To enjoy all thet we to offer you \n we need to Know where to look for them ",
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: 30.h,
            ),
          _loading ? Column(
            children: [
              
              CircularProgressIndicator(),
              SizedBox(
                height: 8.h,
              ),
              Text('Finding location......')
            ],
            
          ):  Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: _loading
                            ? Center(
                                child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Theme.of(context).primaryColor),
                              ))
                            : ElevatedButton.icon(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Theme.of(context).primaryColor)),
                                onPressed: () {
                                  progressDialog.show();
                                  getlocation().then((value) {
                                    if (value != null) {
                                      _service.updateUser({
                                        'address': _address,
                                        'location': GeoPoint(
                                            value.latitude!, value.longitude!)
                                      }, context,widget.popScreen);
                                    }
                                  });
                                },
                                icon: Icon(
                                  CupertinoIcons.location_fill,
                                  color: Colors.white,
                                ),
                                label: Padding(
                                  padding: EdgeInsets.all(8.0.w),
                                  child: Text(
                                    'Around me',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    progressDialog.show();
                    showBottemScreen(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8.w),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border(bottom: BorderSide(width: 2))),
                      child: Text(
                        'Set location manally',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                )
              ],
            )
          ],
        ));
  }
}
