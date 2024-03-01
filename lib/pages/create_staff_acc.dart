import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'dart:convert';
class CreateStaffAcc extends StatefulWidget {
  const CreateStaffAcc({super.key});
  @override
  State<CreateStaffAcc> createState() => _CreateStaffAcc();
}

class _CreateStaffAcc extends State<CreateStaffAcc> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  bool genderError = false;
  final List<TextEditingController> ctr = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  InputDecoration tfdec = InputDecoration(
    contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );

  

  Future<void> registerMember() async {
    final Map<String, dynamic> data = {
      "name": ctr[0].text,
      "gender": _selectedGender,
      "email": ctr[1].text,
      "contact_number": ctr[2].text,
      "address": ctr[3].text,
      "password": ctr[4].text
    };
    final Response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/Staff/register"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (Response.statusCode == 200) {
      final msg=jsonDecode(Response.body)['message'];
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    } else {
      
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("failed")));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          children: [
            Expanded(
                child: Container(
              child: Text(""),
            )),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 40, 20),
                child: Card(
                  elevation: 24,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Form(
                      key: _formKey,
                      child: ListView(
                        padding: EdgeInsets.all(50),
                        children: [
                          Text("Name"),
                          SizedBox(
                            height: 50,
                            child: TextFormField(
                              controller: ctr[0],
                              decoration: tfdec,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Enter your name";
                                }
                                if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                                  return "Enter proper name";
                                }
                                return null;
                              },
                            ),
                          ),
                          
                          Text("Gender : "),
                          Row(
                            children: [
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text("Male"),
                                  value: "M",
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                      genderError = false;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text("Female"),
                                  value: "F",
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                      genderError = false;
                                    });
                                  },
                                ),
                              ),
                              Expanded(
                                child: RadioListTile<String>(
                                  title: Text("Other"),
                                  value: "O",
                                  groupValue: _selectedGender,
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedGender = value;
                                      genderError = false;
                                    });
                                  },
                                ),
                              ),
                            ],
                          ),
                          Text(
                            genderError == true ? "Must select a gender" : "",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text("Email"),
                          TextFormField(
                            controller: ctr[1],
                            decoration: tfdec,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Enter email";
                              }
                              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                  .hasMatch(v)) {
                                return "Please enter valid email";
                              }
                              return null;
                            },
                          ),
                          Text("Contact Number"),
                          TextFormField(
                            controller: ctr[2],
                            decoration: tfdec,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Enter contact number";
                              }
                              if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
                                return "Enter valid number";
                              }
                              return null;
                            },
                          ),
                          Text("Address"),
                          TextFormField(
                            controller: ctr[3],
                            decoration: tfdec,
                          ),
                          Text("Password"),
                          TextFormField(
                            obscureText: true,
                            controller: ctr[4],
                            decoration: tfdec,
                            validator: (value) {
                              if (!(value == null || value.isEmpty)) {
                                if(ctr[4].text.length<8){
                                  return 'password must be min 8 word';
                                }
                              }

                              return null;
                            },
                          ),
                          
                              
                          ElevatedButton(
                              onPressed: () {
                                setState(() {});
                                if (_selectedGender == null) {
                                  genderError = true;
                                } else {
                                  genderError = false;
                                }
                                
                                if (_formKey.currentState!.validate() &&
                                    genderError == false) {
                                  registerMember();
                                }
                              },
                              child: Text("Submit")),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
