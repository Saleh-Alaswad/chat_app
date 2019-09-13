

import 'package:el_chat_1/profile.dart';

import 'member.dart';
import 'signUp.dart';

import 'welcome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
 
  
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      title: 'ELCHAT',
      theme: CupertinoThemeData(
        scaffoldBackgroundColor:
            CupertinoColors.extraLightBackgroundGray, // Colors.blueGrey[700],
        primaryContrastingColor:
            CupertinoColors.activeOrange, //Colors.deepOrange[400],
        primaryColor: Colors.blueGrey[700],
      ), //Colors.orange[400]),
      home: WelcomePage(),
      routes: {
        HomePage.id: (context) => HomePage(),
        MemberPage.id: (context) => MemberPage(),
        ChatPage.id: (context) => ChatPage(), Profile.id: (context) => Profile(),
        SignUpPage.id: (context) => SignUpPage(),
        WelcomePage.id: (context) => WelcomePage(),
        MemberPage.id: (context) => MemberPage(),
      },
    );
  }
}
