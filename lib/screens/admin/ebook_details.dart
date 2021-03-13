import 'dart:io';
import 'dart:math';

import 'package:Ebook_App/screens/admin/admin_dashboard.dart';

import 'package:Ebook_App/screens/alertbox/alertbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class EbookDetails extends StatefulWidget {
  String bookID,
      bookName,
      authorName,
      categories,
      bookImage,
      pdfBook,
      audioBook;
  EbookDetails(
      {this.bookID,
      this.bookName,
      this.authorName,
      this.categories,
      this.bookImage,
      this.pdfBook,
      this.audioBook});
  @override
  _EbookDetailsState createState() => _EbookDetailsState(
        bookID: bookID,
        bookName: bookName,
        authorName: authorName,
        categories: categories,
        bookImage: bookImage,
        pdfBook: pdfBook,
        audioBook: audioBook,
      );
}

class _EbookDetailsState extends State<EbookDetails> {
  String bookID,
      bookName,
      authorName,
      categories,
      bookImage,
      pdfBook,
      audioBook;
  _EbookDetailsState(
      {this.bookID,
      this.bookName,
      this.authorName,
      this.categories,
      this.bookImage,
      this.pdfBook,
      this.audioBook});

  final _formKey = GlobalKey<FormState>();
  TextEditingController _bookName = TextEditingController();
  TextEditingController _authorName = TextEditingController();
  final List<String> bookCategories = ["Sci-fi", "Latest", "Trending"];
  @override
  void initState() {
    _bookName.text = bookName;
    _authorName.text = authorName;
    super.initState();
  }
  // var bookID;

  var pdfFile;

  String message;

  String randomName = "";

  File updatedBookImage, updatedPdfBook, updatedAudioBook;
  String updatedBookName, updatedAuthorName;
  String bookImageUrl;
  String pdfBookUrl;
  String audioBookUrl;
  Reference reference;
  UploadTask uploadTask;

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
  Future getBookImage() async {
    FocusScope.of(context).unfocus();
    generateNumber();

    updatedBookImage = await FilePicker.getFile(type: FileType.image);
    bookImageUrl = '$randomName' + '.jpg';
  }

// for pdf format
  Future getPdf() async {
    FocusScope.of(context).unfocus();
    generateNumber();

    updatedPdfBook = await FilePicker.getFile(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    pdfBookUrl = '$randomName' + '.pdf';

    //storeBooks(file.readAsBytesSync(), fileName);
  }

// for audio books
  Future getAudioBook() async {
    FocusScope.of(context).unfocus();
    generateNumber();

    updatedAudioBook = await FilePicker.getFile(type: FileType.audio);
    audioBookUrl = '$randomName' + '.mp3';

    // storeAudio(file.readAsBytesSync(), fileName);
  }

  Future updateBook() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();

      try {
        // for uploading book image

        if (bookImageUrl != null) {
          reference = FirebaseStorage.instance.ref();
          reference = reference.child("book_image").child(bookImageUrl);
          uploadTask = reference.putData(updatedBookImage.readAsBytesSync());
          bookImage = await (await uploadTask).ref.getDownloadURL();
          print("............:" + bookImage);
        }

        // for pdf book
        if (pdfBookUrl != null) {
          reference = FirebaseStorage.instance.ref();
          reference = reference.child("pdf_book").child(pdfBookUrl);
          uploadTask = reference.putData(updatedPdfBook.readAsBytesSync());
          pdfBook = await (await uploadTask).ref.getDownloadURL();
        }

        // for audio book
        if (audioBookUrl != null) {
          reference = FirebaseStorage.instance.ref();
          reference = reference.child("audio_book").child(audioBookUrl);
          uploadTask = reference.putData(updatedAudioBook.readAsBytesSync());
          audioBook = await (await uploadTask).ref.getDownloadURL();
        }

        setState(() async {
          await FirebaseFirestore.instance
              .collection('book_collection')
              .doc(bookID)
              .update({
            'BookName': bookName,
            'AuthorName': authorName,
            'ImageUrl': bookImage,
            'Categories': categories,
            'PDFBook': pdfBook,
            'AudioBook': audioBook,
          });
          AlertBox('Updated Successfully');
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => AdminDashboard()));
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Book'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 15.0),
                        child: RaisedButton(
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10.0,
                                right: 1.0,
                                top: 15.0,
                                bottom: 15.0),
                            child: Text(
                              'Delete Account',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.black,
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
                                content: Text("Do you want to Delete Book?"),
                                actions: [
                                  FlatButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      setState(() {
                                        FirebaseFirestore.instance
                                            .collection("book_collection")
                                            .doc(bookID)
                                            .delete()
                                            .then((_) {
                                          Navigator.of(context).pushReplacement(
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      AdminDashboard()));
                                          AlertBox("Book Successfully Deleted");
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
                          color: Colors.grey[300],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(18.0, 15.0, 18.0, 15.0),
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
                                    Icons.book,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please, Enter Book Name';
                                  }
                                  return null;
                                },
                                controller: _bookName,
                                onSaved: (value) {
                                  bookName = value;
                                },
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                  ),
                                ),
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please, Enter Author Name';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  authorName = value;
                                },
                                controller: _authorName,
                              ),
                              SizedBox(
                                height: 20.0,
                              ),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 0, 10),
                                        child: Text(
                                          'Categories',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: DropdownButton<String>(
                                        value: categories,
                                        onChanged: (value) {
                                          setState(() {
                                            categories = value;
                                          });
                                        },
                                        items: bookCategories
                                            .map<DropdownMenuItem<String>>(
                                                (value) {
                                          return DropdownMenuItem(
                                            child: Text(value),
                                            value: value,
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 0, 10),
                                        child: Text(
                                          'Add Book Image',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: RaisedButton(
                                        color: Colors.white,
                                        onPressed: getBookImage,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Open Gallery',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 0, 10),
                                        child: Text(
                                          'Add PDF Book',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: RaisedButton(
                                        color: Colors.white,
                                        onPressed: getPdf,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Open File Explorer',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Container(
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 5, 0, 10),
                                        child: Text(
                                          'Add Audio Book',
                                          style: TextStyle(
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: RaisedButton(
                                        color: Colors.white,
                                        onPressed: getAudioBook,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Open File Explorer',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              RaisedButton(
                                child: Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text(
                                    'Update Book',
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
                                onPressed: updateBook,
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
