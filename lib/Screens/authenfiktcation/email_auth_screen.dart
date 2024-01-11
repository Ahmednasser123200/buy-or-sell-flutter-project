//import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../services/emailAuth_servicr.dart';

class EMailAuthScreen extends StatefulWidget {
  static const String id = "emailAuth-screen";

  @override
  State<EMailAuthScreen> createState() => _EMailAuthScreenState();
}

class _EMailAuthScreenState extends State<EMailAuthScreen> {
  final _fromkey = GlobalKey<FormState>();
  bool validate = false;
  bool _login = false;
  bool _loading = false;
  var _emailcontroller = TextEditingController();
  var _Passwordcontroller = TextEditingController();
  EmailAuthentication _service = EmailAuthentication();

  _validateEmail() {
    if (_fromkey.currentState!.validate()) {
      setState(() {
        validate = false;
        _loading = true;
      });
      _service
          .getAdminCredental(
              context: context,
              islog: _login,
              password: _Passwordcontroller.text,
              email: _emailcontroller.text)
          .then((value) {
        setState(() {
          _loading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "Login",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Form(
        key: _fromkey,
        child: Padding(
          padding: EdgeInsets.all(20.0.w),
          child: SingleChildScrollView(
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
                  "Enter to ${_login ? 'Login' : 'Register'}",
                  style: TextStyle(fontSize: 30.sp, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Text(
                  "Enter Email and Passwoed to${_login ? 'Login' : 'Register'} ",
                  style: TextStyle(color: Colors.grey),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _emailcontroller,
                /*  validator: (value) {
                    final bool isValid =
                        EmailValidator.validate(_emailcontroller.text);
                    if (value == null || value.isEmpty) {
                      return 'Enter email';
                    }
                    if (value.isEmpty && isValid == false) {
                      return 'Enter valid email';
                    }
                    return null;
                  },*/
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(left: 10),
                      labelText: 'Email',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4))),
                ),
                SizedBox(
                  height: 10.h,
                ),
                TextFormField(
                  obscureText: true,
                  controller: _Passwordcontroller,
                  decoration: InputDecoration(
                      suffixIcon: validate
                          ? IconButton(
                              onPressed: () {
                                _Passwordcontroller.clear();
                                setState(() {
                                  validate = false;
                                });
                              },
                              icon: Icon(Icons.clear))
                          : null,
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.grey.shade300,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4))),
                  onChanged: (value) {
                    if (_emailcontroller.text.isNotEmpty) {
                      if (value.length > 3) {
                        setState(() {
                          validate = true;
                        });
                      } else {
                        setState(() {
                          validate = false;
                        });
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 10.h,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child:TextButton(onPressed: () {  },
                  child: Text(
                    'Forgot passwotd',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue),
                  ),)
                ),
                Row(
                  children: [
                    Text(_login ? 'New account ?' : 'Alrady has an account ?'),
                    TextButton(
                        onPressed: () {
                          setState(() {
                            _login = !_login;
                          });
                        },
                        child: Text(
                          _login ? 'Register' : 'Login',
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontWeight: FontWeight.bold),
                        ))
                  ],
                )
              ],
            ),
          ),
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
                _validateEmail();
              },
              child: Padding(
                padding: EdgeInsets.all(8.0.w),
                child: _loading
                    ? SizedBox(
                        height: 24.h,
                        width: 24.w,
                        child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        " ${_login ? 'Login' : 'Register'}",
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
