import 'package:flutter/material.dart';
import 'dart:convert';

class MemberDialog extends StatefulWidget {
  final List<String> keys;
  final List<dynamic> obj;
  final int i;
  const MemberDialog(
      {super.key, required this.keys, required this.obj, required this.i});

  @override
  State<MemberDialog> createState() => _MemberDialogState();
}

class _MemberDialogState extends State<MemberDialog> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(child: Icon(Icons.close),onTap: (){Navigator.of(context).pop();},),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                child: ListView(
                  children: List.generate(
                    widget.keys.length,
                    (index) => ListTile(
                      title: index == 0
                          ? Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40)),
                              child: Image.memory(base64Decode(widget
                                  .obj[widget.i][widget.keys[index]]
                                  .toString())))
                          : Text(
                              "${widget.keys[index]} : ${widget.obj[widget.i][widget.keys[index]].toString()}"),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              
              children: [
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll<Color>(Colors.lightBlueAccent),
                  ),
                  child: Text("Edit"),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16,0,0,0),
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.red),
                    ),
                    child: Text("Delete"),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
