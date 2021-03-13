import 'package:Ebook_App/screens/alertbox/alertbox.dart';
import 'package:Ebook_App/services/users_function.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManagePassword extends StatefulWidget {
  @override
  _ManagePasswordState createState() => _ManagePasswordState();
}

class _ManagePasswordState extends State<ManagePassword> {
  String currentPassword;
  String newPassword;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _currentPassword = new TextEditingController();
  TextEditingController _newPassword = new TextEditingController();

  var user;
  var authResult;
  var authCredential;

  Future<void> _update() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();

      UserFunction update = Provider.of<UserFunction>(context, listen: false);

      if (_currentPassword.text == _newPassword.text) {
        AlertBox("Your current password and new password is same");
      } else {
        update.managePassword(currentPassword, newPassword, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () {
                              FocusScope.of(context).unfocus();
                              Navigator.of(context).pop();
                            }),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Text(
                      "Manage Password",
                      style: TextStyle(
                        fontSize: 26,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 65,
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
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
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                  ),
                                  hintText: 'Current Password'),
                              obscureText: true,
                              controller: _currentPassword,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter your current password';
                                } else if (value.length <= 6) {
                                  return 'Password doesnot match';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                currentPassword = value;
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                  ),
                                  hintText: 'New Password'),
                              obscureText: true,
                              controller: _newPassword,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter your current password';
                                } else if (value.length <= 6) {
                                  return 'Password length is too short';
                                }

                                return null;
                              },
                              onSaved: (value) {
                                newPassword = value;
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.lock_outline,
                                  ),
                                  hintText: 'Confirm Password'),
                              obscureText: true,
                              validator: (value) {
                                if (value.isEmpty ||
                                    value != _newPassword.text) {
                                  return 'Invalid confirm password';
                                }
                                return null;
                              },
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            RaisedButton(
                              child: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: Text(
                                  'Update',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: _update,
                              color: Colors.blue,
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
