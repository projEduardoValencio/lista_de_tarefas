// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lista_de_tarefas/models/todo_model.dart';
import 'package:lista_de_tarefas/repositories/todo_repository.dart';
import 'package:lista_de_tarefas/widgets/todoListItem.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    todoRepository.getTodoList().then((value) {
      setState(() {
        todos = value;
      });
    });
  }

  final TextEditingController _todoController = TextEditingController();

  final TodoRepository todoRepository = TodoRepository();

  List<Todo> todos = [];

  //Todos List Save
  List<Todo>? deletedListTodos;

  //Todo Uni Save
  Todo? deletedTodo;
  int? deletedTodoPos;

  String? errorText;

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
                          onDelete: onDelete,
                          onCheck: onCheck,
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
          onPressed: confirmationAlert,
          child: Text("Clean all"),
        ),
      ],
    );
  }

  confirmationAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Delete All Todos?"),
        content: Text("Are you sure you want to delete alll todos?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              "Delete",
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () {
              Navigator.pop(context);
              clearAllTodos();
            },
          ),
        ],
      ),
    );
  }

  clearAllTodos() {
    // MUITO IMPORTANTE
    // deletedListTodos = todos NÃO IRA FUNCIONAR pois no momento que limparmos todos ele ira limpar deleteListTodos por ter recebido uma referencia

    deletedListTodos = [...todos];
    print(deletedListTodos);
    setState(() {
      todos.clear();
      todoRepository.saveTodoList(todos);
    });
    print(deletedListTodos);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("All Todos are deleted"),
        action: SnackBarAction(
          label: "Undo",
          textColor: Colors.red,
          onPressed: () {
            setState(() {
              todos = deletedListTodos!;
              todoRepository.saveTodoList(todos);
            });
          },
        ),
      ),
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
              errorText: errorText,
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
    if (_todoController.text.isEmpty) {
      setState(() {
        errorText = "This field is empty";
      });
      return;
    }
    errorText = null;

    //Coletar o texto no campo
    String title = _todoController.text;
    //armazenar o texto na lista
    setState(() {
      Todo newTodo = Todo(title: title, date: DateTime.now());
      todos.add(newTodo);
      todoRepository.saveTodoList(todos);
    });
    //limpando o campo
    _todoController.clear();
  }

  void onDelete(Todo todo) {
    //Salvando todo
    deletedTodo = todo;
    deletedTodoPos = todos.indexOf(todo);

    setState(() {
      todos.remove(todo);
      todoRepository.saveTodoList(todos);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Todo: ${todo.title} removed"),
        action: SnackBarAction(
          label: "Undo",
          textColor: Colors.red,
          onPressed: () {
            setState(() {
              todos.insert(deletedTodoPos!, deletedTodo!);
              todoRepository.saveTodoList(todos);
            });
          },
        ),
      ),
    );
  }

  void onCheck(Todo todo, bool check) {
    int positionTodo = todos.indexOf(todo);
    setState(() {
      todos[positionTodo] =
          Todo(title: todo.title, date: todo.date, check: check);
      todoRepository.saveTodoList(todos);
    });
    print(todos[positionTodo].check);
  }
}
