import 'package:Ebook_App/services/users_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './signup_screen.dart';
import 'alertbox/alertbox.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  var _userEmail;
  var _userPassword;
  String message;

//Login buttom

  void _submit() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState.save();
    }
    try {
      UserCredential user;
      user = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _userEmail, password: _userPassword);

      if (user != null) {
        var currentUser = Provider.of<UserFunction>(context, listen: false);

        currentUser.authenticateUser(user.user.uid, context);
      } else {
        AlertBox('Invalid User Details');
      }
    } catch (e) {
      message = e.message;
      AlertBox(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        actions: <Widget>[
          FlatButton(
            child: Row(
              children: <Widget>[
                Text('Signup'),
                Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Icon(Icons.person_add)),
              ],
            ),
            textColor: Colors.white,
            padding: EdgeInsetsDirectional.only(end: 30),
            onPressed: () {
              Navigator.of(context).pushNamed(SignUp.routeName);
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                  padding: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                  child: Column(
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 25.0),
                        child: Image.asset(
                          'assets/Splash2.png',
                          height: 110,
                        ),
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
                                    Icons.alternate_email,
                                  ),
                                  hintText: 'Email',
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value.isEmpty || !value.contains('@')) {
                                    return 'Invalid email address';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userEmail = value.trim();
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
                                validator: (value) {
                                  if (value.isEmpty || value.length <= 6) {
                                    return 'Invalid password';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _userPassword = value;
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              RaisedButton(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Log In',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                onPressed: _submit,
                                color: Colors.blue,
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              FlatButton(
                                child: Text(
                                  'Don\'t Have an account ? Sign up here ',
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                ),
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushNamed(SignUp.routeName);
                                },
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
