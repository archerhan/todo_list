import 'package:flutter/material.dart';
import 'package:todo/ui/pages/home_page.dart';
import 'package:todo/utils/sp_util.dart';

void main() async {
  // await SpUtil.getInstance();
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

