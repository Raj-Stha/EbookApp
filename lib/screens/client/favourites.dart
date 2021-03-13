import 'package:Ebook_App/screens/alertbox/alertbox.dart';
import 'package:Ebook_App/screens/client/book_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FavouriteBook extends StatefulWidget {
  @override
  _FavouriteBookState createState() => _FavouriteBookState();
}

class _FavouriteBookState extends State<FavouriteBook> {
  List favourite = [];
  int count = 0;
  User user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchFavouriteBook();
  }

  fetchFavouriteBook() async {
    favourite.clear();
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("Favourites")
        .get()
        .then((querySnapshot) {
      count = querySnapshot.docs.length;

      querySnapshot.docs.forEach((result) {
        FirebaseFirestore.instance
            .collection('book_collection')
            .doc(result.id)
            .get()
            .then((querySnapshot) {
          favourite.add(querySnapshot);

          setState(() {});
        });
      });
    });
    print('Count $count');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 30),
                child: Container(
                  child: Text(
                    "Favourite",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: favourite.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookDetail(
                        bookID: favourite[index].id,
                        bookImage: favourite[index]['ImageUrl'],
                        bookName: favourite[index]['BookName'],
                        authorName: favourite[index]['AuthorName'],
                        bookStatus: favourite[index]['BookStatus'],
                        pdfText: favourite[index]['PDFText'],
                        bookPDF: favourite[index]['PDFBook'],
                        audioBook: favourite[index]['AudioBook'],
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
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 10.0),
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
                                      favourite[index]['ImageUrl'] != null
                                          ? NetworkImage(
                                              favourite[index]['ImageUrl'])
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
                                      favourite[index]['BookName'],
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Text(
                                    favourite[index]['AuthorName'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400),
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
                                width: 90.0,
                                height: 45.0,
                                color: Colors.grey[300],
                                child: RaisedButton(
                                  onPressed: () {
                                    setState(() {
                                      User user =
                                          FirebaseAuth.instance.currentUser;
                                      FirebaseFirestore.instance
                                          .collection("users")
                                          .doc(user.uid)
                                          .collection("Favourites")
                                          .doc(favourite[index].id)
                                          .delete()
                                          .then((_) {
                                        fetchFavouriteBook();
                                        AlertBox("Book Successfully Removed");
                                        setState(() {
                                          count--;
                                        });
                                      });
                                    });
                                  },
                                  child: Text(
                                    "Remove",
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
