import 'package:sqflite/sqflite.dart';

class TodoRepo {
  void createTable(Database? db) {
    db?.execute(
        'CREATE TABLE TODO(id INTEGER PRIMARY KEY, title TEXT, description TEXT )');
  }

  Future<List<Map<String, dynamic>>> getTodo(Database? db) async {
    final List<Map<String, dynamic>> maps = await db!.query('Todo');
    return maps;
  }
}
