import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../Screens/location_screen.dart';

class EmailAuthentication {
  CollectionReference users = FirebaseFirestore.instance.collection("users");

  Future<DocumentSnapshot> getAdminCredental(
      {email, password, islog, context}) async {
    DocumentSnapshot _result = await users.doc(email).get();
    if (islog) {
      emaillogin(email, password, context);
    } else {
      if (_result.exists) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('A SnackBar been shown.')));
      } else {
        emailRegister(email, password, context);
      }
    }
    return _result;
  }

  emaillogin(email, password, context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if(userCredential.user?.uid!=null){
        Navigator.pushReplacementNamed(context, Locationscreen.id);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No user found for that email.')));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Wrong password provided for that user.')));
      }
    }
  }

  emailRegister(email, password, context) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user?.uid != null) {
        return users.doc(userCredential.user?.uid).set({
          'uid': userCredential.user?.uid,
          'mobile': null,
          'email': userCredential.user?.email,
          'name' :null,
          'address' :null,
        }).then((value) async {

          await  userCredential.user?.sendEmailVerification().then((value) {
            Navigator.pushReplacementNamed(context, Locationscreen.id);

          });

        }).catchError((onError) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to ass user')));
        });
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The password provided is too weak.')));
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('The account already exists for that email.')));
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Error occurred")));
    }
  }
}
