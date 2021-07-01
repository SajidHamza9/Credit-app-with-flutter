import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  Widget child;
  Background(this.child);
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height,
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            width: size.width * 0.25,
            top: 0,
            left: 0,
            child: Image.asset(
              "assets/images/Vector1.png",
            ),
          ),
          Positioned(
            width: size.width * 0.25,
            bottom: 0,
            right: 0,
            child: Image.asset("assets/images/Vector2.png"),
          ),
          child
        ],
      ),
    );
  }
}
