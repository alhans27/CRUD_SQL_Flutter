// ignore_for_file: unused_import, prefer_const_constructors, unused_local_variable, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:k3519036_project_sql/models/list_items.dart';
import '../util/dbhelper.dart';

class ListItemDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildAlert(BuildContext context, ListItem item, bool isNew) {
    DbHelper helper = DbHelper();
    helper.openDb();

    if (!isNew) {
      txtName.text = item.name;
      txtQuantity.text = item.quantity;
      txtNote.text = item.note;
    }
    return AlertDialog(
      title: Text((isNew) ? 'New Shopping Item' : 'Edit Shopping Item'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            TextField(
              controller: txtName,
              decoration: InputDecoration(hintText: 'Item Name'),
            ),
            TextField(
              controller: txtQuantity,
              decoration:
                  InputDecoration(hintText: 'Quantity'),
            ),
            TextField(
              controller: txtNote,
              decoration:
                  InputDecoration(hintText: 'Note'),
            ),
            ElevatedButton(
              child: Text('Save Item'),
              onPressed: () {
                item.name = txtName.text;
                item.quantity = txtQuantity.text;
                item.note = txtNote.text;
                helper.insertItem(item);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}
