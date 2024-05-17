import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:http/http.dart" as http;
import 'dart:convert';

class AttendanceQr extends StatefulWidget {
  const AttendanceQr({super.key});
  State<AttendanceQr> createState() => _AttendanceQrState();
}

class _AttendanceQrState extends State<AttendanceQr> {
  final _formKey=GlobalKey<FormState>();
  String str = "";
  TextEditingController ctr = TextEditingController();

  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      String url = 'http://127.0.0.1:8000/api/AttendanceQr';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        Map data = jsonDecode(res.body);
        
        setState(() {
          str = data["qrstr"];
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> updateQr() async {
    final Map<String, dynamic> data = {
      "qrstr":str,
    };
    final Response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/AttendanceQr/update"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (Response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("updated")));
      
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20,0,20,20),
      child: Container(
        
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Scaffold(
              body: Column(
            children: [
              Spacer(),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: str == ""
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.grey,
                          )
                        : QrImageView(
                            data: str,
                            version: QrVersions.auto,
                          ),
                  )),
              Spacer(),
              Expanded(
                flex: 1,
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children:[ Row(
                      children: [
                        Spacer(
                          flex: 3,
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            obscureText: true,
                            validator: (value){
                              if(value==null||value==""){
                                return "Please enter a string";
                              }
                            },
                            decoration: InputDecoration(
                              label: Text("Enter a string"),
                              contentPadding:
                                  EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            controller: ctr,
                          ),
                        ),
                        Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color(0xFF1A1363)),
                                        shape: MaterialStateProperty.all<
                                            OutlinedBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(24)),
                                        ),
                                      ),
                            onPressed: () {
                              if(_formKey.currentState!.validate()){
                                setState(() {
                                str = ctr.text;
                                updateQr();
                              });
                              }
                              
                            },
                            child: Text("Generate",style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        Spacer(
                          flex: 3,
                        ),
                      ],
                    ),
                    ]
                  ),
                ),
              ),
              Spacer(),
            ],
          )),
        ),
      ),
    );
  }
}
