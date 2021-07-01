import 'package:flutter_test/flutter_test.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/providers/todo_provider.dart';

///
/// Description:
/// Author: ArcherHan
/// Date: 2021-07-01 09:33:48
/// LastEditors: ArcherHan
/// LastEditTime: 2021-07-01 09:35:17
///
void main() {
  group('', () {
    TodoProvider _todoProvider = TodoProvider();
    test("加载本地数据", () {
      _todoProvider.fetchData();
      expect(_todoProvider.todoList, _todoProvider.todoList.length >= 0);
      expect(_todoProvider.doneList, _todoProvider.doneList.length >= 0);
    });
    test('测试新增Todo功能', () {
      var len = _todoProvider.todoList.length;
      Todo todo = Todo();
      todo.id = DateTime.now().millisecondsSinceEpoch;
      todo.addTime = "2020-01-20 09:45:56";
      todo.lastTime = "2020-01-20 09:45:56";
      todo.content = "第一条记录";
      todo.status = 0;
      _todoProvider.insertTodo(todo);
      expect(_todoProvider.todoList.length, len + 1);
    });
    test('完成Todo', () {
      var todoLen = _todoProvider.todoList.length;
      var doneLen = _todoProvider.doneList.length;

      if (_todoProvider.todoList.length > 0) {
        var myTodo = _todoProvider.todoList
            .firstWhere((element) => element.content == "第一条记录", orElse: null);
        if (myTodo != null) {
          myTodo.status = myTodo.status == 0 ? 1 : 0;
          myTodo.lastTime = DateTime.now().toString().split(".").first;
          _todoProvider.updateTodo(myTodo);
        }
        expect(_todoProvider.todoList.length, todoLen - 1);
        expect(_todoProvider.doneList.length, doneLen + 1);
      }
    });
    test('删除Todo', () {
      var todoLen = _todoProvider.todoList.length;

      var myTodo = _todoProvider.todoList
          .firstWhere((element) => element.content == "第一条记录", orElse: null);
      if (myTodo != null) {
        _todoProvider.deleteTodo(myTodo);
      }
      expect(_todoProvider.todoList.length, todoLen - 1);
    });
  });
}
