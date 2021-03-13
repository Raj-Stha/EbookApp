import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

import '../screens/alertbox/alertbox.dart';
import 'package:Ebook_App/models/user_models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../screens/admin/admin_dashboard.dart';
import '../screens/client/client_dashboard.dart';

class UserFunction extends ChangeNotifier {
  String message;

  UserModel userModel = UserModel();
  Reference reference;
  UploadTask uploadTask;

  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool returnResult = false;

  // store index
  List<String> indexList = [];

  //Create User Details
  Future<bool> createUser(
      fullName, userEmail, userPassword, userRole, userStatus) async {
    returnResult = false;
    try {
      UserCredential user;
      user = await _auth.createUserWithEmailAndPassword(
          email: userEmail, password: userPassword);
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.user.uid)
            .set({
          'UserID': user.user.uid,
          'FullName': fullName,
          'Email': userEmail,
          'SearchIndex': indexList,
          'AccountCreated': Timestamp.now(),
          'UserRole': userRole,
          'UserStatus': userStatus
        });

        returnResult = true;
      }
    } catch (e) {
      message = e.message;
      AlertBox(message);
    }
    return returnResult;
  }

  // store user name in array

  void searchIndex(String name) {
    List<String> spiltList = name.split(" ");

    for (int i = 0; i < spiltList.length; i++) {
      for (int y = 1; y < spiltList[i].length + 1; y++) {
        indexList.add(spiltList[i].substring(0, y).toLowerCase());
      }
    }
    notifyListeners();
  }

  // Fetch current user Data and validate users

  void authenticateUser(userID, context) async {
    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection('users').doc(userID).get();

      userModel.userID = userID;
      userModel.userFullName = _docSnapshot.data()["FullName"];
      userModel.userEmail = _docSnapshot.data()['Email'];
      userModel.userPassword = _docSnapshot.data()['Password'];
      userModel.userImage = _docSnapshot.data()['UserImage'];
      userModel.userRole = _docSnapshot.data()['UserRole'];
      userModel.userStatus = _docSnapshot.data()['UserStatus'];

      // validate user status
      if (userModel.userStatus == 'Unblock') {
        // validate user roles
        if (userModel.getUserRole == 'admin') {
          Navigator.of(context).pushReplacementNamed(AdminDashboard.routeName);
        } else {
          Navigator.of(context).pushReplacementNamed(ClientDashboard.routeName);
        }
      } else {
        AlertBox('Account temprorary Banned');
      }
    } catch (e) {
      message = e.message;
      AlertBox(message);
    }
  }

  // fetch all users details

  // fetch current user details
  Future<void> fetchCurrentUser() async {
    var firebaseUser = FirebaseAuth.instance.currentUser;

    try {
      DocumentSnapshot _docSnapshot =
          await _firestore.collection('users').doc(firebaseUser.uid).get();

      userModel.userID = firebaseUser.uid;
      userModel.userFullName = _docSnapshot.data()["FullName"];
      userModel.userEmail = _docSnapshot.data()['Email'];
      userModel.userPassword = _docSnapshot.data()['Password'];
      userModel.userImage = _docSnapshot.data()['UserImage'];
      userModel.userRole = _docSnapshot.data()['UserRole'];
    } catch (e) {
      message = e.message;
      AlertBox(message);
    }
  }

  // update user details

  Future<bool> updateUser(
      String fullName, String imageUrl, File image, String email) async {
    returnResult = false;
    var firebaseUser = FirebaseAuth.instance.currentUser;

    try {
      if (firebaseUser.uid != null) {
        firebaseUser.updateEmail(email);
        reference = FirebaseStorage.instance.ref();
        reference = reference.child("User_Image").child(imageUrl);
        uploadTask = reference.putData(image.readAsBytesSync());
        imageUrl = await (await uploadTask).ref.getDownloadURL();
        _firestore.collection("users").doc(firebaseUser.uid).update({
          "UserImage": imageUrl,
          "FullName": fullName,
          "Email": email,
        });

        fetchCurrentUser();
        returnResult = true;
      }
    } catch (e) {
      print(e);
    }
    return returnResult;
  }

  // validate and update password
  void managePassword(
      String currentPassword, String newPassword, BuildContext context) {
    User users = _auth.currentUser;
    AuthCredential authCredential = EmailAuthProvider.credential(
        email: users.email, password: currentPassword);

    try {
      users.reauthenticateWithCredential(authCredential).then((result) {
        users.updatePassword(newPassword);
        Navigator.of(context).pop(true);
        AlertBox("Password Successfully Updated");
        print("Success: $result");
      }).catchError((error) {
        AlertBox("Password does not Match");
        print("Error: $error");
      });
    } catch (e) {
      print(e);
    }
  }

// signout method
  Future<void> signOutUser() async {
    try {
      //   FirebaseAuth.instance.currentUser;
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e);
    }
  }
}
