import 'package:Ebook_App/screens/client/edit_profile.dart';
import 'package:Ebook_App/screens/client/manage_password.dart';
import 'package:Ebook_App/services/users_function.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_screen.dart';

class MoreInfo extends StatefulWidget {
  @override
  _MoreInfoState createState() => _MoreInfoState();
}

class _MoreInfoState extends State<MoreInfo> {
  void _signOut() async {
    setState(() {
      try {
        FirebaseAuth.instance.signOut();

        Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
      } catch (e) {
        print(e);
      }
    });
  }

  Future<bool> exitApp() {
    return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            // title: Text("Are you sure?"),
            content: Text(
              "Do you want to exit App?",
              style: TextStyle(fontSize: 17),
            ),
            actions: [
              FlatButton(
                onPressed: () => Navigator.of(context).pop(true),
                // onPressed: () => SystemNavigator.pop(),
                child: Text("Yes"),
              ),
              FlatButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: Text("No"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    String fullName;
    String email;
    String userImage;

    UserFunction userDetails = Provider.of<UserFunction>(context);
    setState(() {
      fullName = userDetails.userModel.getUserFullName;
      email = userDetails.userModel.getUserEmail;
      userImage = userDetails.userModel.getUserImage;
    });

    return SafeArea(
      child: WillPopScope(
        onWillPop: () => exitApp(),
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 120,
                          height: 120,
                          margin: EdgeInsets.all(20),
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 60,
                                backgroundImage: userImage != null
                                    ? NetworkImage(userImage)
                                    : AssetImage("assets/Home.png"),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          fullName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          email,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Container(
                          width: 300,
                          height: 60,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => EditProfile()));
                            },
                            color: Colors.blue[400],
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.account_circle),
                                Padding(
                                  padding: const EdgeInsets.only(right: 120),
                                  child: Text("Edit Profile"),
                                ),
                                Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 300,
                          height: 60,
                          child: FlatButton(
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ManagePassword()));
                            },
                            color: Colors.blue[400],
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.lock_outline),
                                Padding(
                                  padding: const EdgeInsets.only(right: 80),
                                  child: Text("Manage Password"),
                                ),
                                Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          width: 300,
                          height: 60,
                          child: FlatButton(
                            onPressed: _signOut,
                            color: Colors.blue[400],
                            padding: EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Icon(Icons.input),
                                Padding(
                                  padding: const EdgeInsets.only(right: 145),
                                  child: Text("Logout"),
                                ),
                                Icon(Icons.keyboard_arrow_right),
                              ],
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
