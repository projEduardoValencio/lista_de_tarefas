// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:lista_de_tarefas/models/todo_model.dart';
import 'package:lista_de_tarefas/repositories/todo_repository.dart';
import 'package:lista_de_tarefas/widgets/drawerItem.dart';
import 'package:lista_de_tarefas/widgets/todoListItem.dart';

class TodoListPage extends StatefulWidget {
  TodoListPage({Key? key, required this.change, required this.dark})
      : super(key: key);

  Function change;
  bool dark;

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
        drawer: DrawerItem(change: widget.change),
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "To Do",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(Icons.check_box),
              SizedBox(
                width: 40.0,
              ),
            ],
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                hSpace(),
                rowAddTask(),
                hSpace(),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: _refresh,
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        for (Todo todo in todos)
                          TodoListItem(
                            todo: todo,
                            onDelete: onDelete,
                            onCheck: onCheck,
                            dark: widget.dark,
                          ),
                      ],
                    ),
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

  Future<void> _refresh() async {
// await Future.delayed(
    //   Duration(seconds: 1),
    // );

    //Sorteando pela data
    setState(() {
      todos.sort(
        (a, b) {
          return a.date.compareTo(b.date);
        },
      );

      //Metodo para inserir um novo item a cima na lista de TO DOs
      // List<Todo> nTodos = todos.reversed.toList();
      // todos = [...nTodos];

      //Sorteando os que ja foram concluidos
      todos.sort((a, b) {
        if (a.check && !b.check)
          return 1;
        else if (!a.check && b.check)
          return -1;
        else
          return 0;
      });
      todoRepository.saveTodoList(todos);
    });
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
          style: ElevatedButton.styleFrom(
            primary: widget.dark ? Colors.cyanAccent : null,
          ),
          child: Text(
            "Clean all",
            style: TextStyle(
              color: widget.dark ? Colors.grey[700] : null,
            ),
          ),
        ),
      ],
    );
  }

  _deleteJustChecked() {
    todos.removeWhere((e) => e.check);
    setState(() {
      todoRepository.saveTodoList(todos);
    });
  }

  confirmationAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text("Delete All To Do?"),
        content: Text("Are you sure you want to delete alll To Do?"),
        actions: [
          TextButton(
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          TextButton(
            child: Text(
              "Just Checkeds",
              style: TextStyle(color: Colors.amber),
            ),
            onPressed: () {
              Navigator.pop(context);
              _deleteJustChecked();
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
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
              primary: widget.dark ? Colors.cyanAccent : null,
              shape: CircleBorder(),
            ),
            onPressed: addTodo,
            child: Icon(
              Icons.add,
              color: widget.dark ? Colors.grey[700] : null,
            ),
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
      _refresh();
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
        content: Text("To do: ${todo.title} removed"),
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
