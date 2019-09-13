

import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'args.dart';
import 'bubble.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker_modern/image_picker_modern.dart';
import 'home.dart';

class ChatPage extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  void initState() {
    getMessages();
    super.initState();
  }

  final Firestore firebase = Firestore.instance;
  String userId;
  String chatId;

  Widget _messages;
  @override
  Widget build(BuildContext context) {
    String message;
    Args args = ModalRoute.of(context).settings.arguments;
    userId = args.userId;
    final controller = TextEditingController();
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      navigationBar: CupertinoNavigationBar(
        middle: Text('${args.userName}'),
        backgroundColor: CupertinoTheme.of(context).scaffoldBackgroundColor,
        previousPageTitle: '${args.previousPageTitle}',
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _messages,
          Container(
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            alignment: Alignment.bottomCenter,
            padding:
                const EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
            child: Row(
              children: [
                CupertinoButton(
                  onPressed: () {
                    if (chatId != null) _sendImage(chatId, userId);
                  },
                  child: Icon(MaterialCommunityIcons.menu,color: CupertinoTheme.of(context).primaryColor,),
                ),
                Expanded(
                  child: CupertinoTextField(
                    placeholder: 'type here...',
                    decoration: BoxDecoration(
                      border: Border(),
                    ),
                    onChanged: (input) => message = input,
                    controller: controller,
                  ),
                ),
                CupertinoButton(
                 
                  onPressed: () {
                    controller.clear();
                    if (message != null && chatId != null)
                      _sendMessage(chatId, userId, message, Bubble.TEXT);
                  },
                  child: Icon(MaterialCommunityIcons.send, color: CupertinoTheme.of(context).primaryColor,),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendMessage(
      String chatId, String userId, String message, int type) async {
    await firebase.collection('chats').document(chatId).setData({
      'participants': [HomePage.myID, userId]
    });
    await firebase
        .collection('chats')
        .document(chatId)
        .collection('messages')
        .add({
      'sender': HomePage.myID,
      'text': message,
      'time': FieldValue.serverTimestamp(),
      'delivered': false,
      'type': type,
    });
   
   
    await firebase.collection('users').document(HomePage.myID).setData({
      'chats': {'$userId': chatId}
    },merge: true);
    await firebase.collection('users').document(userId).setData({
      'chats': {'${HomePage.myID}': chatId}
    },merge: true);
    message = null;
  }

  Future<void> _sendImage(String chatId, String userId) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 200, maxWidth: 200);
    FirebaseStorage _storage = FirebaseStorage.instance;
    StorageReference reference = _storage.ref().child('xxx');
    StorageUploadTask uploadTask = reference.putFile(image);
    String location = await (await uploadTask.onComplete).ref.getDownloadURL();
    _sendMessage(chatId, userId, location, Bubble.PHOTO);
  }

  Future<void> getMessages() async {
    _messages = Expanded(
      child: CupertinoActivityIndicator(),
    );

    var myChats =
        await firebase.collection('users').document(HomePage.myID).get();
    if (myChats?.data['chats'] != null)
      myChats.data['chats'].keys.forEach((user) {
        if (user == userId) {
          chatId = myChats.data['chats'][user];

        }
      });
    if (chatId == null)
      chatId = firebase.collection('chats').document().documentID;

    setState(() {
      _messages = StreamBuilder<QuerySnapshot>(
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data.documents;
            List<Bubble> messageWidgets = [];
            for (var message in messages) {
              final messageText = message.data['text'];
              final Timestamp time = message.data['time'];
              final delivered = message.data['delivered'];
              final messageType = message.data['type'];
              final messageTime =
                  '${time?.toDate()?.hour}:${time?.toDate()?.minute}';

              final sent =
                  message.data['sender'] == HomePage.myID ? true : false;
              final messageWidget = Bubble(
                delivered: delivered,
                isMe: sent,
                time: messageTime != null ? messageTime : '00:00',
                message: messageText,
                type: messageType,
              );

              messageWidgets.add(messageWidget);
            }
            return Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                children: messageWidgets,
              ),
            );
          } else
            return Container();
        },
        stream: firebase
            .collection('chats')
            .document(chatId)
            .collection('messages')
            .orderBy('time')
            .snapshots(),
      );
    });
  }
}
