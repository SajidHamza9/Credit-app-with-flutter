import 'package:credit_app/widgets/background.dart';
import 'package:credit_app/widgets/body.dart';
import 'package:flutter/material.dart';

class LandingScreen extends StatelessWidget {
  static const routeName = '/landing';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Background(Body())),
    );
  }
}
