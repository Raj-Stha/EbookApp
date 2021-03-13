import 'package:Ebook_App/screens/client/search.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/users_function.dart';
import 'book_details.dart';

class ClientHomePage extends StatefulWidget {
  @override
  _ClientHomePageState createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  @override
  Widget build(BuildContext context) {
    String fullName;

    UserFunction userDetails = Provider.of<UserFunction>(context);
    fullName = userDetails.userModel.getUserFullName.split(" ")[0];
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Home.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top: 50,
                bottom: 5,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Search()));
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 40,
                  left: 14,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        fullName,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          bottom: 28,
                        ),
                        width: 100,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue,
                        ),
                      ),
                      BookSection(
                        heading: "Sci-fi",
                      ),
                      BookSection(
                        heading: "Trending",
                      ),
                      BookSection(
                        heading: "Latest",
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BookSection extends StatefulWidget {
  final String heading;

  BookSection({
    this.heading,
  });
  @override
  _BookSectionState createState() => _BookSectionState(
        heading: heading,
      );
}

class _BookSectionState extends State<BookSection> {
  final String heading;

  _BookSectionState({this.heading});
  //List bookList = [];
  List abc = [];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  initState() {
    super.initState();
    getDetails(heading);
  }

  getDetails(String heading) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("book_collection").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        if (result.data()['Categories'] == heading) {
          abc.add(result);
        }
        setState(() {});
      });
    });
  }
  /*
  @override
  initState() {
    super.initState();
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    firestore.collection("book_collection").get().then((querySnapshot) {
      querySnapshot.docs.forEach((result) {
        //print(result.data());

        /*model = new BookModel(
            bookImage: result.data()['ImageUrl'],
            bookName: result.data()['BookName'],
            authorName: result.data()['AuthorName'],
            categories: result.data()['Categories'],
            bookPdf: result.data()['PDFBook'],
            audioBook: result.data()['AudioBook']);*/

        if (result.data()['Categories'] == heading) {
          abc.add(result.data());
          print(abc);
        }

        // print(abc);
        setState(() {});
      });
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            height: MediaQuery.of(context).size.height * 0.45,
            child: ListView.builder(
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => BookDetail(
                      bookID: abc[i].id,
                      bookName: abc[i]["BookName"],
                      bookImage: abc[i]["ImageUrl"],
                      authorName: abc[i]["AuthorName"],
                      bookPDF: abc[i]["PDFBook"],
                      pdfText: abc[i]["PDFText"],
                      audioBook: abc[i]["AudioBook"],
                      bookStatus: abc[i]["BookStatus"],
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                          ),
                          height: MediaQuery.of(context).size.height * 0.27,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 5,
                                      offset: Offset(8, 8),
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    abc[i]["ImageUrl"],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.27,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: new LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.4),
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.4),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          abc[i]["BookName"],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          abc[i]["AuthorName"],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
              itemCount: abc.length,
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    );
  }
}

/*Widget build(BuildContext context) {
    UserFunction userDetails = Provider.of<UserFunction>(context);

    fullName = userDetails.userModel.getUserFullName.split(" ")[0];

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Home.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(
                left: 30,
                right: 30,
                top: 70,
                bottom: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(
                  top: 50,
                  left: 50,
                ),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello,",
                        style: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        fullName,
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          top: 15,
                          bottom: 30,
                        ),
                        width: 100,
                        height: 10,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue,
                        ),
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('book_collection')
                              .snapshots(),
                          builder: (context, dataSnapshot) {
                            if (!dataSnapshot.hasData) {
                              return Center(child: CircularProgressIndicator());
                            } else {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: dataSnapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot docSnapshot =
                                        dataSnapshot.data.docs[index];

                                    if (docSnapshot.data()['Categories'] ==
                                        "Trending") {
                                      return display(
                                          docSnapshot.data()['Categories'],
                                          docSnapshot,
                                          context);

                                      /*ListTile(
                                          leading: Text('Trending'),
                                          title:
                                              Text(docSnapshot['AuthorName']),
                                          subtitle:
                                              Text(docSnapshot['BookName']),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BookDetail(
                                                          post: dataSnapshot
                                                              .data.docs[index],
                                                        )));
                                          });*/
                                    } else if (docSnapshot
                                            .data()['Categories'] ==
                                        "Sci-fi") {
                                      return display(
                                          docSnapshot.data()['Categories'],
                                          docSnapshot,
                                          context);
                                    } else if (docSnapshot
                                            .data()['Categories'] ==
                                        "Latest") {
                                      return ListTile(
                                          leading: Text('Latest'),
                                          title:
                                              Text(docSnapshot['AuthorName']),
                                          subtitle:
                                              Text(docSnapshot['BookName']),
                                          onTap: () {
                                            Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BookDetail(
                                                          post: dataSnapshot
                                                              .data.docs[index],
                                                        )));
                                          });
                                    }
                                    return null;
                                    //  }
                                  });
                            }
                          }),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );

/*
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
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('book_collection')
              .snapshots(),
          builder: (context, dataSnapshot) {
            if (!dataSnapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return ListView.builder(
                  itemCount: dataSnapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot docSnapshot =
                        dataSnapshot.data.docs[index];

                    if (docSnapshot.data()['Categories'] == "Trending") {
                      return ListTile(
                          leading: Text('Trending'),
                          title: Text(docSnapshot['AuthorName']),
                          subtitle: Text(docSnapshot['BookName']),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BookDetail(
                                      post: dataSnapshot.data.docs[index],
                                    )));
                          });
                    } else if (docSnapshot.data()['Categories'] == "Sci-fi") {
                      return ListTile(
                          leading: Text('SC-fi'),
                          title: Text(docSnapshot['AuthorName']),
                          subtitle: Text(docSnapshot['BookName']),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BookDetail(
                                      post: dataSnapshot.data.docs[index],
                                    )));
                          });
                    } else if (docSnapshot.data()['Categories'] == "Latest") {
                      return ListTile(
                          leading: Text('Latest'),
                          title: Text(docSnapshot['AuthorName']),
                          subtitle: Text(docSnapshot['BookName']),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => BookDetail(
                                      post: dataSnapshot.data.docs[index],
                                    )));
                          });
                    }
                    return null;
                    //  }
                  });
            }
          }),
    );
  }*/
  }*/

/*
Widget display(
    String heading, DocumentSnapshot docSnapshot, BuildContext context) {
  return Container(
    child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            heading,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
            height: MediaQuery.of(context).size.height * 0.4,
            child: ListView.builder(
              itemBuilder: (ctx, i) => GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (ctx) => BookDetail(
                      post: docSnapshot,
                    ),
                  ),
                ),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Container(
                          margin: EdgeInsets.only(
                            top: 10,
                            left: 5,
                          ),
                          height: MediaQuery.of(context).size.height * 0.27,
                          width: MediaQuery.of(context).size.width * 0.4,
                          child: Stack(
                            children: [
                              Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: <BoxShadow>[
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.4),
                                      blurRadius: 5,
                                      offset: Offset(8, 8),
                                      spreadRadius: 1,
                                    )
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Image.network(
                                    docSnapshot['ImageUrl'],
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.27,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  gradient: new LinearGradient(
                                    colors: [
                                      Colors.black.withOpacity(0.4),
                                      Colors.transparent,
                                      Colors.black.withOpacity(0.4),
                                    ],
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          docSnapshot['BookName'],
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          docSnapshot['AuthorName'],
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 30,
                    ),
                  ],
                ),
              ),
              //itemCount: docSnapshot.data().length,
              scrollDirection: Axis.horizontal,
            ),
          )
        ],
      ),
    ),
  );
}
*/
