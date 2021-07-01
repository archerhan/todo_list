import 'package:todo/db/todo_db_provider.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/providers/base_provider.dart';

///
/// Description:
/// Author: ArcherHan
/// Date: 2021-06-30 23:01:57
/// LastEditors: ArcherHan
/// LastEditTime: 2021-06-30 23:01:57
///

class TodoProvider extends BaseProvider {
  TodoDbProvider _todoDbProvider = TodoDbProvider();

  List<Todo> _todoList = [];
  List<Todo> _doneList = [];

  List<Todo> get todoList => _todoList;
  List<Todo> get doneList => _doneList;

  /// 获取本地存储的全部数据，并分组
  Future fetchData() async {
    var dataList = await _todoDbProvider.getTodos(null);
    _todoList.clear();
    _doneList.clear();
    if (dataList.length > 0) {
      for (Todo item in dataList.reversed) {
        if (item.status == 0) {
          _todoList.add(item);
        } else {
          _doneList.add(item);
        }
      }
      notifyListeners();
    }
  }

  /// 插入todo
  Future insertTodo(Todo todo) async {
    await _todoDbProvider.insert(todo);
    await fetchData();
    notifyListeners();
  }

  /// 更新todo
  Future updateTodo(Todo todo) async {
    await _todoDbProvider.update(todo);
    await fetchData();
    notifyListeners();
  }

  /// 删除todo
  Future deleteTodo(Todo todo) async {
    await _todoDbProvider.deleteTodo(todo.id!);
    await fetchData();
    notifyListeners();
  }
}
