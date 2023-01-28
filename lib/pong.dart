import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_pong/widgets/ball.dart';
import 'package:simple_pong/widgets/bat.dart';

// enums for directions
enum Direction { up, down, left, right }

class Pong extends StatefulWidget {
  const Pong({super.key});

  @override
  State<Pong> createState() => _PongState();
}

class _PongState extends State<Pong> with SingleTickerProviderStateMixin {
  double height = 0;
  double width = 0;
  double positionX = 0;
  double positionY = 0;
  double batHeight = 0;
  double batWidth = 0;
  double batPosition = 0;

  double randomX = 1;
  double randomY = 1;

  int score = -1;

  Direction hDirection = Direction.right;
  Direction vDirection = Direction.down;

  int increament = 5;

  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void initState() {
    animationController = AnimationController(
      duration: const Duration(seconds: 100000000),
      vsync: this,
    );

    animation = Tween<double>(begin: 0, end: 100).animate(animationController!)
      ..addListener(() {
        safeSetState(() {
          hDirection == Direction.right
              ? positionX += (increament * randomX)
              : positionX -= (increament * randomX);
          vDirection == Direction.down
              ? positionY += (increament * randomY)
              : positionY -= (increament * randomY);
        });
        checkBorders();
      });
    animationController!.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  void showMessage(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Game Over"),
              content:const Text("Would you like to play again?"),
              actions: [
                TextButton(
                    onPressed: () {
                      positionX = 0;
                      positionY = 0;
                      score = 0;
                      Navigator.of(context).pop();
                      animationController!.repeat();
                    },
                    child: Text("Yes")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      dispose();
                    },
                    child:const Text("No"))
              ],
            ));
  }


  // get random int from 0.5 to 1.5
  double randomNumber() {
    int randomInt = Random().nextInt(101);
    return (randomInt + 50) / 100;
  }

  // check borders
  // if ball reaches to border change direction
  void checkBorders() {
    double diameter = 50;

    if (positionX <= 0 && hDirection == Direction.left) {
      hDirection = Direction.right;
      randomX = randomNumber();
    }
    if (positionX + diameter >= width && hDirection == Direction.right) {
      hDirection = Direction.left;
      randomX = randomNumber();
    }
    if (positionY <= 0 && vDirection == Direction.up) {
      vDirection = Direction.down;
      randomY = randomNumber();
    }

    // check if ball touches to bat
    if (positionY + diameter + batHeight >= height &&
        vDirection == Direction.down) {
      if (positionX >= (batPosition - diameter) &&
          positionX <= (batPosition + diameter)) {
        vDirection = Direction.up;
        randomY = randomNumber();
        safeSetState(() {
          score++;
        });
      } else {
        // end game
        animationController!.stop();
        showMessage(context);
      }
    }
  }

  // setState in safe mode- if animation still mounted
  void safeSetState(Function function) {
    if (mounted && animationController!.isAnimating) {
      setState(() {
        function();
      });
    }
  }

  // move bat right and left
  void moveBat(DragUpdateDetails updates) {
    safeSetState(() {
      batPosition += updates.delta.dx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        height = constraints.maxHeight;
        width = constraints.maxWidth;
        batHeight = height / 25;
        batWidth = width / 5;

        return Stack(
          children: [
            // Scores
            Positioned(
                top: 10,
                right: 20,
                child: Text(
                  "Your Score:${score.toString()}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),),

            // Ball    
            Positioned(left: positionX, top: positionY, child: const Ball()),
           
           // Bat
            Positioned(
              bottom: 0,
              left: batPosition,
              child: GestureDetector(
                onHorizontalDragUpdate: (DragUpdateDetails update) =>
                    moveBat(update),
                child: Bat(height: batHeight, width: batWidth),
              ),
            ),
          ],
        );
      },
    );
  }
}
