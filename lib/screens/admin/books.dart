import 'dart:io';
import 'dart:math';

import 'package:Ebook_App/screens/admin/admin_dashboard.dart';

import 'package:Ebook_App/screens/alertbox/alertbox.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:pdf_text/pdf_text.dart';

class Books extends StatefulWidget {
  @override
  _BooksState createState() => _BooksState();
}

class _BooksState extends State<Books> {
  final _formKey = GlobalKey<FormState>();
  final List<String> bookCategories = ["Sci-fi", "Latest", "Trending"];

  final List<String> bookStatus = ["Download", "Read"];

  String selectBook = "Download";
  // var bookID;
  String selectedCategories = "Sci-fi";
  var bookName;
  var authorName;
  var pdfFile;

  String message;

  String bookID;
  String randomName = "";

  List<String> bookNameIndex = [];

  File bookImage, pdfBook, audioBook;
  String bookImageUrl;
  String pdfBookUrl;
  String audioBookUrl;
  Reference reference;
  UploadTask uploadTask;
  PDFDoc _pdfDoc;
  String text = "";

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

    bookImage = await FilePicker.getFile(type: FileType.image);
    bookImageUrl = '$randomName' + '.jpg';
  }

// for pdf format
  Future getPdf() async {
    FocusScope.of(context).unfocus();
    generateNumber();

    pdfBook = await FilePicker.getFile(
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

    audioBook = await FilePicker.getFile(type: FileType.audio);
    audioBookUrl = '$randomName' + '.mp3';

    // storeAudio(file.readAsBytesSync(), fileName);
  }

// uploads in firebase storage
  /*storeBooks(List<int> asset, String name) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("book").child(name);
    UploadTask uploadTask = reference.putData(asset);
    bookUrl = await (await uploadTask).ref.getDownloadURL();
    print("............:" + bookUrl);
  }*/

// uploads in firebase storage
  /* storeAudio(List<int> asset, String name) async {
    Reference reference =
        FirebaseStorage.instance.ref().child("pictures").child(name);
    UploadTask uploadTask = reference.putData(asset);
    audioUrl = await (await uploadTask).ref.getDownloadURL();
    print("............:" + audioUrl);
  }*/

  Future convertPDF() async {
    FocusScope.of(context).unfocus();

    _pdfDoc = await PDFDoc.fromFile(pdfBook);
    setState(() {});

    if (pdfBook == null) {
      AlertBox('Please uplaod pdf file first');
    } else {
      text = await _pdfDoc.text;
      print("Hello=========================" + text);
    }
  }

// store book name in  an array
  void searchIndex() {
    List<String> spiltList = bookName.split(" ");

    for (int i = 0; i < spiltList.length; i++) {
      for (int y = 1; y < spiltList[i].length + 1; y++) {
        bookNameIndex.add(spiltList[i].substring(0, y).toLowerCase());
      }
    }
  }

  Future uploadBook() async {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      try {
        // spilt book name and store in array
        searchIndex();
        // for uploading book image
        reference = FirebaseStorage.instance.ref();

        reference = reference.child("book_image").child(bookImageUrl);
        uploadTask = reference.putData(bookImage.readAsBytesSync());
        bookImageUrl = await (await uploadTask).ref.getDownloadURL();
        print("............:" + bookImageUrl);

        // for pdf book
        reference = FirebaseStorage.instance.ref();
        reference = reference.child("pdf_book").child(pdfBookUrl);
        uploadTask = reference.putData(pdfBook.readAsBytesSync());
        pdfBookUrl = await (await uploadTask).ref.getDownloadURL();

        // for audio book
        if (audioBook != null) {
          reference = FirebaseStorage.instance.ref();
          reference = reference.child("audio_book").child(audioBookUrl);
          uploadTask = reference.putData(audioBook.readAsBytesSync());
          audioBookUrl = await (await uploadTask).ref.getDownloadURL();
        } else {
          audioBookUrl = null;
        }

        setState(() async {
          await FirebaseFirestore.instance
              .collection('book_collection')
              .doc()
              .set({
            'BookName': bookName,
            'AuthorName': authorName,
            'ImageUrl': bookImageUrl,
            'Categories': selectedCategories,
            'BookStatus': selectBook,
            'PDFBook': pdfBookUrl,
            'SearchIndex': bookNameIndex,
            'PDFText': text,
            'AudioBook': audioBookUrl,
          });
          AlertBox('Upload Successfull');
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
        title: Text('Add Book'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
                  padding: EdgeInsets.fromLTRB(15.0, 30.0, 15.0, 15.0),
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
                                  hintText: 'Book Name',
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
                                  hintText: 'Author Name',
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
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Categories',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      value: selectedCategories,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCategories = value;
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
                                  ],
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      child: Text(
                                        'Book Status',
                                        style: TextStyle(
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                    DropdownButton<String>(
                                      value: selectBook,
                                      onChanged: (value) {
                                        setState(() {
                                          selectBook = value;
                                        });
                                      },
                                      items: bookStatus
                                          .map<DropdownMenuItem<String>>(
                                              (value) {
                                        return DropdownMenuItem(
                                          child: Text(value),
                                          value: value,
                                        );
                                      }).toList(),
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
                                          'Audio Book',
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
                                        onPressed: convertPDF,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Convert pdf to Audio ',
                                            style: TextStyle(
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: RaisedButton(
                                        color: Colors.white,
                                        onPressed: getAudioBook,
                                        child: Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            'Add audio book',
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
                                    'Upload Book',
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
                                onPressed: uploadBook,
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
