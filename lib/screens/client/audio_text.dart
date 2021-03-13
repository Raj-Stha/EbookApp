import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

// ignore: must_be_immutable
class TextAudio extends StatefulWidget {
  String bookImage, bookName, authorName, pdfText;
  TextAudio({this.pdfText, this.bookImage, this.bookName, this.authorName});
  @override
  _TextAudioState createState() => _TextAudioState(
      pdfText: pdfText,
      bookImage: bookImage,
      bookName: bookName,
      authorName: authorName);
}

enum TtsState { playing, stopped, continued }

class _TextAudioState extends State<TextAudio> {
  //bool isPlaying = true;
  String bookImage, bookName, authorName, pdfText;
  _TextAudioState(
      {this.pdfText, this.bookImage, this.bookName, this.authorName});

  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 1.0;
  double pitch = 1.0;
  double rate = 0.8;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isContinued => ttsState == TtsState.continued;

  @override
  initState() {
    super.initState();
    initTts();
    _speak();
  }

  initTts() {
    flutterTts = FlutterTts();

    //fetch languages
    _getLanguages();
    _getEngines();

    flutterTts.setStartHandler(() {
      setState(() {
        print("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _getLanguages() async {
    languages = await flutterTts.getLanguages;
    if (languages != null) setState(() => languages);
  }

  Future _getEngines() async {
    var engines = await flutterTts.getEngines;
    if (engines != null) {
      for (dynamic engine in engines) {
        print(engine);
      }
    }
  }

  Future _speak() async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    if (pdfText != null) {
      if (pdfText.isNotEmpty) {
        await flutterTts.awaitSpeakCompletion(true);
        await flutterTts.speak(pdfText);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  @override
  void dispose() {
    super.dispose();
    flutterTts.stop();
  }

  List<DropdownMenuItem<String>> getLanguageDropDownMenuItems() {
    var items = <DropdownMenuItem<String>>[];
    for (dynamic type in languages) {
      items.add(
          DropdownMenuItem(value: type as String, child: Text(type as String)));
    }
    return items;
  }

  void changedLanguageDropDownItem(String selectedType) {
    setState(() {
      language = selectedType;
      flutterTts.setLanguage(language);
    });
  }

  Future showEquailzer(BuildContext context) async {
    return await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  languages != null ? _languageDropDownSection() : Text(""),

                  /* Slider(
                      value: volume,
                      onChanged: (newVolume) {
                        setState(() => volume = newVolume);
                      },
                      min: 0.0,
                      max: 1.0,
                      divisions: 10,
                      label: "Volume: $volume"),*/
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Text(
                      'Pitch',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Slider(
                    value: pitch,
                    onChanged: (newPitch) {
                      setState(() => pitch = newPitch);
                    },
                    min: 0.5,
                    max: 2.0,
                    divisions: 15,
                    label: "Pitch: $pitch",
                    activeColor: Colors.red,
                  ),
                  Text(
                    'Audio Speed',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.start,
                  ),
                  Slider(
                    value: rate,
                    onChanged: (newRate) {
                      setState(() => rate = newRate);
                    },
                    min: 0.0,
                    max: 1.0,
                    divisions: 10,
                    label: "Rate: $rate",
                    activeColor: Colors.green,
                  ),
                ],
              ),
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(bookImage),
                  fit: BoxFit.cover,
                ),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 20,
                  sigmaY: 20,
                ),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.1),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: Colors.white,
                                  size: 35,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.settings,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  _stop();
                                  showEquailzer(context);
                                },
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            bottom: 150,
                          ),
                          height: MediaQuery.of(context).size.height * 0.35,
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
                          bookName,
                          style: TextStyle(
                            fontSize: 30,
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "By $authorName",
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),
                                topRight: Radius.circular(50),
                              ),
                            ),
                            padding: EdgeInsets.only(
                              left: 30,
                              right: 30,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Container(
                                  child: IconButton(
                                    color: Colors.green,
                                    iconSize: 40,
                                    icon: Icon(Icons.play_arrow),
                                    onPressed: _speak,
                                  ),
                                ),
                                IconButton(
                                  iconSize: 28,
                                  color: Colors.red,
                                  icon: Icon(Icons.stop),
                                  onPressed: _stop,
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _languageDropDownSection() => Container(
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
        Text(
          "Languages",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
        ),
        DropdownButton(
          value: language,
          items: getLanguageDropDownMenuItems(),
          onChanged: changedLanguageDropDownItem,
        ),
      ]));
}
