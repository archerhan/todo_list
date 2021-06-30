import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/providers/todo_provider.dart';
import 'package:todo/ui/pages/home_page.dart';

void main() async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<TodoProvider>.value(value: TodoProvider()),
    ],
    child: MyApp(),
  ));
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
