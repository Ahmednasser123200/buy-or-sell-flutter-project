import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:legacy_progress_dialog/legacy_progress_dialog.dart';

import '../../services/phoneeuth_service.dart';

class PhoneAuthScreen extends StatefulWidget {
  static const String id = 'phone-auth-Screen';

  const PhoneAuthScreen({super.key});

  @override
  State<PhoneAuthScreen> createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  bool validate = false;
  var countryCodeController = TextEditingController(text: "+20");
  var PhoneNumberController = TextEditingController();



PhoneAuthService _service= PhoneAuthService();

  @override



  @override
  Widget build(BuildContext context) {
    ProgressDialog progressDialog = ProgressDialog(
      context: context,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      loadingText: "please wait",
      progressIndicatorColor: Colors.redAccent,
    ) ;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0.w),
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
                color: Colors.red,
                size: 60.sp,
              ),
            ),
            SizedBox(
              height: 12.h,
            ),
            Text(
              "Enter your phone",
              style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10.h,
            ),
            Text(
              "We will send confirmation code to your phone",
              style: TextStyle(color: Colors.grey),
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: countryCodeController,
                      enabled: false,
                      decoration: InputDecoration(
                          counterText: "10", labelText: "country"),
                    )),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                    flex: 3,
                    child: TextFormField(
                      onChanged: (value) {
                        if (value.length == 10) {
                          setState(() {
                            validate = true;
                          });
                        }
                        if (value.length < 10) {
                          setState(() {
                            validate = false;
                          });
                        }
                      },
                      autofocus: true,
                      maxLength: 10,
                      keyboardType: TextInputType.phone,
                      controller: PhoneNumberController,
                      decoration: InputDecoration(
                        labelText: "Numper",
                        hintText: 'Enter your phone numper',
                        hintStyle: TextStyle(fontSize: 10, color: Colors.grey),
                      ),
                    )),
              ],
            )
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(21.0.w),
          child: AbsorbPointer(
            absorbing: validate ? false : true,
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: validate
                      ? MaterialStateProperty.all(
                          (Theme.of(context).primaryColor),
                        )
                      : MaterialStateProperty.all(Colors.grey)),
              onPressed: () {
                String number = "${countryCodeController.text}${PhoneNumberController.text}";

                progressDialog.show();

                _service.verifyPhoneNumber(context, number);


              },
              child: Padding(
                padding: EdgeInsets.all(8.0.w),
                child: Text(
                  "Next",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
