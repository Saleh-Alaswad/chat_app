import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'home.dart';
import 'welcome.dart';
import 'package:flutter/cupertino.dart';

class SignUpPage extends StatefulWidget {
  static String id = 'sign_up_screen';

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        children: <Widget>[
          
          Image.asset('assets/logo.png'),
         
                CupertinoTextField(
                  padding:
                      EdgeInsets.symmetric(vertical:height/60, horizontal: 10.0),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(color: CupertinoColors.destructiveRed),
                  ),
                  placeholder: 'Name',
                  controller: _nameController,
                ),
                SizedBox.fromSize(
                  size: Size(0, 30),
                ),
                CupertinoTextField(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.emailAddress,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(color: CupertinoColors.destructiveRed),
                  ),
                  placeholder: 'Email',
                  controller: _emailController,
                ),
                SizedBox.fromSize(
                  size: Size(0, 30),
                ),
                CupertinoTextField(
                  padding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(color: CupertinoColors.destructiveRed),
                  ),
                  placeholder: 'Password',
                  controller: _passwordController,
                ),
                SizedBox.fromSize(
                  size: Size(0, 50),
                ),
                CupertinoButton(
                  borderRadius: BorderRadius.circular(50.0),
                  color: CupertinoTheme.of(context).primaryColor,
                  onPressed: signUp,
                  child: Text(
                    'SIGN UP',
                    style: TextStyle(
                        color: CupertinoColors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox.fromSize(
                  size: Size(0, 30),
                ),
                CupertinoButton(
                  borderRadius: BorderRadius.circular(50.0),
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                  onPressed: login,
                  child: Text('LOGIN'),
                ),
              
        ],
      ),
    );
  }

  void login() => Navigator.pushNamed(context, WelcomePage.id);

  Future<void> signUp() async {
    String name = _nameController.text;
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) {
      var user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await Firestore.instance.collection('users').document(user.uid).setData({
        'name': name,
        'age': 19,
        'online': true,
        'photo':
            'https://coitusmagazine.com/wp-content/uploads/2019/03/DSC_0207.jpg',
        'bio': 'Hi there, I use Elchat',
        'location': 'Cologne, Germany'
      });
      Navigator.of(context).pushNamedAndRemoveUntil(
          HomePage.id, (Route route) => false,
          arguments: {'user': user, 'name': name, 'myID': user.uid});
    }
  }
}
