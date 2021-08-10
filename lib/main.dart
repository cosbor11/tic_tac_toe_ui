import 'package:flutter/material.dart';
import 'pages/MyHomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tic Tac Toe',
      theme: ThemeData(
          primarySwatch: Colors.brown,
          textTheme: const TextTheme(
              headline2: TextStyle(fontWeight: FontWeight.bold))),
      home: MyHomePage(title: 'Tic Tac Toe'),
    );
  }
}
