import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:neumorphic_button/neumorphic_button.dart';

import '../Screens/LoginScreen.dart';

class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .35,
      backgroundColor: Colors.cyan,
      bottomRightShadowColor: Colors.transparent,
      topLeftShadowColor: Colors.transparent,
      onTap: () {},
      child: Container(
        color: Colors.cyan,
        child: Padding(
          padding:  EdgeInsets.all(10.0.sp),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.all(0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          "CARS",
                          style: TextStyle(
                            fontSize: ScreenUtil().setSp(18),
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1,
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        SizedBox(
                          height: 45.h,
                          child: DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                            ),
                            child: AnimatedTextKit(
                              repeatForever: true,
                              isRepeatingAnimation: true,
                              animatedTexts: [
                                FadeAnimatedText(
                                    'Reach 10 Lakh+\nInterested Buyers',
                                    duration: Duration(seconds: 4)),
                                FadeAnimatedText('New way to\nBuy or Sell Cars',
                                    duration: Duration(seconds: 4)),
                                FadeAnimatedText('Over 1 Lakh\nCars to Buy',
                                    duration: Duration(seconds: 4)),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                    NeumorphicButton(
                      bottomRightShadowBlurRadius: 15,
                      bottomRightShadowSpreadRadius: 1,
                      borderWidth: 5,
                      backgroundColor: Colors.white,
                      topLeftShadowBlurRadius: 15,
                      topLeftShadowSpreadRadius: 1,
                      topLeftShadowColor: Colors.white,
                      bottomRightShadowColor: Colors.grey.shade500,
                      bottomRightOffset: Offset(4, 4),
                      topLeftOffset: Offset(-4, -4),
                      width: 100,
                      height: 90,
                     // bottomRightShadowColor: Colors.white70,
                     // topLeftShadowColor: Colors.white70,
                      onTap: () {},
                      child: Image.network(
                          "https://firebasestorage.googleapis.com/v0/b/buysell-1b12a.appspot.com/o/banner%2Ficons8-car-48.png?alt=media&token=ba215f9b-474a-4e8a-b873-4825667c2004"),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                      child: NeumorphicButton(
                        padding:EdgeInsets.all(5),
                          bottomRightShadowBlurRadius: 15,
                          bottomRightShadowSpreadRadius: 1,
                          borderWidth: 5,
                          backgroundColor: Colors.white,
                          topLeftShadowBlurRadius: 15,
                          topLeftShadowSpreadRadius: 1,
                          topLeftShadowColor: Colors.white,
                          bottomRightShadowColor: Colors.grey.shade500,
                          bottomRightOffset: Offset(4, 4),
                          topLeftOffset: Offset(-4, -4),
                          width: double.infinity,
                          height: 45.h,
                          child: Text(
                            'Buy car',
                            textAlign: TextAlign.center,
                          ),

                          onTap: ()  {
                          })),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                      child: NeumorphicButton(
                          padding:EdgeInsets.all(5),
                          bottomRightShadowBlurRadius: 15,
                          bottomRightShadowSpreadRadius: 1,
                          borderWidth: 5,
                          backgroundColor: Colors.white,
                          topLeftShadowBlurRadius: 15,
                          topLeftShadowSpreadRadius: 1,
                          topLeftShadowColor: Colors.white,
                          bottomRightShadowColor: Colors.grey.shade500,
                          bottomRightOffset: Offset(4, 4),
                          topLeftOffset: Offset(-4, -4),
                          width: double.infinity,
                          height: 45.h,
                          child: Text(
                            'Sell car',
                            textAlign: TextAlign.center,
                          ),

                          onTap: () {})),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
