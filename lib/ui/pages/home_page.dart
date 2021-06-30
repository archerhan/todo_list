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
    return PageView(
      scrollDirection: Axis.horizontal,
      reverse: false,
      controller: _hPageController,
      physics: BouncingScrollPhysics(),
      pageSnapping: true,
      onPageChanged: (index) {
        //监听事件
        print('index=====$index');
      },
      children: <Widget>[
        // Container(
        //   color: Colors.indigo,
        //   child: Center(
        //     child: GestureDetector(
        //       onTap: () async {
        //         TodoDbProvider provider = TodoDbProvider();
        //         provider.getTodos(null).then((value) {
        //           print(value);
        //         });
        //         // Todo todo = Todo();
        //         // todo.id = DateTime.now().millisecondsSinceEpoch;
        //         // todo.addTime = "2020-01-20 09:45:56";
        //         // todo.lastTime = "2020-01-20 09:45:56";
        //         // todo.content = "第一条记录";
        //         // todo.status = 0;
        //         // provider.insert(todo);
        //       },
        //       child: Text("点我点我点我"),
        //     ),
        //   ),
        // ),
        TodoListPage(),
        // Container(
        //   color: Colors.purple,
        //   child: Center(
        //     child: Text(
        //       '第3页oo',
        //       style: TextStyle(color: Colors.black, fontSize: 20.0),
        //     ),
        //   ),
        // )
      ],
    );
  }
}
