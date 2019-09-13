import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';
import 'list_item.dart';

class FriendItems extends StatefulWidget {
  FriendItems({
    Key key,
  }) : super(key: key);

  @override
  _FriendItemsState createState() => _FriendItemsState();
}

class _FriendItemsState extends State<FriendItems> {
  
  Future<List<dynamic>> friendsList;
  CollectionReference firestore;
  @override
  void initState() {
    getFriends();
    firestore = Firestore.instance.collection('users');
    super.initState();
  }

  @override
  Widget build(BuildContext _context) {
    return StreamBuilder(
      stream: getFriends(),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Center(child: CupertinoActivityIndicator());
        List list = snapshot?.data['friends'];
        if (list == null)
          return Center(
            child: Text('YOU DON`T HAVE ANY FRIENDS YET'),
          );
        return ListView.builder(
          itemBuilder: (_, index) {
            String userId = list[index];
            return FutureBuilder(
              future: firestore.document(userId).get(),
              builder: (_, userData) {
                return UserRow.friend(
                  collectionSnapshot: userData,
                  userId: userId,
                );
              },
            );
          },
          itemCount: list.length,
        );
      },
    );
  }

  Stream<DocumentSnapshot> getFriends() async* {
   
    yield* Firestore.instance
        .collection('users')
        .document('${HomePage.myID}')
        .snapshots();
  }
}
