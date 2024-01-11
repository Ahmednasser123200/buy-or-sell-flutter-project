import 'package:buysell/Screens/chat/chat_conversation_screen.dart';
import 'package:buysell/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_pop_up_menu/custom_pop_up_menu.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../model/popup_menu_model.dart';

class ChatCard extends StatefulWidget {
  final Map<String, dynamic> chatData;

  ChatCard(this.chatData);

  @override
  State<ChatCard> createState() => _ChatCardState();
}

class _ChatCardState extends State<ChatCard> {
  FirebaseService _service = FirebaseService();
  late Future<DocumentSnapshot> _docFuture;

  String _lastChatDate = '';


  @override
  void initState() {
    _docFuture = getProductDetails();
    getChatTime();
    super.initState();
  }

  getChatTime() {
    var _date = DateFormat.yMMMd().format(
        DateTime.fromMicrosecondsSinceEpoch(widget.chatData['lastChatTime']));
    var _today = DateFormat.yMMMd().format(DateTime.fromMicrosecondsSinceEpoch(
        DateTime.now().microsecondsSinceEpoch));
    if (_date == _today) {
      setState(() {
        _lastChatDate = 'Today';
      });
    } else {
      setState(() {
        _lastChatDate = _date.toString();
      });
    }
  }

  Future<DocumentSnapshot> getProductDetails() {
    return _service.getProductDetails(widget.chatData['product']['productId']);
  }



  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _docFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Return a loading state or an empty container
          return CircularProgressIndicator(); // Or any other loading indicator
        }

        if (snapshot.hasError) {
          // Handle the error case
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data == null) {
          // Handle the case where data is not available
          return Container();
        }

        // Data is available, build the UI
        return Container(
          child: Stack(
            children: [
              SizedBox(
                height: 10,
              ),
              ListTile(
                onTap: () {
                  _service.messages.doc(widget.chatData['chatRomId']).update(
                      {
                        'read':'true'
                      });
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => ChatConvesation(
                          chatRoomId: widget.chatData['chatRoomId']),
                    ),
                  );
                },
                shape: Border(bottom: BorderSide(color: Colors.grey)),
                leading: Container(
                    height: 60,
                    width: 60,
                    child: Image.network(snapshot.data!['image'][0])),
                title: Text(snapshot.data!['title'],style: TextStyle(
                  fontWeight: widget.chatData['read']==false?FontWeight.bold:FontWeight.normal
                ),),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      snapshot.data!['description'],
                      maxLines: 1,
                    ),
                    if (widget.chatData['lastChat'] != null)
                      Text(
                        widget.chatData['lastChat'],
                        maxLines: 1,
                        style: TextStyle(fontSize: 10),
                      )
                  ],
                ),
                trailing:_service.popUpMenu(widget.chatData, context),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: Text(_lastChatDate),
              )
            ],
          ),
          decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey))),
        );
      },
    );
  }
}
