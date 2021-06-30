import 'package:flutter/material.dart';
import 'package:todo/db/todo_db_provider.dart';
import 'package:todo/ui/pages/todo_list_page.dart';

///
/// Description:
/// Author: ArcherHan
/// Date: 2021-06-30 14:22:39
/// LastEditors: ArcherHan
/// LastEditTime: 2021-06-30 14:29:58
///

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SafeArea(child: _renderHorizentalPageView()));
  }

  Widget _renderHorizentalPageView() {
    PageController _hPageController =
        PageController(initialPage: 1, viewportFraction: 1, keepPage: true);
    return TodoListPage();
    return PageView(
      scrollDirection: Axis.horizontal,
      reverse: false,
      controller: _hPageController,
      physics: BouncingScrollPhysics(),
      pageSnapping: true,
      children: <Widget>[
        TodoListPage(),
      ],
    );
  }
}
