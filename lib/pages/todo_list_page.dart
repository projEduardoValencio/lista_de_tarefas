// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final TextEditingController _todoController = TextEditingController();

  List<String> todos = [];

  bool check = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
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
                    for (String todo in todos)
                      ListTile(
                        title: Text("$todo"),
                        subtitle: Text("04/07/2022"),
                        leading: Checkbox(
                          onChanged: ((bool? value) {
                            setState(() {
                              check = value!;
                            });
                          }),
                          value: check,
                        ),
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
          child: Text("0 tasks"),
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
    String todo = _todoController.text;
    //armazenar o texto na lista
    todos.add(todo);

    setState(() {});
  }
}
