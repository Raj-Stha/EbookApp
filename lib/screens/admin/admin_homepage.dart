import 'package:Ebook_App/screens/admin/create_user.dart';

import 'package:Ebook_App/screens/admin/view_ebooks.dart';
import 'package:Ebook_App/screens/admin/view_users.dart';
import 'package:Ebook_App/services/ebook_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../login_screen.dart';
import '../../services/users_function.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  List usersList = [];
  var countUsers = 0;

  void createUser() {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => CreateNewUser()));
  }

  void _signOut() async {
    UserFunction userFunction =
        Provider.of<UserFunction>(context, listen: false);

    userFunction.signOutUser();
    Navigator.of(context).pushReplacementNamed(LoginScreen.routeName);
  }

  @override
  void initState() {
    super.initState();
    fetchAllUsers();

    //fetch ebooks information
    EBookFunction eBookFunction =
        Provider.of<EBookFunction>(context, listen: false);
    eBookFunction.fetchAllEbook();
  }

  fetchAllUsers() {
    try {
      FirebaseFirestore.instance
          .collection('users')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((element) {
          usersList.add(element.data());
          setState(() {
            countUsers++;
          });
        });
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Text('Logout'),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Icon(Icons.person)),
              ],
            ),
            textColor: Colors.white,
            padding: EdgeInsetsDirectional.only(end: 30),
            onPressed: _signOut,
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SafeArea(
                    child: Container(
                      padding: EdgeInsets.all(10),
                      width: double.infinity,
                      child: Row(
                        children: [
                          Container(
                            width: 150,
                            height: 50,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10.0,
                                )
                              ],
                            ),
                            child: Text(
                              "Total Users : $countUsers",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    /*  child: RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Text(
                        'Create User',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    color: Colors.blue,
                    onPressed: createUser,
                  ),*/
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'View Users',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ViewUsers(userProfileList: usersList)));
                        },
                      ),
                      RaisedButton(
                        child: Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Create User',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.blue,
                        onPressed: createUser,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RaisedButton(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'View Ebooks',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => ViewEbooksInfo()));
                        },
                      ),
                      //PDF TO TEXT CONVERTER

                      /*   RaisedButton(
                        child: Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Text(
                            'View PDF',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => TextPDF()));
                        },
                      ),*/
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
