import 'package:Ebook_App/services/users_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminProfile extends StatefulWidget {
  @override
  _AdminProfileState createState() => _AdminProfileState();
}

class _AdminProfileState extends State<AdminProfile> {
  var userID;
  var fullName;

  String message;

  @override
  Widget build(BuildContext context) {
    UserFunction userDetails = Provider.of<UserFunction>(context);

    userID = userDetails.userModel.getUserID;

    fullName = userDetails.userModel.getUserFullName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 10.0,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  fullName,
                  style: TextStyle(fontSize: 28),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
