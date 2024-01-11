/*import 'package:buy_ssell/Screens/location_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmailVerificationScreen extends StatefulWidget {
  static const String id = 'enail-ver';

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Verify Email',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: ScreenUtil().setSp(25),
                      color: Theme
                          .of(context)
                          .primaryColor),
                ),
                Text(
                  'Check your email to verify your registarde Email',
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 20.h,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Theme
                                    .of(context)
                                    .primaryColor),
                          ),
                          onPressed: () {

                          },
                          child: Text('Verify Email')),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }


}
*/