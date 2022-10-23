import 'package:flutter/material.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';
import '../helpers/dbhelper.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  const ItemsScreen(this.shoppingList, {super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  List<ListItem>? listItems;
  DbHelper? dbHelper;
  @override
  void initState() {
    dbHelper = DbHelper();
    initializeItems();
    super.initState();
  }

  void initializeItems() async {
    int id = widget.shoppingList.id!;
    final temp = await dbHelper!.getListItem(id);
    setState(() {
      listItems = temp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Item'),
      ),
      body: ListView.builder(
        itemCount: listItems?.length ?? 0,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Center(child: Text(listItems![index].quantity)),
            title: Text(listItems![index].name),
            subtitle: Text(listItems![index].note),
          );
        },
      ),
    );
  }
}
