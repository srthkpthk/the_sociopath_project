import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../../res.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 2), () => checkUser());
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Image.asset(
            Res.loading_animation,
            height: 170,
            width: 170,
          ),
        ),
      );

  checkUser() async {
    if (await FirebaseAuth.instance.currentUser() != null) {
      Navigator.pushReplacementNamed(context, '/homeScreen');
    } else {
      Navigator.pushReplacementNamed(context, '/signUpScreen');
    }
  }
}
