import 'package:http/http.dart' as http;
import "dart:convert";
import 'dart:core';

class Book {
  final String _baseImage = "https://archive.org/services/get-item-image.php?identifier=";
  final String _audioFilePath = "https://archive.org/download";
  final String _metadata = "https://archive.org/metadata";

  static Future<List<dynamic>> fetchBooks() async {
    List data = [];
    try {
      final String bookCollection = "https://archive.org/advancedsearch.php?q=collection:(librivoxaudio)&fl=runtime,avg_rating,num_reviews,title,description,identifier,creator,date,downloads,subject,item_size&sort[]=addeddate desc&output=json";
      final url = Uri.parse(bookCollection);
      final http.Response resp = await http.get(url);
      if (resp.statusCode == 200) {
        final jsonResp = jsonDecode(resp.body);
        data = jsonResp["response"]["docs"];
      }
    } catch (err) {
      print(err);
    }
    return data;
  }

  static Future<List<dynamic>> topBooks() async {
    List data = [];
    try {
      final String _mostDownloads = "https://archive.org/advancedsearch.php?q=collection:(librivoxaudio)&fl=runtime,avg_rating,num_reviews,title,description,identifier,creator,date,downloads,subject,item_size&sort[]=downloads desc&rows=10&page=1&output=json";
      final url = Uri.parse(_mostDownloads);
      final http.Response resp = await http.get(url);
      if (resp.statusCode == 200) {
        final jsonResp = jsonDecode(resp.body);
        data = jsonResp["response"]["docs"];
      }
    } catch (err) {
      print(err);
    }

    return data;
  }

  Future<List> fetchAudioFiles(String bookId) async {
    List afiles = [];
    final response = await http.get(Uri.parse("$_metadata/$bookId/files"));
    if (response.statusCode == 200) {
      Map resJson = json.decode(response.body);
      print(resJson);
      resJson["result"].forEach((item) {
        if (item["source"] == "original" && item["track"] != null) {
          item["book_id"] = bookId;
          afiles.add(item);
        }
      });
    }

    return afiles;
  }

  getAudioFile(dynamic id, List fileData) {
    return fileData.map((data) => "$_audioFilePath/$id/${data['name']}").toList();
  }

  book(List bookList, dynamic id) => bookList.map((b) => b["identifier"] == id);

  String image(id) => "$_baseImage$id";
}
