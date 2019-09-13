
import 'package:el_chat_1/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'list_chat.dart';
import 'list_friend.dart';
import 'list_search.dart';

class HomePage extends StatelessWidget {
  static String id = 'home_page';
  static String myID;
  static BuildContext context;


  @override
  Widget build(BuildContext home) {
    context = home;
    Map args = ModalRoute.of(context).settings.arguments;
    myID = args['myID'];
    final List<BottomNavigationBarItem> tabBarItems = <BottomNavigationBarItem>[
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.conversation_bubble),
        title: Text('chats'),
      ),
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.person),
        title: Text('contacts'),
      ),
      BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.search),
        title: Text('search'),
      ),
    ];
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        items: tabBarItems,
      ),
      tabBuilder: (_, index) {
        Widget returnValue;
        switch (index) {
          case 0:
            returnValue = ChatItems();
            break;
          case 1:
            returnValue = FriendItems();
            break;
          case 2:
            return SearchTab();
            break;
        }
        return CupertinoTabView(builder: (_) {
          return CupertinoPageScaffold(
            backgroundColor: Colors.white,
            navigationBar: CupertinoNavigationBar(
              middle: Text('ELCHAT'),
              trailing: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Profile.id, arguments: {});
                },
                child: Icon(
                  CupertinoIcons.profile_circled,
                  color: Theme.of(context).buttonColor,
                ),
              ),
              backgroundColor: CupertinoTheme.of(context).primaryColor,
            ),
            child: returnValue,
          );
        });
      },
    );
  }

}
