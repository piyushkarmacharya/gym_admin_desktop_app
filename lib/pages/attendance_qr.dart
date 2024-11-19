import "package:flutter/material.dart";
import "package:qr_flutter/qr_flutter.dart";
import "package:http/http.dart" as http;
import 'dart:convert';

class AttendanceQr extends StatefulWidget {
  const AttendanceQr({super.key});
  @override
  State<AttendanceQr> createState() => _AttendanceQrState();
}

class _AttendanceQrState extends State<AttendanceQr> {
  final _formKey = GlobalKey<FormState>();
  String str = "";
  TextEditingController ctr = TextEditingController();

  @override
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
      debugPrint('Error: $e');
    }
  }

  void _showMessage(String msg) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(0),
                bottomRight: Radius.circular(20),
                topLeft: Radius.circular(0),
                topRight: Radius.circular(20))),
        backgroundColor: Colors.green,
        margin:
            EdgeInsets.fromLTRB(0, 0, 0.7 * screenWidth, 0.05 * screenHeight),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Center(child: Text(msg)),
      ),
    );
  }

  Future<void> updateQr() async {
    final Map<String, dynamic> data = {
      "qrstr": str,
    };
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/AttendanceQr/update"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      _showMessage(jsonDecode(response.body)['message']);
    } else {
      _showMessage("Failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      child: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Scaffold(
              body: Column(
            children: [
              const Spacer(),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: str == ""
                        ? const CircularProgressIndicator(
                            backgroundColor: Colors.grey,
                          )
                        : QrImageView(
                            data: str,
                            version: QrVersions.auto,
                          ),
                  )),
              const Spacer(),
              Expanded(
                flex: 1,
                child: Form(
                  key: _formKey,
                  child: ListView(children: [
                    Row(
                      children: [
                        const Spacer(
                          flex: 3,
                        ),
                        Expanded(
                          flex: 3,
                          child: TextFormField(
                            obscureText: true,
                            validator: (value) {
                              if (value == null || value == "") {
                                return "Please enter a string";
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text("Enter a string"),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            controller: ctr,
                          ),
                        ),
                        const Spacer(
                          flex: 1,
                        ),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF1A1363)),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                              ),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  str = ctr.text;
                                  updateQr();
                                });
                              }
                            },
                            child: const Text(
                              "Generate",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        const Spacer(
                          flex: 3,
                        ),
                      ],
                    ),
                  ]),
                ),
              ),
              const Spacer(),
            ],
          )),
        ),
      ),
    );
  }
}
