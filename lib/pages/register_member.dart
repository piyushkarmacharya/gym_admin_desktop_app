import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';

class RegisterMember extends StatefulWidget {
  @override
  State<RegisterMember> createState() => _RegisterMemberState();
}

class _RegisterMemberState extends State<RegisterMember> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedGender;
  DateTime? _dob;
  bool genderError = false;
  bool imgSizeExceed = false;
  bool ageError = false;
  final List<TextEditingController> ctr = [
    TextEditingController(),
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? temp = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1930),
        lastDate: DateTime.now());
    if (temp != null && temp != _dob) {
      setState(() {
        _dob = temp;
      });
    }
  }

  //For image
  XFile? img;
  String? imgstr;

  Future<void> getImage() async {
    final temp = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (temp != null) {
      setState(
        () {
          img = temp;
          if (getImageSize(img!) < 500) {
            imgstr = base64Encode(File(img!.path).readAsBytesSync());
            imgSizeExceed=false;
          }else{
            imgstr=null;
            imgSizeExceed=true;
          }
        },
      );
    } else {
      print("select img");
    }
  }

  double getImageSize(XFile temp) {
    final File imgfile = File(temp.path);
    int fileSizeInByte = imgfile.lengthSync();
    return (fileSizeInByte / 1024);
  }

  Future<void> registerMember() async {
    final Map<String, dynamic> data = {
      "name": ctr[0].text,
      "dob": DateFormat('yyyy-MM-dd').format(_dob!),
      "gender": _selectedGender,
      "email": ctr[1].text,
      "contact_number": ctr[2].text,
      "address": ctr[3].text,
      "weight": ctr[4].text,
      "height": ctr[5].text,
      'photo': imgstr
    };
    final Response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/Member/register"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (Response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Success")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime dob = _dob ?? DateTime.now();
    String formateddob = DateFormat("yyyy-MM-dd").format(dob);
    String today = DateFormat("yyyy-MM-dd").format(DateTime.now());

    return Scaffold(
        backgroundColor: Colors.black,
        body: Row(
          children: [
            Expanded(
                child: Container(
              child: Image.asset(
                "assets/images/quote.jpg",
              ),
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
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                    "Date of Birth: ${formateddob != today ? formateddob : "Select date"}"),
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      _selectDate(context);
                                    });
                                  },
                                  child: Text("Select DOB"),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            ageError == true ? "Minimum age must be 12 yr" : "",
                            style: Theme.of(context).textTheme.bodySmall,
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
                                return "Enter phone number";
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
                          Text("Weight (in kg)"),
                          TextFormField(
                            controller: ctr[4],
                            decoration: tfdec,
                            validator: (value) {
                              if (!(value == null || value.isEmpty)) {
                                try {
                                  double w = double.parse(value);
                                  if (w < 0 || w > 1000) {
                                    return "Enter valid weight";
                                  }
                                } catch (e) {
                                  return "Enter valid weight";
                                }
                              }

                              return null;
                            },
                          ),
                          Text("Height (in foot)"),
                          TextFormField(
                            controller: ctr[5],
                            decoration: tfdec,
                            validator: (value) {
                              if (!(value == null || value.isEmpty)) {
                                try {
                                  double h = double.parse(value);
                                  if (h < 0 || h > 10) {
                                    return "Enter valid height";
                                  }
                                } catch (e) {
                                  return "Enter valid Height";
                                }
                              }
                              return null;
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(child: Text("Select image :")),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      getImage();
                                    },
                                    child: Text("Open gallery"),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 100,
                                    child: imgstr == null
                                        ? Text("no img")
                                        : Image.memory(base64Decode(imgstr!)),
                                  ),
                                ),
                              ],
                            
                            ),
                          ),
                          imgSizeExceed==true?Center(child: Text("File size exceed 500Kb",style: Theme.of(context).textTheme.bodySmall,)):Text(""),
                          ElevatedButton(
                              onPressed: () {
                                setState(() {});
                                if (_selectedGender == null) {
                                  genderError = true;
                                } else {
                                  genderError = false;
                                }
                                if (DateTime.now().year - dob.year < 12) {
                                  ageError = true;
                                } else {
                                  ageError = false;
                                }
                                if (_formKey.currentState!.validate() &&
                                    genderError == false &&
                                    ageError == false&&imgstr!=null) {
                                  registerMember();
                                }
                                else{
                                  print("Error");
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
