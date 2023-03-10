import 'package:flutter/material.dart';

import 'pong.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      title: "Simple Pong Game",
      home: Scaffold(
        appBar: AppBar(
          title: const  Text("Pong Game"),
        ),
        body: const SafeArea(child: Pong()),
      ),
    );
  }
}
