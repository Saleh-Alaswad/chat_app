import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'args.dart';
import 'home.dart';

class MemberPage extends StatefulWidget {
  static String id = 'member_page';
  @override
  _MemberPageState createState() => _MemberPageState();
}

class _MemberPageState extends State<MemberPage> {
  String userId;
  Widget buttons;
  Args args;
  double height;
  double width;
  @override
  void initState() {
    super.initState();
    _bindButtons();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    userId = args.userId;
    String name = args.userData['name'];
    String photo = args.userData['photo'];
    int age = args.userData['age'];
    String country = args.userData['location'];
    String about = args.userData['bio'];
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return CupertinoPageScaffold(
      navigationBar:
          CupertinoNavigationBar(previousPageTitle: args.previousPageTitle),
      child: Center(
        child: Column(
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(0, height / 7),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: Image.network(
                '$photo',
                fit: BoxFit.cover,
                height: height / 5,
                width: height / 5,
              ),
            ),
            SizedBox.fromSize(
              size: Size(0, height / 15),
            ),
            Text(
              '$name',
              style: TextStyle(
                fontSize: 24,
                color: CupertinoTheme.of(context).primaryContrastingColor,
              ),
            ),
            SizedBox.fromSize(
              size: Size(0, height / 15),
            ),
            Text(
              '$country',
              style: TextStyle(
                fontSize: 18,
                color: CupertinoTheme.of(context).primaryColor,
              ),
            ),
            SizedBox.fromSize(
              size: Size(0, height / 15),
            ),
            Text(
              '$about',
              style: TextStyle(
                fontSize: 18,
                color: CupertinoTheme.of(context).primaryColor,
              ),
            ),
            SizedBox.fromSize(
              size: Size(0, height / 15),
            ),
            buttons,
          ],
        ),
      ),
    );
  }

  Future _bindButtons() async {
    buttons = Center(child: CupertinoActivityIndicator());
    Widget _widget;
    var myDoc = await Firestore.instance
        .collection('users')
        .document(HomePage.myID)
        .get();
    if (myDoc?.data['friends'] != null)
      myDoc.data['friends'].forEach((friend) {
        if (friend == userId) {
          //USER is FRIEND
          _widget = Column(
            children: <Widget>[
              CupButton.colored(text: 'START CHAT', onPressed: () {},color: CupertinoTheme.of(context).primaryColor,),
              SizedBox.fromSize(
                size: Size(0, height / 25),
              ),
              Request.delete(userId),
            ],
          );
        }
      });
    if (myDoc?.data['received'] != null)
      myDoc.data['received'].forEach((request) {
        if (request == userId) {
          //USER sent me a REQUEST
          _widget = Column(
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(0, height / 7),
              ),
              Request.accept(userId),
            ],
          );
        }
      });
    if (myDoc?.data['sent'] != null)
      myDoc.data['sent'].forEach((request) {
        if (request == userId) {
          //USER received a REQUEST from me
          _widget = Column(
            children: <Widget>[
              SizedBox.fromSize(
                size: Size(0, height / 7),
              ),
              Request.cancel(userId)
            ],
          );
        }
      });
    if (_widget != null)
      setState(() {
        buttons = _widget;
      });
    else
      setState(() {
        buttons = Column(
          children: <Widget>[
            SizedBox.fromSize(
              size: Size(0, height / 7),
            ),
            Request.send(userId)
          ],
        );
      });
  }
}

class CupButton extends StatelessWidget {
  final String text;
  final Function onPressed;
  Color color;
  CupButton.colored(
      {@required this.text, @required this.onPressed, @required this.color});
  CupButton({@required this.text, @required this.onPressed})
      : color = CupertinoTheme.of(HomePage.context).primaryContrastingColor;
  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      //   minSize: 30.0,
      pressedOpacity: 0.8,
      borderRadius: BorderRadius.circular(50.0),
      color: color,
      onPressed: onPressed,
      child: Text(
        '$text',
        style: TextStyle(color: CupertinoColors.white),
      ),
    );
  }
}

class Request extends StatefulWidget {
  final String userId;
  final int action;
  final String text;
  const Request.accept(String id)
      : userId = id,
        action = 0,
        text = 'ACCEPT REQUEST';
  const Request.send(String id)
      : userId = id,
        action = 1,
        text = 'SEND REQUEST';
  const Request.cancel(String id)
      : userId = id,
        text = 'CANCEL REQUEST',
        action = 2;
  const Request.delete(String id)
      : userId = id,
        text = 'BLOCK FRIEND',
        action = 3;

  @override
  _RequestState createState() => _RequestState();
}

class _RequestState extends State<Request> {
  String _text;
  @override
  void initState() {
    _text = widget.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return CupButton(
      onPressed: () {
        switch (widget.action) {
          case 0:
            _acceptRequest();
            break;
          case 1:
            _sendRequest();
            break;
          case 2:
            _cancelRequest();
            break;
          case 3:
            _deleteFriend();
            break;
        }
      },
      text: _text,
    );
  }

  void _acceptRequest() async {
    var usersRef = Firestore.instance.collection('users');
    await usersRef.document('${HomePage.myID}').updateData({
      'friends': FieldValue.arrayUnion(['${widget.userId}'])
    });
    await usersRef.document('${widget.userId}').updateData({
      'friends': FieldValue.arrayUnion(['${HomePage.myID}'])
    });

    await usersRef.document('${HomePage.myID}').updateData({
      'received': FieldValue.arrayRemove(['${widget.userId}'])
    });
    await usersRef.document('${widget.userId}').updateData({
      'sent': FieldValue.arrayRemove(['${HomePage.myID}'])
    });
    setState(() => _text = 'REQUEST ACCEPTED');
  }

  void _sendRequest() async {
    var usersRef = Firestore.instance.collection('users');
    await usersRef.document('${HomePage.myID}').updateData({
      'sent': FieldValue.arrayUnion(['${widget.userId}'])
    });
    await usersRef.document('${widget.userId}').updateData({
      'received': FieldValue.arrayUnion(['${HomePage.myID}'])
    });

    setState(() => _text = 'REQUEST SENT');
  }

  void _cancelRequest() async {
    var usersRef = Firestore.instance.collection('users');
    await usersRef.document('${HomePage.myID}').updateData({
      'sent': FieldValue.arrayRemove(['${widget.userId}'])
    });
    await usersRef.document('${widget.userId}').updateData({
      'received': FieldValue.arrayRemove(['${HomePage.myID}'])
    });

    setState(() => _text = 'REQUEST CANCELED');
  }

  void _deleteFriend() async {
    var usersRef = Firestore.instance.collection('users');
    await usersRef.document('${HomePage.myID}').updateData({
      'friends': FieldValue.arrayRemove(['${widget.userId}'])
    });
    await usersRef.document('${widget.userId}').updateData({
      'friends': FieldValue.arrayRemove(['${HomePage.myID}'])
    });
    setState(() => _text = 'FRIEND DELETED');
  }
}
