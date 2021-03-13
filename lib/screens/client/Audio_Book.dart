import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AudioBook extends StatefulWidget {
  String bookImage, bookName, authorName, audioLink;
  AudioBook({this.audioLink, this.bookImage, this.bookName, this.authorName});
  @override
  _AudioBookState createState() => _AudioBookState(
      audioLink: audioLink,
      bookImage: bookImage,
      bookName: bookName,
      authorName: authorName);
}

class _AudioBookState extends State<AudioBook> {
  String bookImage, bookName, authorName, audioLink;
  _AudioBookState(
      {this.audioLink, this.bookImage, this.bookName, this.authorName});

  AudioPlayer _audioPlayer = AudioPlayer();
  bool isPlaying = true;
  String currentTime = "00:00";
  String completeTime = "00:00";
  double currentTimeValue = 0.0;
  double totalDurtaion = 0.0;
  @override
  void initState() {
    super.initState();
    playAudio();

    // current time playing
    _audioPlayer.onAudioPositionChanged.listen((Duration duration) {
      setState(() {
        currentTime = duration.toString().split(".")[0];
        currentTimeValue = duration.inSeconds.toDouble();
      });
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        completeTime = duration.toString().split(".")[0];
        totalDurtaion = duration.inSeconds.toDouble();
      });
    });
  }

  Future<void> playAudio() async {
    _audioPlayer.play(audioLink, isLocal: true);
  }

  skip(int sec) {
    Duration newPosition = Duration(seconds: sec);
    _audioPlayer.seek(newPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
                      horizontal: 20,
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
                            _audioPlayer.stop();
                          },
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 35,
                          ),
                          onPressed: () {},
                        )
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(
                      bottom: 90,
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
                    // "Conjure Women",
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
                    //"By Afia Atakora",
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Column(
                              children: [
                                SliderTheme(
                                  data: SliderThemeData(
                                    trackHeight: 5,
                                    thumbShape: RoundSliderThumbShape(
                                        enabledThumbRadius: 5),
                                  ),
                                  child: Slider.adaptive(
                                    activeColor: Colors.grey[600],
                                    inactiveColor: Colors.grey,
                                    value: currentTimeValue == 0.0
                                        ? 0
                                        : currentTimeValue,
                                    max: totalDurtaion == 0.0
                                        ? 0
                                        : totalDurtaion,
                                    onChanged: (value) {
                                      skip(value.toInt());
                                    },
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(currentTime),
                                    Text(completeTime),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(bottom: 20, left: 60),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  child: IconButton(
                                    color: Colors.black,
                                    iconSize: 40,
                                    icon: Icon(isPlaying
                                        ? Icons.pause
                                        : Icons.play_arrow),
                                    onPressed: () {
                                      if (isPlaying) {
                                        _audioPlayer.pause();
                                        setState(() {
                                          isPlaying = false;
                                        });
                                      } else {
                                        _audioPlayer.resume();
                                        setState(() {
                                          isPlaying = true;
                                        });
                                      }
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: IconButton(
                                    iconSize: 28,
                                    icon: Icon(Icons.stop),
                                    onPressed: () {
                                      _audioPlayer.stop();
                                      setState(() {
                                        isPlaying = false;
                                      });
                                    },
                                  ),
                                ),
                              ],
                            ),
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
    );

    /* return Scaffold(
      body: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SliderTheme(
                    data: SliderThemeData(
                      trackHeight: 5,
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5),
                    ),
                    child: Slider.adaptive(
                      activeColor: Colors.blue,
                      inactiveColor: Colors.grey,
                      value: currentTimeValue == 0.0 ? 0 : currentTimeValue,
                      max: totalDurtaion == 0.0 ? 0 : totalDurtaion,
                      onChanged: (value) {
                        skip(value.toInt());
                      },
                    ),
                  ),

                  /* SliderTheme(
                      data: SliderThemeData(
                        trackHeight: 5,
                        thumbShape:
                            RoundSliderThumbShape(enabledThumbRadius: 5),
                      ),
                      child: Slider(
                        value: 0,
                        activeColor: Colors.blue,
                        inactiveColor: Colors.black.withOpacity(0.3),
                        onChanged: (value) {},
                      )),*/
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        currentTime,
                        style: TextStyle(fontSize: 20),
                      ),
                      Text(" | "),
                      Text(
                        completeTime,
                        style: TextStyle(fontSize: 20),
                      ),
                      IconButton(
                        icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                        onPressed: () {
                          if (isPlaying) {
                            _audioPlayer.pause();
                            setState(() {
                              isPlaying = false;
                            });
                          } else {
                            _audioPlayer.resume();
                            setState(() {
                              isPlaying = true;
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: () {
                          _audioPlayer.stop();
                          setState(() {
                            isPlaying = false;
                          });
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );*/
  }
}
