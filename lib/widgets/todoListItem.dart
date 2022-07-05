// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lista_de_tarefas/models/todo_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import '../repositories/todo_repository.dart';

class TodoListItem extends StatefulWidget {
  const TodoListItem({
    Key? key,
    required this.todo,
    required this.onDelete,
    required this.onCheck,
  }) : super(key: key);

  final Todo todo;
  final Function(Todo) onDelete;
  final Function(Todo, bool) onCheck;

  @override
  State<TodoListItem> createState() => _TodoListItemState();
}

class _TodoListItemState extends State<TodoListItem> {
  final TodoRepository todoRepository = TodoRepository();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Slidable(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey[300],
          ),
          height: 60,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            child: Row(
              children: [
                SizedBox(
                  width: 2,
                ),
                //CHECKBOX
                Checkbox(
                    value: widget.todo.check as bool,
                    onChanged: (bool? value) {
                      widget.onCheck(widget.todo, value!);
                    }),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //TODO TITLE
                      Text(
                        "${widget.todo.title}",
                        style: !widget.todo.check
                            ? TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16)
                            : TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough),
                      ),
                      // SizedBox(
                      //   height: 1,
                      // ),
                      //TODO DATE
                      Text(
                        DateFormat('dd/MMM/yyyy - HH:mm')
                            .format(widget.todo.date),
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        endActionPane: ActionPane(
          motion: DrawerMotion(),
          extentRatio: 0.20,
          children: [
            // A SlidableAction can have an icon and/or a label.
            SlidableAction(
              onPressed: (_) {
                widget.onDelete(widget.todo);
              },
              backgroundColor: Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
            // SlidableAction(
            //   onPressed: null,
            //   backgroundColor: Color(0xFF21B7CA),
            //   foregroundColor: Colors.white,
            //   icon: Icons.share,
            //   label: 'Share',
            // ),
          ],
        ),
      ),
    );
  }
}
