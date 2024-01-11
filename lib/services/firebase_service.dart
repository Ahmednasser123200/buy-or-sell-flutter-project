
import 'package:buysell/Screens/home_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../model/popup_menu_model.dart';

class FirebaseService {
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  CollectionReference categories =
      FirebaseFirestore.instance.collection('categories');
  CollectionReference products =
      FirebaseFirestore.instance.collection('products');
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');

  Future<void> updateUser(Map<String, dynamic> data, context, screen) async {
    try {
      await users.doc(user?.uid).update(data);
      Navigator.pushNamed(context, screen);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to Update user data")),
      );
    }
  }

  Future<dynamic> getAddress(lat, long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);
    return placemarks.first;
  }

  Future<DocumentSnapshot> getUserData() async {
    DocumentSnapshot doc = await users.doc(user!.uid).get();
    return doc;
  }

  Future<DocumentSnapshot> getSellerData(id) async {
    DocumentSnapshot doc = await users.doc(id).get();
    return doc;
  }

  Future<DocumentSnapshot> getProductDetails(id) async {
    DocumentSnapshot doc = await products.doc(id).get();
    return doc;
  }

  createChatRoom({chatData}) {
    messages.doc(chatData['chatRoomId']).set(chatData).catchError((e) {
      print(e.toString());
    });
  }

  createChat(String chatRoomId, message) {
    messages.doc(chatRoomId).collection('chats').add(message).catchError((e) {
      print(e.toString());
    });
    messages.doc(chatRoomId).update({
      'lastChat': message['message'],
      'lastChatTime': message['time'],
      'reed': false
    });
  }

  getChat(chatRoomId) {
    return messages
        .doc(chatRoomId)
        .collection('chats')
        .orderBy('time')
        .snapshots();
  }

  deletChat(chatRoomId) {
    return messages.doc(chatRoomId).delete();
  }

  updateFavourite(_isLike, productId,context) {
    if (_isLike) {
      products.doc(productId).update({
        'favourites': FieldValue.arrayUnion([user!.uid])
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Added to my favourits'))
      );
    } else {
       products.doc(productId).update({
        'favourites': FieldValue.arrayRemove([user!.uid])
      });
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed form my favourits'))
      );
    }
  }

  popUpMenu(chatData, context) {
    CustomPopupMenuController _controller = CustomPopupMenuController();
    List<PopupMenuModel> menuItems = [
      PopupMenuModel('Delete Chat', Icons.delete),
      PopupMenuModel('Mark as Sold', Icons.done),
    ];

    return CustomPopupMenu(
      child: Container(
        child: Icon(Icons.more_vert_sharp, color: Colors.black),
        padding: EdgeInsets.all(20),
      ),
      menuBuilder: () => ClipRRect(
        borderRadius: BorderRadius.circular(5),
        child: Container(
          color: Colors.white,
          child: IntrinsicWidth(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: menuItems
                  .map(
                    (item) => GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        if (item.title == 'Delete Chat') {
                          deletChat(chatData['chatRoomId']);
                          _controller.hideMenu();
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Chat deleted')));
                        }
                      },
                      child: Container(
                        height: 40,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: <Widget>[
                            Icon(
                              item.icon,
                              size: 15,
                              color: Colors.black,
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(left: 10),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  item.title,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
      ),
      pressType: PressType.singleClick,
      verticalMargin: -10,
      controller: _controller,
    );
  }
}
