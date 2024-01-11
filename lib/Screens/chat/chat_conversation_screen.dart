import 'package:buysell/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'chat_stream.dart';

class ChatConvesation extends StatefulWidget {
  final String chatRoomId;

  ChatConvesation({required this.chatRoomId});

  @override
  State<ChatConvesation> createState() => _ChatConvesationState();
}

class _ChatConvesationState extends State<ChatConvesation> {
  FirebaseService _service = FirebaseService();
  var chatMessageController = TextEditingController();
  bool _send = false;

  sendMessage() {
    if (chatMessageController.text.isNotEmpty) {
      FocusScope.of(context).unfocus();
      Map<String, dynamic> message = {
        'message': chatMessageController.text,
        'sentBy': _service.user!.uid,
        'time': DateTime.now().microsecondsSinceEpoch
      };
      _service.createChat(widget.chatRoomId, message);
      chatMessageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(onPressed: (){}, icon: Icon(Icons.call)),
          _service.popUpMenu(widget.chatRoomId, context)
        ],
        shape: Border(bottom: BorderSide(color: Colors.grey)),
      ),
      body: Container(
        child: Stack(
          children: [
            ChatStream(chatRoomId: widget.chatRoomId),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 60,
                alignment: Alignment.bottomCenter,
                decoration: BoxDecoration(
                    border: Border(
                  top: BorderSide(color: Colors.grey.shade800, width: 2),
                )),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.attach_file,
                              color: Theme.of(context).primaryColor)),
                      Expanded(
                        child: TextField(
                          controller: chatMessageController,
                          style:
                              TextStyle(color: Theme.of(context).primaryColor),
                          decoration: InputDecoration(
                              hintText: 'Type Message',
                              hintStyle: TextStyle(
                                  color: Theme.of(context).primaryColor),
                              border: InputBorder.none),
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                _send = true;
                              });
                            } else {
                              setState(() {
                                _send = false;
                              });
                            }
                          },
                          onSubmitted: (value) {
                            if (value.length > 0) {
                              sendMessage();
                            }
                          },
                        ),
                      ),
                      Visibility(
                        visible: _send,
                        child: IconButton(
                            onPressed: sendMessage,
                            icon: Icon(Icons.send,
                                color: Theme.of(context).primaryColor)),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
