import 'package:flutter/material.dart';

class Ball extends StatelessWidget {
  const Ball({super.key});
  final double diameter = 50;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: diameter,
      width: diameter,
      decoration: const BoxDecoration(color: Colors.red,
      shape: BoxShape.circle),
    );
  }
}
