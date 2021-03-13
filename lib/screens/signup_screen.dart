import 'alertbox/alertbox.dart';
import 'package:Ebook_App/services/users_function.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SignUp extends StatefulWidget {
  static const routeName = '/signup';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController _password = new TextEditingController();

  var fullName;
  var userEmail;
  var userPassword;
  final String userRole = 'client';
  final String userStatus = 'Unblock';
  String message;

//Signup buttom
  Future<void> _signUpUser() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
      UserFunction signUpUser =
          Provider.of<UserFunction>(context, listen: false);

      try {
        signUpUser.searchIndex(fullName);

        if (await signUpUser.createUser(
            fullName, userEmail, userPassword, userRole, userStatus)) {
          Navigator.of(context).pop(true);

          AlertBox('User Successfully Created');
        } else {
          AlertBox('Invalid User Information');
        }
      } catch (e) {
        message = e.message;
        AlertBox(message);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
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
                                onPressed: _signUpUser,
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
}
