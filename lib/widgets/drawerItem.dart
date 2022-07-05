import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class DrawerItem extends StatefulWidget {
  DrawerItem({Key? key, required this.change}) : super(key: key);
  Function change;

  @override
  State<DrawerItem> createState() => _DrawerItemState();
}

class _DrawerItemState extends State<DrawerItem> {
  bool onDark = false;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Expanded(
          child: ListView(
            shrinkWrap: true,
            children: [
              Column(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "Configuration",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Dark Theme"),
                      Switch(
                          value: onDark,
                          onChanged: (bool? value) {
                            setState(() {
                              onDark = value!;
                              widget.change();
                            });
                          }),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
