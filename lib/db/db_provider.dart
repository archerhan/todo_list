import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/db/sql_manager.dart';

///
/// Description:
/// Author: ArcherHan
/// Date: 2021-06-30 14:00:03
/// LastEditors: ArcherHan
/// LastEditTime: 2021-06-30 14:00:20
///
abstract class BaseDbProvider {
  bool isTableExits = false;

  createTableString();

  tableName();

  ///创建表sql语句
  tableBaseString(String sql) {
    return sql;
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  ///super 函数对父类进行初始化
  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExits = await SqlManager.isTableExits(name);
    if (!isTableExits) {
      Database db = await SqlManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  @mustCallSuper
  open() async {
    if (!isTableExits) {
      await prepare(tableName(), createTableString());
    }
    return await SqlManager.getCurrentDatabase();
  }
}
