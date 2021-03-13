import 'package:Ebook_App/screens/admin/ebook_details.dart';
import 'package:Ebook_App/services/ebook_function.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ViewEbooksInfo extends StatefulWidget {
  @override
  _ViewEbooksInfoState createState() => _ViewEbooksInfoState();
}

class _ViewEbooksInfoState extends State<ViewEbooksInfo> {
  EBookFunction eBookFunction;
  @override
  void initState() {
    //fetch ebooks information
    eBookFunction = Provider.of<EBookFunction>(context, listen: false);
    // eBookFunction.fetchAllEbook();

    print(eBookFunction.ebookInfo);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Ebooks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: ListView.builder(
            itemCount: eBookFunction.ebookInfo.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EbookDetails(
                    bookID: eBookFunction.ebookInfo[index].id,
                    bookImage: eBookFunction.ebookInfo[index]['ImageUrl'],
                    bookName: eBookFunction.ebookInfo[index]['BookName'],
                    authorName: eBookFunction.ebookInfo[index]['AuthorName'],
                    categories: eBookFunction.ebookInfo[index]['Categories'],
                    pdfBook: eBookFunction.ebookInfo[index]['PDFBook'],
                    audioBook: eBookFunction.ebookInfo[index]['AudioBook'],
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
                              backgroundImage: eBookFunction.ebookInfo[index]
                                          ['ImageUrl'] !=
                                      null
                                  ? NetworkImage(eBookFunction.ebookInfo[index]
                                      ['ImageUrl'])
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
                                  eBookFunction.ebookInfo[index]['BookName'],
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(
                                eBookFunction.ebookInfo[index]['AuthorName'],
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
