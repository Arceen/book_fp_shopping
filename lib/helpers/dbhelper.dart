import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';

class DbHelper {
  final String LIST_TABLE = 'lists';
  final String ITEM_TABLE = 'items';
  final String dbCreateListTable = """
    CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)
""";
  final String dbCreateItemsTable = """
    CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER, name TEXT, quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES lists(id))
""";

  final int version = 1;
  Database? db;
  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();
  factory DbHelper() {
    return _dbHelper;
  }

  Future deleteList(ShoppingList list) async {
    db = await openDb();
    await db!.delete(ITEM_TABLE, where: "idList = ?", whereArgs: [list.id]);
    await db!.delete(LIST_TABLE, where: "id = ?", whereArgs: [list.id]);
  }

  Future deleteItem(ListItem item) async {
    db = await openDb();
    await db!.delete(ITEM_TABLE, where: "id = ?", whereArgs: [item.id]);
  }

  Future<Database> openDb() async =>
      db ??
      await openDatabase(join(await getDatabasesPath(), 'shopping.db'),
          onCreate: (db, version) {
        db.execute(dbCreateListTable);
        db.execute(dbCreateItemsTable);
      }, version: version);

  Future emptyTestDb() async {
    db = await openDb();
    await db!.rawDelete('delete from $ITEM_TABLE');
    await db!.rawDelete('delete from $LIST_TABLE');
  }

  Future<bool> insertList(ShoppingList list) async {
    db = await openDb();
    return await db!.insert(LIST_TABLE, list.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace) !=
        0;
  }

  Future<bool> insertItem(ListItem item) async {
    db = await openDb();
    return await db!.insert(ITEM_TABLE, item.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace) !=
        0;
  }

  Future testDb() async {
    db = await openDb();
    final fruits = ShoppingList(name: 'fruits', priority: 2);
    final papers = ShoppingList(name: 'papers', priority: 3);
    final drinks = ShoppingList(name: 'drinks', priority: 4);

    print(await insertList(fruits));
    print(await insertList(papers));
    print(await insertList(drinks));

    final apple = ListItem(
      idList: 1,
      name: 'Apple',
      quantity: 'A dozen',
      note: 'For apple pie',
    );
    final banana = ListItem(
      idList: 1,
      name: 'Banana',
      quantity: 'Half a dozen',
      note: 'For banana smoothie',
    );

    final a4 = ListItem(
      idList: 1,
      name: 'Paper',
      quantity: 'Half a dozen',
      note: 'Printer Needs it',
    );

    final cola = ListItem(
      idList: 1,
      name: 'Coca-Cola',
      quantity: 'ONLY 1',
      note: 'My sister only drinks cola -_-',
    );

    print(await insertItem(apple));
    print(await insertItem(banana));
    print(await insertItem(a4));
    print(await insertItem(cola));

    List lists = await db!.rawQuery('select * from lists');
    List items = await db!.rawQuery('select * from items');
    for (final item in items) {
      print(item);
    }
    for (final list in lists) {
      print(list);
    }
  }

  Future<List<ShoppingList>> getLists() async {
    db = await openDb();
    List<Map<String, dynamic>> maps = await db!.query(LIST_TABLE);
    final myList = maps.toList(growable: false).map((list) => ShoppingList(
        id: list['id'], name: list['name'], priority: list['priority']));
    print(maps);
    return myList.toList();
  }

  Future<ShoppingList> getSingleList(int id) async {
    db = await openDb();
    List<Map> maps =
        await db!.query(LIST_TABLE, where: 'id = ?', whereArgs: [id]);
    final myList = maps.toList(growable: false).map((list) => ShoppingList(
        id: list['id'], name: list['name'], priority: list['priority']));
    return myList.toList()[0];
  }

  Future<List<ListItem>> getListItem(int id) async {
    db = await openDb();
    List<Map<String, dynamic>> maps2 = await db!.query(ITEM_TABLE);
    print(maps2);
    List<Map<String, dynamic>> maps =
        await db!.query(ITEM_TABLE, where: 'idList = ?', whereArgs: [id]);
    final myList = maps.toList(growable: false).map(
          (list) => ListItem(
              id: list['id'],
              idList: list['idList'],
              name: list['name'],
              quantity: list['quantity'],
              note: list['note']),
        );
    print(myList);
    return myList.toList();
  }
}
