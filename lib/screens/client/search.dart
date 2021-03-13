import 'package:Ebook_App/screens/client/book_details.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController search = TextEditingController();
  String bookName = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Container(
                  child: TextField(
                    controller: search,
                    onChanged: (value) {
                      setState(() {
                        bookName = value.toLowerCase();
                      });
                    },
                    decoration: InputDecoration(
                        hintText: "Search your book here",
                        prefixIcon: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () => search.clear(),
                        )),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: bookName != "" && bookName != null
                        ? FirebaseFirestore.instance
                            .collection('book_collection')
                            .where("SearchIndex", arrayContains: bookName)
                            .snapshots()
                        : FirebaseFirestore.instance
                            .collection("book_collection")
                            .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.hasError)
                        return new Text('Error: ${snapshot.error}');
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                          return new Text('Loading...');
                        default:
                          return ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                              print(document['BookName']);
                              return new Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        vertical: 10,
                                      ),
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.45,
                                      child: ListView.builder(
                                        itemBuilder: (ctx, i) =>
                                            GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) => BookDetail(
                                                bookID: document.id,
                                                bookName: document["BookName"],
                                                bookImage: document["ImageUrl"],
                                                authorName:
                                                    document["AuthorName"],
                                                bookPDF: document["PDFBook"],
                                                pdfText: document["PDFText"],
                                                audioBook:
                                                    document["AudioBook"],
                                                bookStatus:
                                                    document["BookStatus"],
                                              ),
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Column(
                                                children: [
                                                  Container(
                                                    margin: EdgeInsets.only(
                                                      top: 10,
                                                    ),
                                                    height:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .height *
                                                            0.27,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.4,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            boxShadow: <
                                                                BoxShadow>[
                                                              BoxShadow(
                                                                color: Colors
                                                                    .black
                                                                    .withOpacity(
                                                                        0.4),
                                                                blurRadius: 5,
                                                                offset: Offset(
                                                                    8, 8),
                                                                spreadRadius: 1,
                                                              )
                                                            ],
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            child:
                                                                Image.network(
                                                              document[
                                                                  "ImageUrl"],
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          height: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .height *
                                                              0.27,
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            gradient:
                                                                new LinearGradient(
                                                              colors: [
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.4),
                                                                Colors
                                                                    .transparent,
                                                                Colors.black
                                                                    .withOpacity(
                                                                        0.4),
                                                              ],
                                                              begin: Alignment
                                                                  .centerLeft,
                                                              end: Alignment
                                                                  .centerRight,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 16),
                                                  Text(
                                                    document["BookName"],
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 2,
                                                  ),
                                                  Text(
                                                    document["AuthorName"],
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
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
                                        itemCount: 1,
                                        scrollDirection: Axis.horizontal,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          );

                        /*ListView(
                            children: snapshot.data.docs
                                .map((DocumentSnapshot document) {
                              return new ListTile(
                                title: new Text(document['BookName']),
                              );
                            }).toList(),
                          );*/
                      }
                    },
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
