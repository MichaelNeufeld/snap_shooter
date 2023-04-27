import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swipe_deck/swipe_deck.dart';

String url = "https://firebon.de:8081/Hunt_with_me/";

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(const MainApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

List<String>? imageString;

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Future<List<Image>> fetchAlbum() async {
    final response = await http.get(Uri.parse("${url}getFiles.php"));
    List<Image> images = [];
    if (response.statusCode == 200) {
      imageString =
          (jsonDecode(response.body) as List).map((e) => e as String).toList();
      for (var i = 0; i < imageString!.length; i++) {
        images.add(Image.network("${url}images/${imageString![i]}"));
      }
      return images;
    } else {
      throw Exception('Failed to load album${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: fetchAlbum(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Image> images = snapshot.data as List<Image>;
              return Center(
                child: SizedBox(
                  width: 600,
                  child: Center(
                    child: SwipeDeck(
                      cardSpreadInDegrees: 5,
                      startIndex: 0,
                      emptyIndicator: const Center(
                        child: Text("Nothing Here"),
                      ),
                      onSwipeLeft: () {
                        print("USER SWIPED LEFT -> GOING TO NEXT WIDGET");
                      },
                      onSwipeRight: () {
                        print("USER SWIPED RIGHT -> GOING TO PREVIOUS WIDGET");
                      },
                      onChange: (index) {
                        print(images[index]);
                      },
                      widgets: images
                          .map((e) => GestureDetector(
                                onTap: () {
                                  print("TAPPED");
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20.0),
                                    child: e),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Column(children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                  size: 60,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text('Error: ${snapshot.error}'),
                ),
              ]);
            } else {
              return Column(
                children: const [
                  SizedBox(
                    width: 60,
                    height: 60,
                    child: CircularProgressIndicator(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
