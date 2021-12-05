import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'AppColor.dart';
import 'DetailedAudioPage.dart';
import "package:audio/utils/utils.dart";
import 'package:shimmer_animation/shimmer_animation.dart';

class PopularBook extends StatelessWidget {
  final int? itemCount;
  final List? data;
  final books;
  final Function? audioCallback;
  PopularBook({@required this.itemCount, @required this.data, this.books, this.audioCallback});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: this.itemCount!,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int i) {
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedAudioPage(books: books[i], fromHome: true, fromLibrivox: false, fromSub: false)));
              this.audioCallback!();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.black38 : AppColor.tabVarViewColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 2,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 90,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: AssetImage("assets/${this.data![i]['imageLink']}"),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "${data![i]['language']}",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.starColor),
                                ),
                              ],
                            ),
                            Text(
                              ShortTitle.shortTitle(data![i]['title'], 18, ""),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Averin",
                              ),
                            ),
                            Text(
                              (data![i]['author']).isNotEmpty ? ShortTitle.shortTitle(data![i]['author'], 17, "") : ShortTitle.shortTitle(data![i]['title'], 17, ""),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Averin",
                                color: Colors.grey[300],
                              ),
                            ),
                            Container(
                              width: 50,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppColor.loveColor,
                              ),
                              child: Text(
                                "${data![i]['year']}",
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "Averin",
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Text(
                            "${data![i]['pages']}",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Averin",
                              color: AppColor.menu2Color,
                            ),
                          ),
                          Text("pages"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
