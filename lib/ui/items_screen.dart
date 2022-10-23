import 'package:flutter/material.dart';
import 'package:shopping/ui/list_item_dialog.dart';
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
  late ListItemDialog dialog;
  @override
  void initState() {
    dbHelper = DbHelper();
    dialog = ListItemDialog();
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

  void updateItems() async {
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
          return Dismissible(
            key: Key(listItems![index].name),
            onDismissed: (direction) {
              String strName = listItems![index].name;
              dbHelper!.deleteItem(listItems![index]);
              setState(() {
                listItems!.removeAt(index);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text("$strName deleted!"),
                ),
              );
            },
            child: ListTile(
              title: Text(listItems![index].name),
              subtitle: Text(
                  'Quantity: ${listItems![index].quantity} - Note: ${listItems![index].note}'),
              onTap: () async {
                await showDialog(
                  context: context,
                  builder: (context) =>
                      dialog.buildDialog(context, listItems![index], false),
                );
                updateItems();
              },
              trailing: IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) =>
                        dialog.buildDialog(context, listItems![index], false),
                  );
                  updateItems();
                },
                icon: const Icon(
                  Icons.edit,
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showDialog(
            context: context,
            builder: (context) => dialog.buildDialog(
              context,
              ListItem(
                name: '',
                note: '',
                idList: widget.shoppingList.id!,
                quantity: '',
              ),
              true,
            ),
          );
          updateItems();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
