import 'package:sqflite/sqflite.dart';
import 'package:todo/db/db_provider.dart';
import 'package:todo/models/todo_model.dart';

///
/// Description:
/// Author: ArcherHan
/// Date: 2021-06-30 14:01:14
/// LastEditors: ArcherHan
/// LastEditTime: 2021-06-30 14:01:30
///
class TodoDbProvider extends BaseDbProvider {
  ///表名
  final String name = 'TodoList';

  final String columnId = "id";
  final String columnLastTime = "last_time";
  final String columnAddTime = "add_time";
  final String columnStatus = "status";
  final String columnContent = "content";

  @override
  createTableString() {
    return '''
        create table $name (
        $columnId integer primary key,
        $columnLastTime text not null,
        $columnAddTime text not null,
        $columnStatus integer not null,
        $columnContent text not null)
      ''';
  }

  @override
  tableName() {
    return name;
  }

  ///查询数据库
  Future _getTodoProvider(Database db, int? id) async {
    List<Map<String, dynamic>> maps = [];
    if (id != null) {
      maps = await db.rawQuery("select * from $name where $columnId = $id");
    } else {
      maps = await db.rawQuery("select * from $name");
    }

    return maps;
  }

  Future deleteTodo(int id) async {
    Database db = await getDataBase();
    var userProvider = await _getTodoProvider(db, id);
    if (userProvider != null) {
      ///删除数据
      await db.delete(name, where: "$columnId = ?", whereArgs: [id]);
    }
  }

  ///插入到数据库
  Future insert(Todo model) async {
    Database db = await getDataBase();
    var userProvider = await _getTodoProvider(db, model.id!);
    if (userProvider != null) {
      ///删除数据
      await db.delete(name, where: "$columnId = ?", whereArgs: [model.id]);
    }
    return await db.rawInsert(
        "insert into $name ($columnId,$columnLastTime,$columnAddTime,$columnStatus,$columnContent) values (?,?,?,?,?)",
        [model.id, model.lastTime, model.addTime, model.status, model.content]);
  }

  ///更新数据库
  Future<void> update(Todo model) async {
    Database database = await getDataBase();
    await database.rawUpdate(
        "update $name set $columnLastTime = ?,$columnStatus = ?, $columnContent = ? where $columnId= ?",
        [model.lastTime, model.status, model.content, model.id]);
  }

  ///获取事件数据（全部）
  Future<List<Todo>> getTodos(int? id) async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps = await _getTodoProvider(db, id);
    if (maps.length > 0) {
      List<Todo> list = [];
      for (var item in maps) {
        var model = Todo.fromJson(item);
        list.add(model);
      }
      return list;
    }
    return [];
  }
}
