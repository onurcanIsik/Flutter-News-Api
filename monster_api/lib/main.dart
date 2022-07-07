// ignore_for_file: unnecessary_null_comparison, prefer_if_null_operators, unnecessary_new

import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monster_api/model/model.dart';
import 'package:monster_api/service/service.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Articles> data = [];
  bool? isLoading = false;
  late EasyRefreshController _controller;

  @override
  void initState() {
    NewsApi.getNews().then((value) {
      setState(() {
        if (value == null) {
          isLoading = false;
        } else {
          data = value;
          isLoading = true;
        }
      });
    });
    _controller = EasyRefreshController(
      controlFinishRefresh: true,
      controlFinishLoad: true,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 7, 66, 95),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => super.widget));
              });
            },
          )
        ],
        title: Text(
          "Get News Api",
          style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: data[index].urlToImage == null
                                ? const CircularProgressIndicator()
                                : Image.network("${data[index].urlToImage}",
                                    centerSlice: Rect.largest),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 130),
                            child: Card(
                              color: const Color.fromARGB(255, 137, 158, 159),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: ListTile(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20)),
                                title: Text(data[index].title!) == null
                                    ? const Text("VERİ YOK")
                                    : Text(data[index].title!),
                                subtitle: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_right,
                                        color: Colors.blue,
                                        size: 30,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          launchUrl(
                                              Uri.parse("${data[index].url}"));
                                        });
                                      },
                                    ),
                                    Expanded(
                                        child: data[index].description == null
                                            ? Text("VERİ YOK")
                                            : Text(
                                                "${data[index].description}"))
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
