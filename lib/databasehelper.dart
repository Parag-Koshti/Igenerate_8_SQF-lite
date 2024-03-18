import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'my_database.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    await db.execute(
        '''CREATE TABLE IF NOT EXISTS item(id INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT,
    contact TEXT)''');
  }

  static Future<int> insertItem(String name, String contact) async {
    final db = await _openDatabase();
    final data = {
      'name': name,
      'contact': contact,
    };
    return await db.insert('item', data);
  }

  static Future<List<Map<String, dynamic>>> getData() async {
    final db = await _openDatabase();
    return await db.query('item');
  }

  static Future<int> deleteData(int id) async {
    final db = await _openDatabase();
    return await db.delete('item', where: 'id = ?', whereArgs: [id]);
  }

  static Future<Map<String, dynamic>?> getSingleData(int id) async {
    final db = await _openDatabase();
    List<Map<String, dynamic>> result =
        await db.query('item', where: 'id = ?', whereArgs: [id], limit: 1);
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> updateData(int id, Map<String, dynamic> data) async {
    final db = await _openDatabase();
    return await db.update('item', data, where: 'id = ?', whereArgs: [id]);
  }
}
