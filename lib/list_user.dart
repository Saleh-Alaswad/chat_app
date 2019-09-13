import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'list_item.dart';

class UserItems extends StatefulWidget {
  UserItems({
    Key key,
  }) : super(key: key);

  @override
  _UserItemsState createState() => _UserItemsState();
}

class _UserItemsState extends State<UserItems> {
  Firestore firestore = Firestore.instance;

  @override
  void initState() {
    getRequests().listen(getUser);
    super.initState();
  }

  List<DocumentSnapshot> documents = [];
  List<dynamic> ids = [];
  @override
  Widget build(BuildContext homeContext) {
    return ListView.builder(
      itemBuilder: (_, index) {
        return UserRow(
          documentSnapshot: documents[index],
          userId: ids[index],
        );
      },
      itemCount: documents.length,
    );
  }

  Stream<String> getRequests() async* {
    var doc = await firestore.collection('users').document(HomePage.myID).get();
    ids = doc?.data['received'];

    if (ids != null) {
      for (var userId in ids) {
        yield userId;
      }
    }
  }

  void getUser(String userId) async {
    var doc = await firestore.collection('users').document(userId).get();
    setState(() {
      documents.add(doc);
    });
  }
}
