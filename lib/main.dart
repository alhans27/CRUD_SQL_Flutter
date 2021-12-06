// ignore_for_file: avoid_print, prefer_const_constructors, unnecessary_null_comparison, unused_import, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:k3519036_project_sql/ui/list_item_dialog.dart';
import 'ui/items_screen.dart';
import 'ui/shopping_list_dialog.dart';
import 'package:k3519036_project_sql/models/list_items.dart';
import 'package:k3519036_project_sql/models/shopping_list.dart';
import 'util/dbhelper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: ShList(),
    );
  }
}

class ShList extends StatefulWidget {
  const ShList({Key? key}) : super(key: key);

  @override
  _ShListState createState() => _ShListState();
}

class _ShListState extends State<ShList> {
  DbHelper helper = DbHelper();
  List<ShoppingList> shoppinglist = [];
  ShoppingListDialog? dialog;

  Future showData() async {
    await helper.openDb();
    // <code> For Testing
    // ShoppingList list = ShoppingList(0, 'Bakery', 2);
    // int listId = await helper.insertList(list);

    // ListItem item = ListItem(0, listId, 'Bread', 'note', '1 kg');
    // int itemId = await helper.insertItem(item);

    // print('List Id: ' + listId.toString());
    // print('Item Id: ' + itemId.toString());

    shoppinglist = await helper.getLists();
    setState(() {
      shoppinglist = shoppinglist;
    });
  }

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ShoppingListDialog dialog = ShoppingListDialog();
    showData();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping List'),
      ),
      body: ListView.builder(
        itemCount: (shoppinglist != null) ? shoppinglist.length : 0,
        itemBuilder: (BuildContext context, int index) {
          return Dismissible(
            key: Key(shoppinglist[index].name),
            onDismissed: (direction) {
              String strName = shoppinglist[index].name;
              helper.deleteList(shoppinglist[index]);

              setState(() {
                shoppinglist.removeAt(index);
              });
              Scaffold.of(context).showSnackBar(SnackBar(content: Text('$strName deleted')));
            },
            child: ListTile(
              title: Text(shoppinglist[index].name.toString()),
              leading: CircleAvatar(
                child: Text(
                  shoppinglist[index].priority.toString(),
                ),
              ),
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) => dialog.buildDialog(
                          context, shoppinglist[index], false));
                },
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ItemsScreen(shoppinglist[index])));
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) =>
                dialog.buildDialog(context, ShoppingList(0, '', 0), true),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.amber,
      ),
    );
  }
}
