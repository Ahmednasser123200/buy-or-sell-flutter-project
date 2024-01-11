import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';

import '../Screens/authenfiktcation/email_auth_screen.dart';
import '../Screens/authenfiktcation/google_auth.dart';
import '../Screens/authenfiktcation/phoneauth_screen.dart';
import '../services/phoneeuth_service.dart';

class Authui extends StatelessWidget {
  const Authui({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 220.w,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(3.0))),
                onPressed: () {
                  Navigator.pushNamed(context, PhoneAuthScreen.id);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.phone_android_outlined,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      "Continue with photo",
                      style: TextStyle(color: Colors.black),
                    )
                  ],
                )),
          ),
          // SignInButton(Buttons.Google,
          //     text: ("continue with Google"), onPressed: () async {
          //      User? user =await GoogleAuthentication.signInWithGoogle(context: context);
          //      if(user== null){
          //        PhoneAuthService _authentication=PhoneAuthService();
          //        _authentication.addUser(context, user!.uid);
          //      }
          //     }),
          // SignInButton(
          //     text: ("continue with facebook"),
          //     Buttons.FacebookNew,
          //     onPressed: () {}),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "OR",
              style:
                  TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          InkWell(
            onTap: (){
              Navigator.pushNamed(context, EMailAuthScreen.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(
                  "Login with Email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize:ScreenUtil().setSp(18)
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white))
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
