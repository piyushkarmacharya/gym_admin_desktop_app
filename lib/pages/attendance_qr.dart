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
      padding: const EdgeInsets.all(20.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
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
                child: Row(
                  children: [
                    Spacer(
                      flex: 3,
                    ),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        obscureText: true,
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
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            str = ctr.text;
                            updateQr();
                          });
                        },
                        child: Text("Generate"),
                      ),
                    ),
                    Spacer(
                      flex: 3,
                    ),
                  ],
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
