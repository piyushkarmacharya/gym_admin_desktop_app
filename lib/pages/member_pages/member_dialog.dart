import 'package:flutter/material.dart';
import 'package:gymmanagementsystem/pages/home_page.dart';
import 'package:gymmanagementsystem/pages/member_pages/member_update.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MemberDialog extends StatefulWidget {
  final List<String> keys;
  final Map<String,dynamic> obj;

  const MemberDialog(
      {super.key, required this.keys, required this.obj});

  @override
  State<MemberDialog> createState() => _MemberDialogState();
}

class _MemberDialogState extends State<MemberDialog> {
  
  Future<void> delete(int mid) async {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final Response = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/Member/delete/$mid"),
    );
    if (Response.statusCode == 200) {
      
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(20),
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(20))),
            backgroundColor: Colors.green,
            margin: EdgeInsets.fromLTRB(
                0, 0, 0.7 * screenWidth, 0.05 * screenHeight),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
            content: Center(child: Text(jsonDecode(Response.body)['message'])),
          ),
        );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) {
            return HomePage();
          },
        ),
      );
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      width:700,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Icon(Icons.close),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
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
                                    .obj[widget.keys[index]]
                                    .toString())))
                            : Row(children: [Text(
                                "${widget.keys[index][0].toUpperCase()}${widget.keys[index].substring(1)} : "),Text(" ${widget.obj[widget.keys[index]].toString()=='0'?'(not given)':widget.obj[widget.keys[index]].toString()}"),],),
                      ),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
      
                  //for editttt
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      showDialog(
                        barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child:MemberUpdate(keys: widget.keys, obj: widget.obj),
                            );
                          });
                    },
                    style: const ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll<Color>(Colors.lightBlueAccent),
                    ),
                    child: Text("Edit"),
                  ),
      
      
                  //for deletee
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (context) {
                            return Dialog(
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Are you sure ?"),
                                    Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
      
                                                delete(
                                                  widget.obj['mid'],
                                                );
                                              },
                                              child: Text("Confirm"),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll<
                                                        Color>(Colors.red),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Cancel"),
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStatePropertyAll<
                                                        Color>(Colors.lightGreen),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                      style: const ButtonStyle(
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
      ),
    );
  }
}
