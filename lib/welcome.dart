import 'package:flutter/services.dart';

import 'signUp.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

class WelcomePage extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _emailController = TextEditingController();

  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget emailError;
  Widget passwordError;
  @override
  void initState() {
    emailError = Container();
    passwordError = Container();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return CupertinoPageScaffold(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20),
        children: <Widget>[
          Image.asset('assets/logo.png'),
          CupertinoTextField(
            padding:
                EdgeInsets.symmetric(vertical: height / 60, horizontal: 10.0),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.emailAddress,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100.0),
              border: Border.all(color: CupertinoColors.destructiveRed),
            ),
            placeholder: 'Email',
            controller: _emailController,
          ),
          emailError,
          SizedBox.fromSize(
            size: Size(0, height / 25),
          ),
          CupertinoTextField(
            padding:
                EdgeInsets.symmetric(vertical: height / 60, horizontal: 10.0),
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
          passwordError,
          SizedBox.fromSize(
            size: Size(0, height / 15),
          ),
          CupertinoButton(
            borderRadius: BorderRadius.circular(50.0),
            color: CupertinoTheme.of(context).primaryColor,
            onPressed: login,
            child: Text(
              'LOGIN',
              style: TextStyle(
                  color: CupertinoColors.white, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox.fromSize(
            size: Size(0, height / 15),
          ),
          CupertinoButton(
            borderRadius: BorderRadius.circular(50.0),
            color: CupertinoTheme.of(context).scaffoldBackgroundColor,
            onPressed: signUp,
            child: Text('SIGN UP'),
          ),
        ],
      ),
    );
  }

  Future<void> login() async {
    String email = _emailController.text;
    String password = _passwordController.text;
    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password)
            .then((user) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              HomePage.id, (Route route) => false,
              arguments: {'user': user, 'myID': user.uid});
        });
      } catch (error) {
         setState(() {
            passwordError = Container();
           emailError = Center(
              child: Text('$error'),
            );
          });
      }
      // await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(email: email, password: password)
      //     .catchError((e) {
      //   emailError = Center(
      //     child: Text('${e.message}'),
      //   );
      //   if (e.code == 'ERROR_INVALID_EMAIL' || e.code == 'ERROR_USER_NOT_FOUND')
      //     setState(() {
      //       passwordError = Container();
      //       emailError = Center(
      //         child: Text('${e.message}'),
      //       );
      //     });
      //   if (e.code == 'ERROR_WRONG_PASSWORD')
      //     setState(() {
      //       emailError = Container();
      //       passwordError = Center(
      //         child: Text('${e.message}'),
      //       );
      //     });
      // }).then((user) {
      //   Navigator.of(context).pushNamedAndRemoveUntil(
      //       HomePage.id, (Route route) => false,
      //       arguments: {'user': user, 'myID': user.uid});
      // });

      // Navigator.of(context).pushNamedAndRemoveUntil(
      //     HomePage.id, (Route route) => false,
      //     arguments: {'user': user, 'myID': user.uid});
    }
  }

  void signUp() => Navigator.pushNamed(context, SignUpPage.id);
}
