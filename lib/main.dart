import 'package:flutter/material.dart';
import 'package:shopping/helpers/dbhelper.dart';

import 'models/list_items.dart';
import 'models/shopping_list.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dbHelper = DbHelper();
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      debugShowCheckedModeBanner: false,
      title: 'Shopping List',
      home: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text('Shopping List'),
          ),
        ),
        body: const Shopping(),
      ),
    );
  }
}

class Shopping extends StatefulWidget {
  const Shopping({super.key});

  @override
  State<Shopping> createState() => _ShoppingState();
}

class _ShoppingState extends State<Shopping> {
  DbHelper helper = DbHelper();

  Future showData() async {
    await helper.openDb();
    ShoppingList drinks = ShoppingList(name: 'drinks', priority: 4);
    bool inserted = await helper.insertList(drinks);
    print("Inserted drinks list");
    final cola = ListItem(
      idList: 1,
      name: 'Coca-Cola',
      quantity: 'ONLY 1',
      note: 'My sister only drinks cola -_-',
    );
    inserted = await helper.insertItem(cola);
    print("Inserted cola item");
  }

  @override
  Widget build(BuildContext context) {
    showData();
    helper.getLists();
    return Container();
  }
}
