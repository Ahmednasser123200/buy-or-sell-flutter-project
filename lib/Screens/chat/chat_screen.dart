import 'package:buysell/Screens/sellitems/seller_category_list.dart';
import 'package:buysell/services/firebase_service.dart';
import 'package:buysell/services/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'chat_Card.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseService _service = FirebaseService();

    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          title: Text(
            'Chat',
            style: TextStyle(color: Theme.of(context).primaryColor),
          ),
          bottom: TabBar(
            labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor),
            labelColor: Theme.of(context).primaryColor,
            indicatorWeight: 6,
            indicatorColor: Theme.of(context).primaryColor,
            tabs: [
              Tab(
                text: 'ALL',
              ),
              Tab(
                text: "BUYING",
              ),
              Tab(
                text: 'SELLING',
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _service.messages
                    .where('users', arrayContains: _service.user!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    );
                  }
                  if (snapshot.data!.docs.length == 0) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No Chats started yet',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, MainScreen.id);
                            },
                            child: Text('Contact Seller',style: TextStyle(color: Colors.white),),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor)),
                          )
                        ],
                      ),
                    );
                  }


                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ChatCard(data);
                    }).toList(),
                  );
                },
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _service.messages
                    .where('users', arrayContains: _service.user!.uid)
                    .where('product.seller', isNotEqualTo: _service.user!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    );
                  }

                  if (snapshot.data!.docs.length == 0) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No Ads buying yet',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, MainScreen.id);
                            },
                            child: Text('Buy Products',style: TextStyle(color: Colors.white),),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor)),
                          )
                        ],
                      ),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ChatCard(data);
                    }).toList(),
                  );
                },
              ),
            ),
            Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: _service.messages
                    .where('users', arrayContains: _service.user!.uid)
                    .where('product.seller', isEqualTo: _service.user!.uid)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                            Theme.of(context).primaryColor),
                      ),
                    );
                  }
                  if (snapshot.data!.docs.length == 0) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'No Ads given yet',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, SellerCategory.id);
                            },
                            child: Text('Ad Products',style: TextStyle(color: Colors.white),),
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Theme.of(context).primaryColor)),
                          )
                        ],
                      ),
                    );
                  }

                  return ListView(
                    children:
                        snapshot.data!.docs.map((DocumentSnapshot document) {
                      Map<String, dynamic> data =
                          document.data()! as Map<String, dynamic>;
                      return ChatCard(data);
                    }).toList(),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
