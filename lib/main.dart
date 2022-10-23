import 'package:flutter/material.dart';
import 'package:shopping/helpers/dbhelper.dart';
import 'package:shopping/ui/items_screen.dart';
import './ui/shopping_list_dialog.dart';

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
      home: const Shopping(),
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
  List<ShoppingList>? shoppingList;
  late ShoppingListDialog dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    showData();
    super.initState();
  }

  Future showData() async {
    await helper.openDb();
    shoppingList = await helper.getLists();
    setState(() {
      shoppingList = shoppingList;
    });
  }

  Future updateList() async {
    await helper.openDb();
    shoppingList = await helper.getLists();
    setState(() {
      shoppingList = shoppingList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Shopping List'),
        ),
      ),
      body: ListView.builder(
        itemCount: shoppingList?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              child: Text(shoppingList![index].priority.toString()),
            ),
            title: Text(shoppingList![index].name),
            trailing: IconButton(
              onPressed: () async {
                await showDialog(
                  context: context,
                  builder: (context) =>
                      dialog.buildDialog(context, shoppingList![index], false),
                );
                updateList();
              },
              icon: const Icon(Icons.edit),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemsScreen(shoppingList![index]),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => dialog.buildDialog(
              context,
              ShoppingList(name: '', priority: 0),
              true,
            ),
          );
          updateList();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
