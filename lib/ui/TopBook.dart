import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'AppColor.dart';
import 'DetailedAudioPage.dart';
import 'package:audio/service/model.dart';
import "package:audio/utils/utils.dart";
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:timeago/timeago.dart' as timeago;

class TopBook extends StatelessWidget {
  final int? itemCount;
  final List? data;
  final books;
  final Function? audioCallback;
  TopBook({@required this.itemCount, @required this.data, this.books, this.audioCallback});

  @override
  Widget build(BuildContext context) {
    print(data);
    return ListView.builder(
        itemCount: this.itemCount!,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int i) {
          Book book = Book();
          final image = book.image(data![i]["identifier"]);
          print(data![i]['creator']);
          return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedAudioPage(books: books[i], fromLibrivox: true, fromHome: false, fromSub: false)));
              this.audioCallback!();
            },
            child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.black26 : AppColor.tabVarViewColor,
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
                            image: NetworkImage(image),
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
                              children: [
                                Icon(Icons.star, color: AppColor.starColor),
                                SizedBox(width: 8),
                                Text(
                                  data![i]['avg_rating'] != null ? "${data![i]['avg_rating']}" : "4.0",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.starColor),
                                )
                              ],
                              //  data![i]['subject'].map((item) => (Text(
                              //       item,
                              //       style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.starColor),
                              //     ))),
                            ),
                            Text(
                              ShortTitle.shortTitle(data![i]['title'], 18, "The Art of War"),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Averin",
                              ),
                            ),
                            Text(
                              data![i]['creator'] != null ? "${ShortTitle.shortTitle(data![i]['creator'], 17, 'The Art of War')}" : "${ShortTitle.shortTitle(data![i]['title'], 17, 'The Art of War')}",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Averin",
                                color: Colors.grey[300],
                              ),
                            ),
                            Container(
                              width: 60,
                              height: 20,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                color: AppColor.loveColor,
                              ),
                              child: Text(
                                data![i]['runtime'] != null ? "${data![i]['runtime']}" : "1:03:40",
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
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.end,
                      //   children: <Widget>[
                      //     Text(
                      //       "${timeago.format(DateTime.parse(data![i]['date']))}",
                      //       style: TextStyle(
                      //         fontSize: 12,
                      //         fontWeight: FontWeight.bold,
                      //         fontFamily: "Averin",
                      //         color: AppColor.menu2Color,
                      //       ),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
