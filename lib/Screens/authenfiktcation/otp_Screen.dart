
import 'package:buysell/Screens/authenfiktcation/phoneauth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/phoneeuth_service.dart';
import '../location_screen.dart';

class OTPSCreen extends StatefulWidget {
  final String number;
  final String verId;

  OTPSCreen({required this.number, required this.verId});

  @override
  State<OTPSCreen> createState() => _OTPSCreenState();
}

class _OTPSCreenState extends State<OTPSCreen> {
  bool _loeding = false;
  String error = '';
  PhoneAuthService _services = PhoneAuthService();
  var _text1 = TextEditingController();
  var _text2 = TextEditingController();
  var _text3 = TextEditingController();
  var _text4 = TextEditingController();
  var _text5 = TextEditingController();
  var _text6 = TextEditingController();

  Future<void> phonecredential(BuildContext context, String otp) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
          verificationId: widget.verId, smsCode: otp);
      final User? user = (await _auth.signInWithCredential(credential)).user;
      if (user != null) {
        _services.addUser(context,user.uid);
      } else {
        print("Login Failed");
       if(mounted){
         setState(() {
           error = 'Invalid OTP';
         });
       }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(20)),
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            CircleAvatar(
              radius: 30.w,
              backgroundColor: Colors.red.shade200,
              child: Icon(
                CupertinoIcons.person_alt_circle,
                size: 60.sp,
                color: Colors.red,
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "Welcome Back ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(25)),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Expanded(
                  child: RichText(
                    text: TextSpan(
                        text: "we sent a 6 - digit code to ",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: ScreenUtil().setSp(12),
                        ),
                        children: [
                          TextSpan(
                              text: widget.number,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: ScreenUtil().setSp(12)))
                        ]),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PhoneAuthScreen()));
                  },
                  child: Icon(Icons.edit),
                )
              ],
            ),
            SizedBox(
              height: 12.h,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text1,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) {
                      if (value.length == 1) {
                        node.nextFocus();
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text2,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) {
                      if (value.length == 1) {
                        node.nextFocus();
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text3,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) {
                      if (value.length == 1) {
                        node.nextFocus();
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text4,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) {
                      if (value.length == 1) {
                        node.nextFocus();
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text5,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) {
                      if (value.length == 1) {
                        node.nextFocus();
                      }
                    },
                  ),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  child: TextFormField(
                    textAlign: TextAlign.center,
                    controller: _text6,
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(border: OutlineInputBorder()),
                    onChanged: (value) {
                      if (value.length == 1) {
                        if (_text1.text.length == 1) {
                          if (_text2.text.length == 1) {
                            if (_text3.text.length == 1) {
                              if (_text4.text.length == 1) {
                                if (_text5.text.length == 1) {
                                  String _otp =
                                      "${_text1.text}${_text2.text}${_text3.text}${_text4.text}${_text5.text}${_text6.text}";
                                  setState(() {
                                    _loeding = true;
                                  });
                                  phonecredential(context, _otp);
                                }
                              }
                            }
                          }
                        }
                      } else {
                        setState(() {
                          _loeding = false;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 18.h,
            ),
            Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: 50.w,
                child: LinearProgressIndicator(
                  backgroundColor: Colors.grey.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
              ),
            ),
            SizedBox(
              height: 18.h,
            ),
            Text(
              error,
              style: TextStyle(
                  color: Colors.red, fontSize: ScreenUtil().setSp(12)),
            )
          ],
        ),
      ),
    );
  }
}
