import 'dart:async';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:buysell/services/main_screen.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'LoginScreen.dart';
import 'location_screen.dart';
class SplashScreen extends StatefulWidget {
  static const String id = 'Splash_Screen';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Timer(
      Duration(seconds: 3),
          () {
        FirebaseAuth.instance.authStateChanges().listen((User? user) {
          if (user == null) {
            Navigator.pushReplacementNamed(context, LoginScreen.id);
          } else {
           // Navigator.pushReplacementNamed(context, MainScreen.id);
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Locationscreen()),
                  (route) => false,
            );
          }
        });
      },
    );
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    const colorizeColors = [
      Colors.purple,
      Colors.blue,
      Colors.yellow,
      Colors.red,
    ];
    const colorizeTextStyle = TextStyle(
      fontSize: 50.0,
      fontFamily: 'Horizon',
    );
    return  Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: new Column(children: <Widget>[
          Divider(
            height: 240.0.h,
            color: Colors.white,
          ),
          new Image.asset(
            "images/card.png",
            fit: BoxFit.cover,
            repeat: ImageRepeat.noRepeat,
            width: 170.0,
          ),

        AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'SHOP NOW',
              textStyle: colorizeTextStyle,
              colors: colorizeColors,
            ),

          ],
          isRepeatingAnimation: true,
          onTap: () {
            print("Tap Event");
          },
        ),
          Divider(
            height: 105.2.h,
            color: Colors.white,
          ),
        ]),
      ),
    );
  }
}
