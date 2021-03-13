import 'dart:io';
import 'dart:math';

import 'package:Ebook_App/screens/alertbox/alertbox.dart';
import 'package:Ebook_App/services/users_function.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    String fullName;
    String email;
    String userFullName;
    String userEmail;
    String userImage;
    String randomName = "";
    File image;
    String imageUrl;
    final _formKey = GlobalKey<FormState>();
    String message;
    TextEditingController _fullName = new TextEditingController();
    TextEditingController _email = new TextEditingController();

    UserFunction userDetails = Provider.of<UserFunction>(context);
    setState(() {
      fullName = userDetails.userModel.getUserFullName;
      email = userDetails.userModel.getUserEmail;
      userImage = userDetails.userModel.getUserImage;
      _fullName.text = fullName;
      print("helloosjafhjhajs======================" + _fullName.text);
      print("=============================================" + fullName);
    });

    String generateNumber() {
      var rng = new Random();
      for (var i = 0; i < 10; i++) {
        //generate
        print(rng.nextInt(100));
        randomName += rng.nextInt(100).toString();
      }
      return randomName;
    }

    // for book image

    Future getUserImage() async {
      generateNumber();
      image = await FilePicker.getFile(type: FileType.image);
      imageUrl = '$randomName' + '.jpg';
    }

    Future<void> _update() async {
      final isValid = _formKey.currentState.validate();
      // FocusScope.of(context).unfocus();

      if (isValid) {
        if (_fullName.text == fullName &&
            image == null &&
            _email.text == email) {
          AlertBox("Update Required filed");
        } else {
          _formKey.currentState.save();

          UserFunction update =
              Provider.of<UserFunction>(context, listen: false);

          try {
            if (update.updateUser(userFullName, imageUrl, image, userEmail) !=
                null) {
              UserFunction fetch =
                  Provider.of<UserFunction>(context, listen: false);
              fetch.fetchCurrentUser();
              AlertBox('Updated Successfully');
            } else {
              AlertBox('Invalid User Information');
            }
          } catch (e) {
            message = e.message;
            AlertBox(message);
          }
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
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
                    Container(
                      width: 120,
                      height: 120,
                      margin: EdgeInsets.only(right: 120, top: 25),
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 60,
                            backgroundImage: userImage != null
                                ? NetworkImage(userImage)
                                : AssetImage("assets/Home.png"),
                          ),
                          Align(
                            alignment: Alignment.bottomRight,
                            child: Container(
                              height: 38,
                              width: 38,
                              decoration: BoxDecoration(
                                  color: Colors.blue, shape: BoxShape.circle),
                              child: IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                ),
                                onPressed: getUserImage,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
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
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                            ),
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          controller: _fullName,
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
                            userFullName = value;
                            print("**********************************" +
                                userFullName);
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
                            hintText: email,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          controller: _email,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          validator: (value) {
                            if (email.isEmpty || !value.contains('@')) {
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
        ),
      ),
    );
  }
}
