import '../alertbox/alertbox.dart';
import 'package:Ebook_App/services/users_function.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNewUser extends StatefulWidget {
  @override
  _CreateNewUserState createState() => _CreateNewUserState();
}

class _CreateNewUserState extends State<CreateNewUser> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _password = new TextEditingController();

  var fullName;
  var userEmail;
  var userPassword;
  String userRole;
  String message;

  bool checkedUser = false;
  final String userStatus = 'Unblock';

  Future<void> _createNewUser() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      UserFunction createNewUser =
          Provider.of<UserFunction>(context, listen: false);
      if (checkedUser == true) {
        userRole = 'admin';
        if (await createNewUser.createUser(
            fullName, userEmail, userPassword, userRole, userStatus)) {
          Navigator.of(context).pop(true);
          AlertBox('User Successfully Created');
        }
      } else {
        userRole = 'client';
        if (await createNewUser.createUser(
            fullName, userEmail, userPassword, userRole, userStatus)) {
          Navigator.of(context).pop(true);
          AlertBox('User Successfully Created');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
                  padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
                  child: Column(
                    children: [
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
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person_outline,
                                  ),
                                  hintText: 'Full Name',
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please, Enter your name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  fullName = value;
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.alternate_email,
                                  ),
                                  hintText: 'Email',
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                validator: (value) {
                                  if (value.isEmpty || !value.contains('@')) {
                                    return 'Invalid email address';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userEmail = value.trim();
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
                                    hintText: 'Password'),
                                obscureText: true,
                                controller: _password,
                                validator: (value) {
                                  if (value.isEmpty || value.length <= 6) {
                                    return 'Invalid password';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  userPassword = value;
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
                                      value != _password.text) {
                                    return 'Invalid confirm password';
                                  }
                                  return null;
                                },
                              ),
                              SizedBox(
                                height: 27.0,
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 50),
                                child: Text(
                                  'Check only if user type is admin',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 2.0,
                              ),
                              bildCheckBox(),
                              SizedBox(
                                height: 20.0,
                              ),
                              RaisedButton(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Sign Up',
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
                                onPressed: _createNewUser,
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
          )
        ],
      ),
    );
  }

  Widget bildCheckBox() => ListTile(
        onTap: () {
          setState(() {
            this.checkedUser = !checkedUser;
          });
        },
        leading: Checkbox(
          value: checkedUser,
          onChanged: (checkedUser) {
            setState(() {
              this.checkedUser = checkedUser;
            });
          },
        ),
        title: Text(
          'Admin',
          style: TextStyle(fontSize: 17),
        ),
      );
}
