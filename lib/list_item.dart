import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_chat_1/member.dart';
import 'package:flutter/cupertino.dart';

import 'args.dart';
import 'chat.dart';
import 'home.dart';

class UserRow extends StatefulWidget {
  AsyncSnapshot<dynamic> collectionSnapshot;
  final String userId;
  DocumentSnapshot documentSnapshot;
  String chatId;
  String title;
  String photo;
  String subtitle;
  Function onPressed;
  String lastMessage;
  String location;
  Widget _subtitle;
  UserRow.chat({
    @required this.userId,
    @required this.chatId,
  }) {
    title = 'loading..';
    _subtitle = Subtitle(
      chatId: chatId,
    );
    photo = '';

    onPressed = () {
      Navigator.pushNamed(
        HomePage.context,
        ChatPage.id,
        arguments: Args.chat(userName: title, userId: userId, chatId: chatId),
      );
    };
  }

  UserRow.friend({
    this.collectionSnapshot,
    this.userId,
  }) {
    if (collectionSnapshot.connectionState == ConnectionState.waiting) {
      title = '';
      subtitle = '';
      photo = '';
    }
    if (collectionSnapshot.hasData) {
      title = collectionSnapshot.data['name'];
      subtitle = collectionSnapshot.data['bio'];
      photo = collectionSnapshot.data['photo'];
    }
    _subtitle = Text('$subtitle');
    onPressed = () {
      Navigator.pushNamed(
        HomePage.context,
        ChatPage.id,
        arguments: Args.chat(userName: title, userId: userId),
      );
    };
  }

  UserRow({this.documentSnapshot, this.userId}) {
    title = documentSnapshot.data['name'];
    subtitle = documentSnapshot.data['bio'];
    photo = documentSnapshot.data['photo'];   location = documentSnapshot.data['location'];
    _subtitle = Text('$subtitle');
    onPressed = () {
      Navigator.pushNamed(
        HomePage.context,
        MemberPage.id,
        arguments: Args.member(
          userData: {
            'name': title,
            'age': documentSnapshot.data['age'],
            'photo': photo,
            'location': location,
            'bio': subtitle,
          },
          userId: userId,
        ),
      );
    };
  }

  @override
  _UserRowState createState() => _UserRowState();
}

class _UserRowState extends State<UserRow> {
  CollectionReference firestore = Firestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    getUser(widget.userId);
    return GestureDetector(
      onTap: widget.onPressed,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(50.0),
              child: Image.network(
                widget.photo,
                fit: BoxFit.cover,
                height: 60.0,
                width: 60.0,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.title),
                widget._subtitle,
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future getUser(String userId) async {
    var doc = await firestore.document(userId).get();
    if (this.mounted)
      setState(() {
        widget.title = doc.data['name'];
        widget.photo = doc.data['photo'];
      });
  }
}

class Subtitle extends StatefulWidget {
  final String chatId;

  const Subtitle({Key key, this.chatId}) : super(key: key);
  @override
  _SubtitleState createState() => _SubtitleState();
}

class _SubtitleState extends State<Subtitle> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: listenToChat(widget.chatId),
      builder: (_, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting)
          return Container();

        var lastMessage =
            snapshot?.data?.documentChanges?.last?.document['text'];
        var type = snapshot?.data?.documentChanges?.last?.document['type'];
        if (type == 0)
          return Text('$lastMessage');
        else
          return Text('sent you an image',style: TextStyle(color: CupertinoTheme.of(context).primaryColor),);
      },
    );
  }

  Stream<QuerySnapshot> listenToChat(chatId) async* {
    var doc = Firestore.instance
        .collection('chats')
        .document(chatId)
        .collection('messages')
        .orderBy('time')
        .snapshots();

    yield* doc;
  }
}
