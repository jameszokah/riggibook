import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:xml2json/xml2json.dart';
import '../service/ThemeService.dart';
import 'AllBooks.dart';
import 'AppColor.dart';
import 'dart:convert';

import 'package:audio/service/model.dart';
import 'package:audio/ui/TopBook.dart';
import 'AppTabs.dart';
import 'NewBook.dart';
import 'PopularBook.dart';

class HomePage extends StatefulWidget {
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  late AudioPlayer audioBookPlayer;
  List newBooks = [];
  List audioBooks = [];
  List popularBooks = [];
  List newBookTab = [];
  List allBooks = [];
  List topBooks = [];

  late TabController _tabController;
  late ScrollController _scrollController;

  _initBook() async {
    try {
      final everyBook = await Book.fetchBooks();
      final mostBook = await Book.topBooks();
      setState(() {
        allBooks = everyBook;
        topBooks = mostBook;
      });
    } catch (err) {
      print(err);
    }
    print(topBooks);
  }

  _fetchBooks(url) async {
    try {
      final http.Response resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        final books = jsonDecode(resp.body);
        setState(() {
          newBooks = books["books"];
        });
        print(newBooks.length);
      }
    } catch (err) {
      print(err);
    }
  }

  _fetchAudio(url) async {
    try {
      final http.Response resp = await http.get(
        Uri.parse(url),
        headers: {
          "Accept": "application/json",
          "Access-Control-Allow-Origin": "*",
        },
      );
      if (resp.statusCode == 200) {
        final books = jsonDecode(resp.body);

        setState(() {
          audioBooks = books["books"];
        });
        print(audioBooks);
      }
    } catch (err) {
      print(err);
    }
  }

  _fetchAudioById(url, List bookName) async {
    try {
      final http.Response resp = await http.get(Uri.parse(url));
      if (resp.statusCode == 200) {
        final myTransformer = Xml2Json();

        // Parse a simple XML string

        myTransformer.parse(resp.body);
        print('XML string');
        print(resp.body);
        print('');

        // Transform to JSON using Badgerfish
        var json = myTransformer.toBadgerfish(useLocalNameForNodes: true);
        print('Badgerfish');
        print('');
        print(json);
        print('');
        final books = jsonDecode(json);
        setState(() {
          bookName = books["books"];
        });
        print(bookName.length);
      }
    } catch (err) {
      print(err);
    }
  }

  _readLocalData() async {
    final popularBooksResp = await DefaultAssetBundle.of(context).loadString("json/popularBooks.json");
    final jsonResp = jsonDecode(popularBooksResp);
    setState(() {
      popularBooks = jsonResp;
    });

    final newBooksResp = await DefaultAssetBundle.of(context).loadString("json/books.json");
    final newJsonResp = jsonDecode(newBooksResp);
    setState(() {
      newBookTab = newJsonResp;
    });
  }

  _stopAudio() {
    if (mounted) {
      audioBookPlayer.stop();
    }
  }

  @override
  void initState() {
    super.initState();
    _initBook();
    _fetchBooks("https://api.itbook.store/1.0/new");
    // _fetchAudio("https://librivox.org/api/feed/audiobooks?format=json");
    _readLocalData();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController = ScrollController();
    audioBookPlayer = AudioPlayer(playerId: "audioBook");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColor.background,
      child: SafeArea(
        child: Scaffold(
          drawer: Drawer(
            // Add a ListView to the drawer. This ensures the user can scroll
            // through the options in the drawer if there isn't enough vertical
            // space to fit everything.
            child: Column(
              // Important: Remove any padding from the ListView.
              children: [
                DrawerHeader(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("img/library-dark.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(child: Text('Audio Book', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30))),
                ),
                ListTile(
                  title: const Text('Dark Theme'),
                  onTap: () {
                    ThemeService().switchTheme();
                    print("theme changed");
                    // ...
                    Navigator.pop(context);
                  },
                ),
                Spacer(),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black,
                    child: Text("v 1.0.0", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
          body: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: ImageIcon(AssetImage("img/menu.png"), size: 22, color: Get.isDarkMode ? Colors.white : Colors.black),
                        onPressed: () {
                          Scaffold.of(context).openDrawer();
                        },
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.search),
                            onPressed: () {
                              print("Search");
                            }),
                        SizedBox(width: 10),
                        IconButton(
                            icon: Icon(Icons.library_books_rounded),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => AllBook(books: allBooks)));
                            }),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20),
                    child: Text(
                      "Popular Books",
                      style: TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Container(
                height: 180,
                child: Stack(
                  children: [
                    Positioned(
                      top: 0,
                      left: -20,
                      right: 0,
                      child: Container(
                        height: 180,
                        child: PageView.builder(
                          controller: PageController(viewportFraction: 0.8, keepPage: true),
                          itemCount: popularBooks.length >= 0 ? popularBooks.length : 0,
                          itemBuilder: (BuildContext context, int i) {
                            return Container(
                              height: 180,
                              margin: const EdgeInsets.only(right: 10),
                              width: ((MediaQuery.of(context).size.width) - 30),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                image: (newBooks.length >= 0 ? DecorationImage(image: AssetImage(popularBooks[i]["image"]), scale: 1.3, fit: BoxFit.fill) : null),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (BuildContext context, bool isScrolled) {
                    return [
                      SliverAppBar(
                        pinned: true,
                        backgroundColor: Get.isDarkMode ? Colors.black12 : Colors.white,
                        automaticallyImplyLeading: false,
                        bottom: PreferredSize(
                          preferredSize: Size.fromHeight(44.0),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 20),
                            color: Get.isDarkMode ? Colors.black12 : Colors.white,
                            child: TabBar(
                              controller: _tabController,
                              indicatorPadding: const EdgeInsets.all(0),
                              indicatorSize: TabBarIndicatorSize.label,
                              isScrollable: true,
                              labelPadding: const EdgeInsets.only(right: 10),
                              indicator: BoxDecoration(
                                color: Get.isDarkMode ? Colors.black12 : Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    blurRadius: 7,
                                    offset: Offset(0, 0),
                                  ),
                                ],
                              ),
                              tabs: [
                                AppTab(text: "Top Books", color: AppColor.menu1Color),
                                AppTab(text: "New", color: AppColor.menu2Color),
                                AppTab(text: "Trending", color: AppColor.menu3Color),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ];
                  },
                  body: TabBarView(
                    controller: _tabController,
                    children: [
                      TopBook(
                        books: topBooks,
                        itemCount: topBooks.length >= 0 ? topBooks.length : 0,
                        data: topBooks.length >= 0 ? topBooks : null,
                        audioCallback: _stopAudio,
                      ),
                      PopularBook(
                        books: newBookTab,
                        itemCount: newBookTab.length >= 0 ? newBookTab.length : 0,
                        data: newBookTab.length >= 0 ? newBookTab : null,
                        audioCallback: _stopAudio,
                      ),
                      NewBook(
                        itemCount: newBooks.length >= 0 ? newBooks.length : 0,
                        data: newBooks.length >= 0 ? newBooks : null,
                        audioCallback: _stopAudio,
                      ),
                    ],
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
