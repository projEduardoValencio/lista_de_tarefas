import 'dart:convert';
import 'dart:io';

import 'package:lista_de_tarefas/models/todo_model.dart';
import 'package:path_provider/path_provider.dart';

class ListTodos {
  List<Todo>? todos = [];

  ListTodos({this.todos});

  Future<File> _getFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    String data = jsonEncode(todos);

    final file = await _getFile();
    return file.writeAsString(data);
  }

  Future<String?> _readData() async {
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
