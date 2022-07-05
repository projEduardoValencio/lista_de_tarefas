import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lista_de_tarefas/pages/todo_list_page.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool darkThemeOn = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: darkThemeOn ? ThemeData.dark() : null,
      debugShowCheckedModeBanner: false,
      home: TodoListPage(
        change: change,
        dark: darkThemeOn,
      ),
      // theme: ThemeData.dark(),
    );
  }

  change() {
    print("Dark");
    setState(() {
      if (darkThemeOn) {
        darkThemeOn = false;
      } else {
        darkThemeOn = true;
      }
    });
  }
}
