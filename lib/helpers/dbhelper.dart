import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final String dbCreateListTable = """
    CREATE TABLE lists(id INTEGER PRIMARY KEY, name TEXT, priority INTEGER)
""";
  final String dbCreateItemsTable = """
    CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER, name TEXT, quantity TEXT, note TEXT, FOREIGN KEY(idList) REFERENCES lists(id))
""";
  final int version = 1;
  Database? db;

  Future<Database> openDb() async {
    db = db ??
        await openDatabase(join(await getDatabasesPath(), 'shopping.db'),
            onCreate: (db, version) {
          db.execute(dbCreateListTable);
          db.execute(dbCreateItemsTable);
        }, version: version);

    return db!;
  }

  Future emptyTestDb() async {
    db = await openDb();
    await db!.rawDelete('delete from items');
    await db!.rawDelete('delete from lists');
  }

  Future testDb() async {
    db = await openDb();
    await db!.execute("INSERT INTO lists VALUES (NULL, 'Fruit', 2)");
    await db!.execute(
        "INSERT INTO items VALUES (NULL, 0, 'Apples', '2 Kg', 'Better if they are green')");

    List lists = await db!.rawQuery('select * from lists');
    List items = await db!.rawQuery('select * from items');
    for (final item in items) {
      print(item);
    }
    for (final list in lists) {
      print(list);
    }
  }
}
