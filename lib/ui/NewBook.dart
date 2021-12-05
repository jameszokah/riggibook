import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'AppColor.dart';
import 'DetailedAudioPage.dart';

class NewBook extends StatelessWidget {
  final int? itemCount;
  final List? data;
  final Function? audioCallback;

  NewBook({@required this.itemCount, @required this.data, this.audioCallback});

  String _shortTitle(String title, int limit, String defaultTitle) {
    if (title.isNotEmpty) {
      if (title.length >= limit) {
        final newTitle = [];
        title.split(" ").fold(0, (int acc, cur) {
          if (limit >= (cur.length + acc)) {
            newTitle.add(cur);
          }
          return (acc + cur.length);
        });
        return "${newTitle.join(" ")} ...";
      }

      return title;
    }
    return defaultTitle;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: this.itemCount!,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int i) {
          return Shimmer(
            child: Container(
              margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 10.0, bottom: 10.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => DetailedAudioPage(books: data![i], fromSub: true, fromLibrivox: false, fromHome: false)));
                  this.audioCallback!();
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.tabVarViewColor,
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
                              image: NetworkImage(this.data![i]["image"]),
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Text(
                                  "\$ ",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColor.starColor),
                                ),
                                Text(
                                  "${data![i]['price'].substring(1)}",
                                  style: TextStyle(fontWeight: FontWeight.bold, color: AppColor.starColor),
                                ),
                              ],
                            ),
                            Text(
                              _shortTitle(data![i]['title'], 18, ""),
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Averin",
                              ),
                            ),
                            Text(
                              (data![i]['subtitle']).isNotEmpty ? _shortTitle(data![i]['subtitle'], 17, "") : _shortTitle(data![i]['title'], 17, ""),
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Averin",
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
