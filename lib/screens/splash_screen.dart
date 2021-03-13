import 'dart:async';
import 'package:Ebook_App/services/users_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'login_screen.dart';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/SplashScreen';
  @override
  State<StatefulWidget> createState() {
    return SplashScreenState();
  }
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Image.asset(
                  'assets/Splash2.png',
                  height: 140,
                ),
              ),

              Padding(padding: EdgeInsets.only(bottom: 230)),
              //Loading Circle
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                strokeWidth: 3,
              ),
              SizedBox(
                height: 30,
              ),

              Text(
                'E-Book App',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: Colors.blueAccent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Timer> loadData() async {
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    // stay login
    try {
      User userData = FirebaseAuth.instance.currentUser;
      if (userData != null) {
        var currentUser = Provider.of<UserFunction>(context, listen: false);

        currentUser.authenticateUser(userData.uid, context);
      } else {
        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      }
    } catch (e) {
      print(e);
    }
  }
}
