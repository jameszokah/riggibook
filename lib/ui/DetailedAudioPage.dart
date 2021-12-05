import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'AppColor.dart';
import 'AudioBookPlayer.dart';
import "package:audio/utils/utils.dart";
import 'package:audio/service/model.dart';

class DetailedAudioPage extends StatefulWidget {
  final books;
  final bool? fromHome;
  final bool? fromSub;
  final bool? fromLibrivox;

  DetailedAudioPage({this.books, this.fromHome, this.fromSub, this.fromLibrivox});
  _DetailedAudioPageState createState() => _DetailedAudioPageState();
}

class _DetailedAudioPageState extends State<DetailedAudioPage> {
  late AudioPlayer audioBookPlayer;
  List bookAudio = [];
  List recentBook = [];
  List audioList = [];
  int audioUrlIndex = 0;

  void _getAudioFile() async {
    try {
      final id = this.widget.books['identifier'];

      Book book = Book();
      final files = await book.fetchAudioFiles(id);
      // print(files);
      setState(() {
        bookAudio = files;
        audioList = book.getAudioFile(id, files);
        // if (this.widget.fromLibrivox! == true) {
        //   audioBookPlayer.setUrl(audioList[0]);
        //   //audioBookPlayer.play(audioList[0]);
        // }
        print("audioList");
        print(audioList);
      });
    } catch (err) {
      print(this.widget.books['identifier']);
      setState(() {
        bookAudio = [];
      });
      print(err);
    }
  }

  _loadRecent() async {
    try {
      final resp = await DefaultAssetBundle.of(context).loadString("json/recent.json");
      final data = json.decode(resp);
      setState(() {
        recentBook = data;
        print(recentBook);
      });
    } catch (err) {
      print(err);
    }
  }

  @override
  void initState() {
    super.initState();
    audioBookPlayer = AudioPlayer(playerId: "audioBook");
    _getAudioFile();
    _loadRecent();
    // audioList.forEach((url) {
    //   audioBookPlayer.setUrl(url);
    // });
  }

  ImageProvider playerLogo() {
    ImageProvider logo = AssetImage('img/pic-3.png');
    if (this.widget.fromLibrivox! == true) {
      Book book = Book();
      final image = book.image(this.widget.books["identifier"]);
      setState(() {
        logo = NetworkImage(image);
      });
    } else if (this.widget.fromHome! == true) {
      setState(() {
        logo = AssetImage("assets/${this.widget.books['imageLink']}");
      });
    } else if (this.widget.fromSub! == true) {
      setState(() {
        logo = NetworkImage(this.widget.books["image"]);
      });
    }
    return logo;
  }

  String subTitle() {
    String title = "Martin James";
    if (this.widget.fromLibrivox! == true) {
      setState(() {
        title = ShortTitle.shortTitle(this.widget.books["creator"], 14, "Martin James");
      });
    } else {
      if (this.widget.fromHome! == true) {
        setState(() {
          title = ShortTitle.shortTitle(this.widget.books["author"], 14, "Martin James");
        });
      } else if (this.widget.fromSub! == true) {
        setState(() {
          title = ShortTitle.shortTitle(this.widget.books["subtitle"], 14, "Martin James");
        });
      }
    }
    return title;
  }

  playAudio(audio) async {
    if (mounted) {
      await audioBookPlayer.stop();
      // audioBookPlayer.setUrl(audio);
      await audioBookPlayer.play(audio);
    }
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Get.isDarkMode ? Colors.black12.withOpacity(1) : AppColor.audioBluishBackgound,
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight / 3,
            child: Container(
              color: AppColor.audioBlueBackgound,
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              backgroundColor: Colors.transparent,
              elevation: 0.0,
              actions: [
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {},
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: screenHeight / 5,
            height: screenHeight * 0.49,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Get.isDarkMode ? Colors.black38 : Colors.white,
              ),
            ),
          ),
          Positioned(
            top: screenHeight * 0.35,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  ShortTitle.shortTitle(this.widget.books["title"], 17, "The Art of War"),
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: "Averin",
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  subTitle(),
                  style: TextStyle(
                    fontSize: 20,
                    color: Get.isDarkMode ? Colors.grey[200] : AppColor.subTitleText,
                  ),
                  textAlign: TextAlign.center,
                ),
                AudioBookPlayer(audioBookPlayer: audioBookPlayer, audioUrls: audioList, audioUrlIndex: audioUrlIndex),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.12,
            left: (screenWidth - 150) / 2,
            right: (screenWidth - 150) / 2,
            height: screenHeight * 0.22,
            child: Container(
              decoration: BoxDecoration(
                color: Get.isDarkMode ? Colors.black54 : AppColor.audioGreyBackgound,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Get.isDarkMode ? Colors.black : Colors.white, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 5),
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: playerLogo(),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: (screenHeight / 3) - 20,
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                right: 20,
                bottom: 10,
              ),
              child: Container(
                child: this.widget.books['identifier'] != null
                    ? ListView.builder(
                        itemCount: bookAudio.length >= 0 ? bookAudio.length : 0,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int i) {
                          print(bookAudio[i]['name']);
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailedAudioPage(books: this.widget.books, fromLibrivox: true, fromHome: false, fromSub: false)));
                              setState(() {
                                audioUrlIndex = i;
                              });
                              // playAudio(audioList[i]);
                              // this.audioCallback!();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(top: 20),
                              decoration: BoxDecoration(
                                color: Get.isDarkMode ? Colors.black12 : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  children: [
                                    Icon(Icons.play_circle_filled_outlined, size: 30),
                                    SizedBox(width: 10),
                                    Text(bookAudio[i]['name'].length >= 34 ? "${bookAudio[i]['name'].substring(0, 34)} ..." : "${bookAudio[i]['name']}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : Column(
                        children: [
                          Text("Recent Books",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              )),
                          Expanded(
                            child: ListView.builder(
                              itemCount: recentBook.length >= 0 ? recentBook.length : 0,
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (BuildContext context, int i) {
                                return Container(
                                  margin: const EdgeInsets.only(top: 20, left: 10),
                                  decoration: BoxDecoration(
                                    color: Get.isDarkMode ? Colors.black12 : Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Container(
                                    width: 90,
                                    height: 100,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        image: AssetImage("${recentBook[i]['image']}"),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
