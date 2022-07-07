import 'dart:convert';

import 'package:monster_api/model/model.dart';
import 'package:http/http.dart' as http;

class NewsApi {
  static Future<List<Articles>?> getNews() async {
    var res = await http.get(Uri.parse(
        "https://newsapi.org/v2/everything?domains=wsj.com&apiKey=168026e3b94b4835afb674c78a37e580"));

    if (res.body.isNotEmpty) {
      final resJson = jsonDecode(res.body);
      Repo artc = Repo.fromJson(resJson);
      return artc.articles;
    } else {
      print("HATA");
    }
    return null;
  }
}
