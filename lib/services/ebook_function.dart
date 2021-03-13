import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';

class EBookFunction extends ChangeNotifier {
  List ebookInfo = [];

  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // List favourite = [];

  //int count = 0;
  //User user = FirebaseAuth.instance.currentUser;

//fetch all ebook details
  fetchAllEbook() async {
    try {
      ebookInfo.clear();
      await _firestore
          .collection('book_collection')
          .get()
          .then((querySnapshot) {
        querySnapshot.docs.forEach((result) {
          ebookInfo.add(result);
        });
      });
    } catch (e) {
      print(e);
    }
  }
/*
  // fatch Favourite Book
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
        });
      });
    });
    print('Count $count');
    notifyListeners();
  }*/
/*
  deleteFavouriteBook(String id) {
    User user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("Favourites")
        .doc(id)
        .delete()
        .then((_) {});
    fetchFavouriteBook();
    count--;
    AlertBox("Book Successfully Removed");

    notifyListeners();
  }*/
}
