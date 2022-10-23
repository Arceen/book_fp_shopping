import 'package:flutter/material.dart';

import '../helpers/dbhelper.dart';
import '../models/list_items.dart';

class ListItemDialog {
  final txtName = TextEditingController();
  final txtNote = TextEditingController();

  final txtQuantity = TextEditingController();

  Widget buildDialog(BuildContext context, ListItem item, bool isNew) {
    DbHelper helper = DbHelper();
    if (!isNew) {
      txtName.text = item.name;
      txtQuantity.text = item.quantity;
      txtNote.text = item.note;
    } else {
      txtName.text = '';
      txtQuantity.text = '';
      txtNote.text = '';
    }
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      title: Text(
        isNew ? 'New Item' : 'Edit Item',
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: InputDecoration(
                hintText: 'Item Name',
              ),
            ),
            TextField(
              controller: txtQuantity,
              decoration: InputDecoration(
                hintText: 'Quantity',
              ),
            ),
            TextField(
              controller: txtNote,
              decoration: InputDecoration(
                hintText: 'Note',
              ),
            ),
            ElevatedButton(
              onPressed: () {
                item.name = txtName.text;
                item.quantity = txtQuantity.text;
                item.note = txtNote.text;
                helper.insertItem(item);
                Navigator.pop(context);
              },
              child: Text('${isNew ? 'Save' : 'Update'} Item'),
            ),
          ],
        ),
      ),
    );
  }
}
