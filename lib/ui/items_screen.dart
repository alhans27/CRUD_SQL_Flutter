// ignore_for_file: unused_import, unnecessary_this, no_logic_in_create_state, must_be_immutable, prefer_const_constructors, unnecessary_null_comparison, annotate_overrides, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:k3519036_project_sql/ui/list_item_dialog.dart';
import '../models/list_items.dart';
import '../models/shopping_list.dart';
import '../util/dbhelper.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;
  const ItemsScreen(this.shoppingList, {Key? key}) : super(key: key);

  @override
  _ItemsScreenState createState() => _ItemsScreenState(this.shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  final ShoppingList shoppingList;
  _ItemsScreenState(this.shoppingList);
  DbHelper? helper;
  List<ListItem> items = [];
  ListItemDialog? itemDialog;

  void initState() {
    itemDialog = ListItemDialog();
    super.initState();
  }

  Future showData(int idList) async {
    await helper!.openDb();
    items = await helper!.getItems(idList);
    setState(() {
      items = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    ListItemDialog itemDialog = ListItemDialog();
    helper = DbHelper();
    showData(this.shoppingList.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(shoppingList.name),
      ),
      body: ListView.builder(
          itemCount: (items != null) ? items.length : 0,
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(items[index].name),
              onDismissed: (direction) {
                String strName = items[index].name;
                helper!.deleteItem(items[index]);

                setState(() {
                  items.removeAt(index);
                });
                Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text('$strName deleted')),
                );
              },
              child: ListTile(
                title: Text(items[index].name),
                subtitle: Text(
                    'Quantity: ${items[index].quantity} - Note: ${items[index].note}'),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) =>
                          itemDialog.buildAlert(context, items[index], false));
                },
                trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => itemDialog
                            .buildAlert(context, items[index], false));
                  },
                  icon: Icon(Icons.edit),
                ),
              ),
            );
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) => itemDialog.buildAlert(
                context, ListItem(0, shoppingList.id, '', '', ''), true),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
