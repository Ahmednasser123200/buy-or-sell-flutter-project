import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/auth_ui.dart';
import 'location_screen.dart';

class LoginScreen extends StatelessWidget {
  static const String id = 'Login-screen';
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.cyan.shade900,
        body: Column(
          children: [
            Expanded(
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.white,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 100.h,
                    ),
                    Image.asset(
                      "images/card.png",
                      width: 100.w,
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Buy or sell",
                      style: TextStyle(
                        fontSize: 30.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan.shade900,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(child: Authui()),


            Text(
              "if you continue, you are accpting\nTerms and conditions and prvacy",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 10.sp,
              ),
            )
          ],
        ));
  }
}

