// ignore_for_file: unused_import, prefer_adjacent_string_concatenation, avoid_print, unnecessary_this, unused_field

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import 'package:k3519036_project_sql/models/shopping_list.dart';
import 'package:k3519036_project_sql/models/list_items.dart';

class DbHelper {
  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() => _dbHelper;

  final int version = 1;
  Database? db;

  Future<Database?> openDb() async {
    // ignore: prefer_conditional_assignment
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'shopping.db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE lists(id INTEGER PRIMARY KEY,name TEXT, priority INTEGER)');
        database.execute(
            'CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER,name TEXT, quantity TEXT, note TEXT, ' +
                'FOREIGN KEY(idList) REFERENCES lists(id))');
      }, version: version);
      return db;
    }
  }

  Future<int> insertList(ShoppingList list) async {
    int id = await this.db!.insert(
          'lists',
          list.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<int> insertItem(ListItem item) async {
    int id = await this.db!.insert(
          'items',
          item.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
    return id;
  }

  Future<List<ShoppingList>> getLists() async {
    final List<Map<String, dynamic>> maps = await db!.query('lists');
    return List.generate(
        maps.length,
        (i) => ShoppingList(
              maps[i]['id'],
              maps[i]['name'],
              maps[i]['priority'],
            ));
  }

  Future<List<ListItem>> getItems(int idList) async {
    final List<Map<String, dynamic>> maps = await db!.query(
      'items',
      where: 'idList = ?',
      whereArgs: [idList],
    );

    return List.generate(
        maps.length,
        (i) => ListItem(
              maps[i]['id'],
              maps[i]['idList'],
              maps[i]['name'],
              maps[i]['quantity'],
              maps[i]['note'],
            ));
  }

  Future<int> deleteList(ShoppingList list) async {
    int result = await db!.delete('items', where: 'idList = ?', whereArgs: [list.id]);
    result = await db!.delete('lists', where: 'id = ?', whereArgs: [list.id]);

    return result;
  }

  Future<int> deleteItem(ListItem item) async {
    int result = await db!.delete('items', where: 'id = ?', whereArgs: [item.id]);

    return result;
  }

  // Testing
  Future testDb() async {
    db = await openDb();
    await db!.execute('INSERT INTO lists VALUES (0, "Fruit", 2)');
    await db!.execute(
        'INSERT INTO items VALUES (0, 0, "Apples", "2 Kg", "Better if they are green")');
    List lists = await db!.rawQuery("select * from lists");
    List items = await db!.rawQuery("select * from items");
    print(lists[0].toString());
    print(items[0].toString());
  }
}
