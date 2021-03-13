import 'package:Ebook_App/screens/admin/user_details.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ViewUsers extends StatefulWidget {
  List userProfileList = [];
  ViewUsers({this.userProfileList});

  _ViewUsersState createState() =>
      _ViewUsersState(userProfileList: userProfileList);
}

class _ViewUsersState extends State<ViewUsers> {
  List userProfileList = [];
  _ViewUsersState({this.userProfileList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Users"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView.builder(
            itemCount: userProfileList.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserDetails(
                    userid: userProfileList[index]['UserID'],
                    userImage: userProfileList[index]['UserImage'],
                    fullName: userProfileList[index]['FullName'],
                    email: userProfileList[index]['Email'],
                    createdDate: userProfileList[index]['AccountCreated'],
                    userRole: userProfileList[index]['UserRole'],
                    userStatus: userProfileList[index]['UserStatus'],
                  ),
                ),
              ),
              child: Card(
                elevation: 5.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0.0),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 55.0,
                            height: 55.0,
                            child: CircleAvatar(
                              backgroundColor: Colors.blue,
                              backgroundImage:
                                  userProfileList[index]['UserImage'] != null
                                      ? NetworkImage(
                                          userProfileList[index]['UserImage'])
                                      : AssetImage("assets/Home.png"),
                            ),
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 4.0),
                                child: Text(
                                  userProfileList[index]['FullName'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                userProfileList[index]['Email'],
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 10.0),
                        child: Container(
                          alignment: Alignment.center,
                          width: 70.0,
                          height: 30.0,
                          color: Colors.grey[300],
                          child: Text('View'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
