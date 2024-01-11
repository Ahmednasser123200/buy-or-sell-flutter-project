import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/authenfiktcation/otp_Screen.dart';
import '../Screens/location_screen.dart';

class PhoneAuthService {
  FirebaseAuth auth = FirebaseAuth.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Constructor
  PhoneAuthService() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        // User signed out
        print('User is signed out');
      } else {
        // User signed in
        print('User is signed in');
      }
    });
  }

  Future<void> addUser(context,uid) async {
    User? user = FirebaseAuth.instance.currentUser;
    final QuerySnapshot result =
        await users.where("uid", isEqualTo: uid).get();
    List<DocumentSnapshot> document = result.docs;
    if (document.length > 0) {
      Navigator.pushReplacementNamed(context, Locationscreen.id);
    } else {
      if (user != null) {
        try {
          // Call the user's CollectionReference to add a new user
          await users.doc(user.uid).set({
            'uid': user.uid, // User ID
            'mobile': user.phoneNumber, // User's phone number
            'email': user.email, //
             'name':null,
             'address':null,
          });

          // Navigate to the desired screen after adding the user
          Navigator.pushReplacementNamed(context, Locationscreen.id);
        } catch (error) {
          print("Failed to add user: $error");
        }
      } else {
        print("User is null");
        // Handle the case where the user is not authenticated
      }
    }
    // Check if the user is authenticated
  }

  Future<void> verifyPhoneNumber(BuildContext context, number) async {
    final PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    };

    final PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
      print("the error is ${e.code}");
    };

    final PhoneCodeSent codeSent = (String verId, int? resendToken) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OTPSCreen(
            number: number,
            verId: verId,
          ),
        ),
      );
    };

    try {
      auth.verifyPhoneNumber(
        phoneNumber: number,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("Error ${e.toString()}");
    }
  }
}
