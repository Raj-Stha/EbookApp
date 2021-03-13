import 'package:Ebook_App/screens/alertbox/alertbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class ReadBook extends StatefulWidget {
  String pdfLink, bookName, bookStatus;
  ReadBook({this.pdfLink, this.bookName, this.bookStatus});
  @override
  _ReadBookState createState() => _ReadBookState(
      pdfLink: pdfLink, bookName: bookName, bookStatus: bookStatus);
}

class _ReadBookState extends State<ReadBook> {
  String pdfLink, bookName, bookStatus;
  _ReadBookState({this.pdfLink, this.bookName, this.bookStatus});
  PDFDocument document;

  @override
  Widget build(BuildContext context) {
    viewNow() async {
      document = await PDFDocument.fromURL(pdfLink);

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
      return null;
    }

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
                          bookStatus == "Download"
                              ? IconButton(
                                  icon: Icon(
                                    Icons.file_download,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                                  onPressed: () async {
                                    final externalDir =
                                        await getExternalStorageDirectory();
                                    final status =
                                        await Permission.storage.request();
                                    if (status.isGranted) {
                                      FlutterDownloader.enqueue(
                                          url: pdfLink,
                                          savedDir: externalDir.path,
                                          fileName: bookName + ".pdf",
                                          showNotification: true,
                                          openFileFromNotification: true);
                                    } else {
                                      AlertBox("Permission Denied");
                                    }
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.favorite_border,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                                  onPressed: () {},
                                ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 8,
                      child: document == null
                          ? loading()
                          : PDFViewer(document: document),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );

    /*

    
                //  document == null ? loading() : PDFViewer(document: document),


    return Container(
        child: Card(
      child: ListTile(
        title: Text(widget.post['AuthorName']),
      ),
    ));*/
  }
}
