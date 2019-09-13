import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:el_chat_1/member.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home.dart';

class Profile extends StatefulWidget {
  static String id = 'profile_page';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _photo = '';
  String _bio = '';
  int _age = 0;
  TextEditingController _bioCon;
  TextEditingController _ageCon;
  String _location;
  TextEditingController _locationCon;
  @override
  void initState() {
    _bioCon = TextEditingController(text: _bio);
    _ageCon = TextEditingController(text: '$_age');
    _locationCon = TextEditingController(text: _location);
    _fetchInfo(HomePage.myID);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(previousPageTitle: 'chats'),
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          SizedBox.fromSize(
            size: Size(0, height / 8),
          ),
          Center(
            child: GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(300.0),
                child: Image.network(
                  _photo,
                  fit: BoxFit.cover,
                  height: height / 4,
                  width: height / 4,
                ),
              ),
              onTap: () {},
            ),
          ),
          SizedBox.fromSize(
            size: Size(0, height / 40),
          ),
          Center(
            child: Text(
              'tap to update your profile image',
              style: TextStyle(
                  color: CupertinoColors.darkBackgroundGray.withAlpha(80),
                  fontSize: 14),
            ),
          ),
          SizedBox.fromSize(
            size: Size(0, height / 30),
          ),
          CupertinoTextField(
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10.0),
            textAlign: TextAlign.center,
            decoration: BoxDecoration(
              border: Border.all(
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor),
            ),
            placeholder: 'something about you...',
            keyboardType: TextInputType.multiline,
            maxLines: 4,
            controller: _bioCon,
          ),
          SizedBox.fromSize(
            size: Size(0, 5),
          ),
          CupertinoTextField(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
            decoration: BoxDecoration(
              border: Border.all(
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor),
            ),
            placeholder: 'country',
            controller: _locationCon,
          ),
          SizedBox.fromSize(
            size: Size(0, 5),
          ),
          CupertinoTextField(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.number,
            decoration: BoxDecoration(
              border: Border.all(
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor),
            ),
            placeholder: 'how old are You?',
            controller: _ageCon,
          ),
          SizedBox.fromSize(
            size: Size(0, height / 7),
          ),
          CupButton.colored(
            onPressed: _saveChanges,
            text: 'SAVE CHANGES',
            color: CupertinoTheme.of(context).primaryContrastingColor,
          ),
        ],
      ),
    );
  }

  Future _fetchInfo(String myID) async {
    var doc = await Firestore.instance.collection('users').document(myID).get();
    setState(() {
      _photo = doc.data['photo'];
      _age = doc.data['age'];
      _bio = doc.data['bio'];
    });
  }

  _saveChanges() {
    Firestore.instance.collection('users').document(HomePage.myID).updateData({
      'age': int.parse(_ageCon.text),
      'location': _locationCon.text,
      'bio': _bioCon.text
    });
  }
}
