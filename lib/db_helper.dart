import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static DbHelper getInstance() => DbHelper._();

  Database? mDb;

  Future<Database> initDB() async {
    if(mDb == null){
      mDb = await openDB();
      return mDb!;
    } else {
      return mDb!;
    }
  }

  Future<Database> openDB() async {
    Directory mDir = await getApplicationDocumentsDirectory();
    String mPath = join(mDir.path, "todoDB.db");
    return await openDatabase(mPath, version: 1, onCreate: (db, version){

      db.execute("Create table todo(t_id integer primary key autoincrement, t_title text, t_desc text, t_isCompleted integer, t_created_at text, t_priority integer)");

    });
  }

  ///Events

  Future<bool> addTodo({required String title, required String desc, int priority=1}) async{
    var db = await initDB();
    int rowsEffected = await db.insert("todo", {
      "t_title": title,
      "t_desc": desc,
      "t_isCompleted": 0,
      "t_created_at": DateTime.now().millisecondsSinceEpoch.toString(),
      "t_priority": priority
    });
    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> fetchAllTodo(int filter ) async {
    var db = await initDB();
    List<Map<String, Object?>> allTodo = [];

    if(filter > 0) {
    allTodo = await db.query(
      "todo", 
      where: "t_isCompleted = ?", 
      whereArgs: [filter == 1 ? 1 : 0], 
      orderBy: "t_created_at DESC");
    } else {
      allTodo = await db.query("todo", orderBy: "t_created_at DESC");
    }
    return allTodo;
  }

  Future<bool> updateTodoCompleted({required int id, required bool isCompleted}) async{
    var db = await initDB();

    int rowsEffected = await db.update("todo", {
      "t_isCompleted": isCompleted ? 1 : 0
    },
    where: "t_id = ?",
    whereArgs: ["$id"]
    );
    return rowsEffected > 0;
  }

}