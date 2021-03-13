import 'package:Ebook_App/screens/alertbox/alertbox.dart';
import 'package:Ebook_App/screens/client/Audio_Book.dart';
import 'package:Ebook_App/screens/client/audio_text.dart';
import 'package:Ebook_App/services/ebook_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'read_book.dart';

// ignore: must_be_immutable
class BookDetail extends StatefulWidget {
  String bookID,
      bookName,
      bookImage,
      bookPDF,
      audioBook,
      pdfText,
      authorName,
      bookStatus;

  BookDetail(
      {this.bookID,
      this.bookName,
      this.bookImage,
      this.bookPDF,
      this.audioBook,
      this.pdfText,
      this.authorName,
      this.bookStatus});
  @override
  _BookDetailState createState() => _BookDetailState(
      bookID: bookID,
      bookName: bookName,
      bookImage: bookImage,
      bookPDF: bookPDF,
      audioBook: audioBook,
      pdfText: pdfText,
      authorName: authorName,
      bookStatus: bookStatus);
}

class _BookDetailState extends State<BookDetail> {
  String bookID,
      bookName,
      bookImage,
      bookPDF,
      audioBook,
      pdfText,
      authorName,
      bookStatus;

  _BookDetailState(
      {this.bookID,
      this.bookName,
      this.bookImage,
      this.bookPDF,
      this.audioBook,
      this.pdfText,
      this.authorName,
      this.bookStatus});
  String pdfLink, audioLink;

  bool favouriteAdded;
  @override
  void initState() {
    super.initState();
    pdfLink = bookPDF;
    audioLink = audioBook;

    fetchfavouriteBook();
  }

  EBookFunction eBookFunction;

  User user = FirebaseAuth.instance.currentUser;
  bool favbook = false;

  fetchfavouriteBook() {
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("Favourites")
        .doc(bookID)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.data() != null) {
        favbook = true;
      } else {
        favbook = false;
      }
      setState(() {});
    });
  }

  void _readBooks() {
    if (pdfLink == null) {
      AlertBox('Unable to load Book');
    } else {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ReadBook(
                pdfLink: pdfLink,
                bookName: bookName,
                bookStatus: bookStatus,
              )));
    }
  }

  void _listenBooks() {
    if (audioLink != null && pdfText != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TextAudio(
          pdfText: pdfText,
          bookImage: bookImage,
          bookName: bookName,
          authorName: authorName,
        ),
      ));
    } else if (pdfText == null && audioLink != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => AudioBook(
          audioLink: audioLink,
          bookImage: bookImage,
          bookName: bookName,
          authorName: authorName,
        ),
      ));
    } else if (audioLink == null && pdfText != null) {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => TextAudio(
          pdfText: pdfText,
          bookImage: bookImage,
          bookName: bookName,
          authorName: authorName,
        ),
      ));
    } else {
      AlertBox('Unable to load Audio Book');
    }
  }

//add favourite books to users
  void addToFaourite() {
    User user = FirebaseAuth.instance.currentUser;
    try {
      if (user.uid != null) {
        FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("Favourites")
            .doc(bookID)
            .set({
          "BookID": bookID,
          "FavouriteAdded": true,
        });
        setState(() {
          favbook = true;
        });
      }
      AlertBox("Added to Favourites");
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Stack(
          children: [
            SafeArea(
              child: Container(
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 15,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 35,
                            ),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          favbook == true
                              ? IconButton(
                                  icon: Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      User user =
                                          FirebaseAuth.instance.currentUser;
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(user.uid)
                                          .collection("Favourites")
                                          .doc(bookID)
                                          .delete()
                                          .then((_) {
                                        setState(() {
                                          favbook = false;
                                        });

                                        AlertBox("Book Successfully Removed");
                                      });
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                                  onPressed: () {
                                    addToFaourite();
                                  },
                                )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                        bottom: 30,
                      ),
                      height: MediaQuery.of(context).size.height * 0.32,
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 25,
                                  offset: Offset(8, 8),
                                  spreadRadius: 3,
                                ),
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.3),
                                  blurRadius: 25,
                                  offset: Offset(-8, -8),
                                  spreadRadius: 3,
                                )
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                // "assets/images/0.jfif",
                                bookImage,
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                          Container(
                            height: double.infinity,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: new LinearGradient(
                                colors: [
                                  Colors.black.withOpacity(0.3),
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.3),
                                ],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      // "Conjure Women",
                      bookName,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      //"By Afia Atakora",
                      "By $authorName",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.all(24),
                      height: 8,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Container(
                          padding: EdgeInsets.only(
                            top: 10,
                            left: 40,
                            right: 20,
                          ),
                          child: Text(
                            "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                            style: TextStyle(
                              fontSize: 20,
                              letterSpacing: 1.5,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.15,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: new LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.3),
                      Colors.white.withOpacity(0.7),
                      Colors.white.withOpacity(0.8),
                      Colors.white,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 120,
                        height: 50,
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue,
                        ),
                        child: FlatButton(
                          onPressed: _readBooks,
                          child: Text(
                            "READ",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Container(
                        width: 120,
                        height: 50,
                        padding: EdgeInsets.symmetric(
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Colors.blue,
                        ),
                        child: FlatButton(
                          onPressed: _listenBooks,
                          child: Text(
                            "LISTEN",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ),
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

    /*return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Books Details"),
        ),
        body: Column(
          children: [
            RaisedButton(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Read',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: _readBooks,
              color: Colors.blue,
            ),
            RaisedButton(
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Listen',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              onPressed: _listenBooks,
              color: Colors.blue,
            ),
          ],
        ));*/
  }

  /*
  @override
  Widget build(BuildContext context) {
    viewNow() async {
      String data = post['PDFBook'];
      document = await PDFDocument.fromURL(data);

      setState(() {});
    }

    Widget loading() {
      viewNow();
      if (document == null) {
        return Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
            strokeWidth: 4,
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Retrieve Pdf"),
      ),
      body: document == null ? loading() : PDFViewer(document: document),
    );

    /*


    return Container(
        child: Card(
      child: ListTile(
        title: Text(widget.post['AuthorName']),
      ),
    ));*/
  }*/
}
