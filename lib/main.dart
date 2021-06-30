import 'package:flutter/material.dart';
import 'package:todo/ui/pages/home_page.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo Demo',
      home: HomePage(),
    );
  }
}

