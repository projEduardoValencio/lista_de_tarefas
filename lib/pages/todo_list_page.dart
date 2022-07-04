// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lista_de_tarefas/models/todo_model.dart';
import 'package:lista_de_tarefas/widgets/todoListItem.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController _todoController = TextEditingController();

  List<Todo> todos = [];

  bool check = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      "To Do",
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                    ),
                    Icon(Icons.check_box),
                  ],
                ),
                hSpace(),
                rowAddTask(),
                hSpace(),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      for (Todo todo in todos)
                        TodoListItem(
                          todo: todo,
                        ),
                    ],
                  ),
                ),
                hSpace(),
                baseRow(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  SizedBox hSpace() {
    return SizedBox(
      height: 16,
    );
  }

  Row baseRow() {
    return Row(
      children: [
        Expanded(
          child: Text("${todos.length} tasks"),
        ),
        ElevatedButton(
          onPressed: () {},
          child: Text("Clean all"),
        ),
      ],
    );
  }

  Row rowAddTask() {
    return Row(
      // ignore: prefer_const_literals_to_create_immutables
      children: [
        Expanded(
          child: TextField(
            onSubmitted: (value) => addTodo(),
            controller: _todoController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Add a task",
              hintText: 'Workout',
            ),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        SizedBox(
          height: 52,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Colors.lightBlue,
            ),
            onPressed: addTodo,
            child: Icon(Icons.add),
          ),
        ),
      ],
    );
  }

  addTodo() {
    //Coletar o texto no campo
    String title = _todoController.text;
    //armazenar o texto na lista
    setState(() {
      Todo newTodo = Todo(title: title, date: DateTime.now());
      todos.add(newTodo);
    });
    //limpando o campo
    _todoController.clear();
  }
}
