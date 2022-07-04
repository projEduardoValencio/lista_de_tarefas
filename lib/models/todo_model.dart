import 'package:flutter/cupertino.dart';

class Todo {
  String? title;
  DateTime date;
  bool? check = false;

  Todo({
    required this.title,
    required this.date,
    this.check,
  });
}
