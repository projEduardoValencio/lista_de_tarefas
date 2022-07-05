import 'dart:convert';

import 'package:flutter/cupertino.dart';

class Todo {
  String? title;
  DateTime date;
  bool check;

  Todo({
    required this.title,
    required this.date,
    this.check = false,
  });

  Todo.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        date = DateTime.parse(
          json['date'],
        ),
        check = json['check'] as bool;

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'date': date.toIso8601String(),
      'check': check,
    };
  }
}
