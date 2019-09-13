import 'package:flutter/material.dart';

class Args {
  String chatId='';
  final String userId;
  Map<String, dynamic> userData;
  String userName;
  String previousPageTitle;
  Args.chat({
   this.chatId,
  @required  this.userId,
 @required   this.userName,
  }) {
    previousPageTitle = 'chats';
  }
  Args.member({
  @required  this.userId,
  @required  this.userData,
  }) {
    previousPageTitle = 'members';
  }
}
