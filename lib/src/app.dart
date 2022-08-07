import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/database_handler.dart';
import 'package:todo/screens/drawer_navigation.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/todo_model.dart';
import 'package:todo/todo_repo.dart';

import 'detail_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    getFromTodo();
  }

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController editTitleController = TextEditingController();
  TextEditingController editDescriptionController = TextEditingController();
  late List<Map<String, dynamic>> todoList = [];

  Database? _database;
  Future<Database?> openDB() async {
    _database = await DatabaseHandler().openDB();
    return _database;
  }

  Future<void> insertDb() async {
    _database = await openDB();
    TodoRepo todoRepo = TodoRepo();
    // todoRepo.createTable(_database);

    TOdoModel todoModel = TOdoModel(
        titleController.text.toString(), descriptionController.text.toString());
    int? result = await _database?.insert('Todo', todoModel.toMap());
    print("Result: " + result.toString());
    await _database?.close();
  }

  Future<void> updateDb(id) async {
    _database = await openDB();
    TodoRepo todoRepo = TodoRepo();
    // todoRepo.createTable(_database);

    TOdoModel todoModel = TOdoModel(editTitleController.text.toString(),
        editDescriptionController.text.toString());

    await _database
        ?.rawUpdate('UPDATE Todo SET title = ?, description = ? WHERE id = ?', [
      editTitleController.text.toString(),
      editDescriptionController.text.toString(),
      id
    ]);

    await _database?.close();
  }

  Future<void> deleteDb(id) async {
    _database = await openDB();
    // TodoRepo todoRepo = TodoRepo();

    await _database?.rawDelete('DELETE FROM Todo  WHERE id = ?', [id]);
    await _database?.close();
    print('data deleted succesdfully');
  }

  Future<void> getFromTodo() async {
    _database = await openDB();
    TodoRepo todoRepo = TodoRepo();
    List<Map<String, dynamic>> _todoList = await todoRepo.getTodo(_database);
    setState(() {
      todoList = _todoList;
    });
    await _database?.close();
  }

  late String title, description;

  String validatePassword(String value) {
    if (!(value.length > 5) && value.isNotEmpty) {
      return "Password should contain more than 5 characters";
    }
    return " ";
  }

  _showAddDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                onPressed: () {
                  title = titleController.text;
                  description = descriptionController.text;
                  insertDb();
                  setState(() {
                    getFromTodo();
                  });
                  Navigator.pop(context);
                  setState(() {});
                },
                child: const Text('Save'),
              )
            ],
            title: const Text('Add Todo'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: titleController,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                    ),
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  )
                ],
              ),
            ),
          );
        });
  }

  _editFormDialog(BuildContext context, todo) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                onPressed: () {
                  updateDb(todo['id']);
                  getFromTodo();
                  Navigator.pop(context);
                },
                child: const Text('Update'),
              )
            ],
            title: const Text('Edit Todo'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: editTitleController,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  TextField(
                    controller: editDescriptionController,
                    decoration: const InputDecoration(labelText: 'Description'),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Todods"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add todo',
            onPressed: () {
              _showAddDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todoList.length,
        itemBuilder: (BuildContext context, index) {
          return Card(
            child: ListTile(
              title: Text(todoList[index]["title"].toString()),
              subtitle: Text(todoList[index]["description"].toString()),
              onTap: () {
                editTitleController.text = todoList[index]['title'].toString();
                editDescriptionController.text =
                    todoList[index]['description'].toString();
                _editFormDialog(context, todoList[index]);
              },
              trailing: IconButton(
                  onPressed: () {
                    deleteDb(todoList[index]['id']);
                    setState(() {
                      getFromTodo();
                    });
                  },
                  icon: Icon(Icons.delete)),
            ),
          );
        },
        shrinkWrap: true,
        padding: const EdgeInsets.all(5),
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
