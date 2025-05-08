import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipe/pages/TabView/home.dart';
import 'package:recipe/pages/login/login_view.dart';

class AuthenticationWrapper extends StatefulWidget {
  @override
  _AuthenticationWrapperState createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool isLogin = false;
  bool isAdmin = false;
  @override
  void initState() {
    super.initState();
    FirebaseAuth.instance.idTokenChanges().listen((User? user) async {
      if (user == null) {
        print('User log out！');
        setState(() {
          isLogin = false;
        });
      } else {
        setState(() {
          isLogin = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return isLogin ? const HomePage() : const LoginView();
  }
}
