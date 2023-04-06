import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:swipe_deck/swipe_deck.dart';

String url = "firebon.de/snap_shooter/images";

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: FutureBuilder(
          future: http.get(Uri.https(url)),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Center(
                child: SizedBox(
                  width: 600,
                  child: Center(
                    child: SwipeDeck(
                      startIndex: 3,
                      emptyIndicator: Container(
                        child: const Center(
                          child: Text("Nothing Here"),
                        ),
                      ),
                      cardSpreadInDegrees:
                          5, // Change the Spread of Background Cards
                      onSwipeLeft: () {
                        print("USER SWIPED LEFT -> GOING TO NEXT WIDGET");
                      },
                      onSwipeRight: () {
                        print("USER SWIPED RIGHT -> GOING TO PREVIOUS WIDGET");
                      },
                      onChange: (index) {
                        print(IMAGES[index]);
                      },
                      widgets: IMAGES
                          .map((e) => GestureDetector(
                                onTap: () {
                                  print(e);
                                },
                                child: ClipRRect(
                                    borderRadius: borderRadius,
                                    child: Image.asset(
                                      "assets/images/$e.jpg",
                                      fit: BoxFit.cover,
                                    )),
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
