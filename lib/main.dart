import 'package:flutter/material.dart';
import 'package:shopping/helpers/dbhelper.dart';
import 'package:shopping/ui/items_screen.dart';

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
  List<ShoppingList>? shoppingList;

  Future showData() async {
    await helper.openDb();
    if (shoppingList != null) return;
    shoppingList = await helper.getLists();
    setState(() {
      shoppingList = shoppingList;
    });
  }

  @override
  Widget build(BuildContext context) {
    showData();
    return ListView.builder(
      itemCount: shoppingList?.length ?? 0,
      itemBuilder: (context, index) {
        return ListTile(
            leading: CircleAvatar(
              child: Text(shoppingList![index].priority.toString()),
            ),
            title: Text(shoppingList![index].name),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.edit),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ItemsScreen(shoppingList![index]),
                ),
              );
            });
      },
    );
  }
}
