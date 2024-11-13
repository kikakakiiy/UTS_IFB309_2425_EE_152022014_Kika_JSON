import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(CuacaApp());
}

class CuacaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CuacaHomePage(),
    );
  }
}
