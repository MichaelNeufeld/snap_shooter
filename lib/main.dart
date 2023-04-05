import 'package:flutter/material.dart';
import 'package:swipe_deck/swipe_deck.dart';

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
          future: ,
          builder: (context, snapshot) => Center(
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
                  cardSpreadInDegrees: 5, // Change the Spread of Background Cards
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
          ),
        ),
      ),
    );
  }
}
