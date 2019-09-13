import 'package:cloud_firestore/cloud_firestore.dart';
import 'home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'list_item.dart';

class ChatItems extends StatefulWidget {
  ChatItems({
    Key key,
  }) : super(key: key);

  @override
  _ChatItemsState createState() => _ChatItemsState();
}

class _ChatItemsState extends State<ChatItems> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map chats = {};
    return StreamBuilder(
      stream: listenToMyDoc(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CupertinoActivityIndicator());
        DocumentSnapshot documentSnapshot = snapshot?.data;

        if (documentSnapshot?.data['chats'] != null) {
          chats = documentSnapshot?.data['chats'];
          return ListView.builder(
            itemCount: chats?.length,
            itemBuilder: (_, index) {
           
               String userId = chats?.keys?.elementAt(index);
                  String chatId = chats?.values?.elementAt(index);
               return UserRow.chat(
                    chatId: chatId,
                    userId: userId,
                  
                       
                  );
            
            },
          );
        } else
          return Center(
            child: Text('YOU DON`T HAVE ANY CHATS YET'),
          );
      },
    );
  }

  Stream<DocumentSnapshot> listenToMyDoc() async* {
    var doc = Firestore.instance
        .collection('users')
        .document(HomePage.myID)
        .snapshots();
    yield* doc;
  }

}
