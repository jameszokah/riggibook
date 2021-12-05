import 'package:flutter/material.dart';
import 'package:audio/service/model.dart';
import "package:audio/utils/utils.dart";

import 'AppColor.dart';
import 'DetailedAudioPage.dart';

class AllBook extends StatefulWidget {
  final List? books;
  AllBook({this.books});
  _AllBookState createState() => _AllBookState();
}

class _AllBookState extends State<AllBook> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: screenHeight,
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage("img/waves.png"),
                fit: BoxFit.cover,
              )),
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
                // IconButton(
                //   icon: Icon(Icons.search),
                //   onPressed: () {},
                // ),
              ],
            ),
          ),
          Positioned(
            top: screenHeight * 0.08,
            height: screenHeight * 0.92,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(left: 20, right: 20, top: 15),
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(maxCrossAxisExtent: 300, childAspectRatio: 3 / 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                // reverse: true,
                itemCount: this.widget.books!.length >= 0 ? this.widget.books!.length : 0,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (BuildContext context, int i) {
                  Book book = Book();
                  final image = book.image(this.widget.books![i]["identifier"]);
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedAudioPage(books: this.widget.books![i], fromLibrivox: true, fromHome: false, fromSub: false)));
                      // print(this.widget.books!);
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: const EdgeInsets.only(top: 6, bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              offset: Offset(0.0, 0.0),
                              blurRadius: 10,
                              color: Colors.black45.withOpacity(0.3),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Container(
                              // width: 160,
                              // height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                image: DecorationImage(
                                  image: NetworkImage(image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                gradient: LinearGradient(
                                  colors: <Color>[
                                    Colors.transparent,
                                    Colors.black.withOpacity(0.6),
                                  ],
                                  begin: Alignment.center,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Spacer(),
                                  Text(ShortTitle.shortTitle(this.widget.books![i]["title"], 21, ""),
                                      style: TextStyle(
                                        fontSize: 21,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  Text(ShortTitle.shortTitle(this.widget.books![i]["creator"], 21, ""),
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                        color: AppColor.starColor,
                                      )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
