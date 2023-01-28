import 'package:flutter/material.dart';

class Bat extends StatelessWidget {
  const Bat({super.key, required this.height, required this.width});
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Container(height: height,
    width: width,
    color: Colors.blue,);
  }
}
