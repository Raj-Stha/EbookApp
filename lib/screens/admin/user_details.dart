import 'package:Ebook_App/screens/admin/admin_dashboard.dart';
import 'package:Ebook_App/screens/alertbox/alertbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class UserDetails extends StatefulWidget {
  String userid, userImage, fullName, email, userRole, userStatus;
  Timestamp createdDate;

  UserDetails(
      {this.userid,
      this.userImage,
      this.fullName,
      this.email,
      this.createdDate,
      this.userRole,
      this.userStatus});
  _UserDetailsState createState() => _UserDetailsState(
      userid: userid,
      userImage: userImage,
      fullName: fullName,
      email: email,
      createdDate: createdDate,
      userRole: userRole,
      userStatus: userStatus);
}

class _UserDetailsState extends State<UserDetails> {
  String userid, userImage, fullName, email, userRole, userStatus;
  Timestamp createdDate;
  _UserDetailsState(
      {this.userid,
      this.userImage,
      this.fullName,
      this.email,
      this.createdDate,
      this.userRole,
      this.userStatus});
  @override
  Widget build(BuildContext context) {
    String convertedDate;
    String updatedUserRole;

    setState(() {
      if (userStatus == 'Block') {
        updatedUserRole = 'Unblock';
      } else {
        updatedUserRole = 'Block';
      }
    });
    convertedDate = DateFormat.yMMMd().add_jm().format(createdDate.toDate());

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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
                    Padding(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: RaisedButton(
                        child: Padding(
                            padding: const EdgeInsets.only(top: 10, bottom: 10),
                            child: Text(
                              '$updatedUserRole User',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        color: Colors.grey[300],
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              content:
                                  Text("Do you want to $updatedUserRole User?"),
                              actions: [
                                FlatButton(
                                  child: Text('Yes'),
                                  onPressed: () {
                                    setState(() {
                                      if (userStatus == 'Unblock') {
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(userid)
                                            .update({
                                          "UserStatus": 'Block'
                                        }).then((_) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminDashboard()));
                                          AlertBox("User Successfully Blocked");
                                        });
                                      } else {
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(userid)
                                            .update({
                                          "UserStatus": 'Unblock'
                                        }).then((_) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminDashboard()));
                                          AlertBox(
                                              "User Successfully Unblocked");
                                        });
                                      }
                                    });
                                  },
                                ),
                                FlatButton(
                                  child: Text('No'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  width: 120,
                  height: 120,
                  //margin: EdgeInsets.only(right: 105, top: 25),
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
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          blurRadius: 5.0,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.alternate_email,
                            ),
                            hintText: email,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                            ),
                            hintText: fullName,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.access_time,
                            ),
                            hintText: convertedDate,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.person_outline,
                            ),
                            hintText: userRole,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        TextFormField(
                          enabled: false,
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Icons.block,
                            ),
                            hintText: userStatus,
                            hintStyle: TextStyle(color: Colors.black),
                          ),
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        RaisedButton(
                          child: Padding(
                            padding: EdgeInsets.all(13.0),
                            child: Text(
                              'Delete Account',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                content: Text("Do you want to Delete User?"),
                                actions: [
                                  FlatButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection("users")
                                            .doc(userid)
                                            .delete()
                                            .then((_) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminDashboard()));
                                          AlertBox("User Successfully Deleted");
                                        });
                                      });
                                    },
                                  ),
                                  FlatButton(
                                    child: Text('No'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
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
