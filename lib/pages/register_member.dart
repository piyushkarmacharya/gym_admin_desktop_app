import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gymmanagementsystem/pages/home_page.dart';
import 'package:gymmanagementsystem/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class RegisterMember extends StatefulWidget {
  const RegisterMember({super.key});
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
    TextEditingController(),
  ];
  InputDecoration tfdec = InputDecoration(
    filled: true,
    fillColor: const Color(0xFFE9E9E9),
    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
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
  bool imgSelected = false;

  Future<void> getImage() async {
    final temp = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (temp != null) {
      setState(
        () {
          imgSelected = true;
          img = temp;
          if (getImageSize(img!) < 500) {
            imgstr = base64Encode(File(img!.path).readAsBytesSync());
            imgSizeExceed = false;
          } else {
            imgstr = null;
            imgSizeExceed = true;
          }
        },
      );
    }
  }

  double getImageSize(XFile temp) {
    final File imgfile = File(temp.path);
    int fileSizeInByte = imgfile.lengthSync();
    return (fileSizeInByte / 1024);
  }

  Map error = {};

  Future<void> registerMember() async {
    
    try {
      final screenHeight = MediaQuery.of(context).size.height;
      final screenWidth = MediaQuery.of(context).size.width;
      final Map<String, dynamic> data = {
        "name": ctr[0].text,
        "dob": DateFormat('yyyy-MM-dd').format(_dob!),
        "gender": _selectedGender,
        "email": ctr[1].text,
        "contact_number": ctr[2].text,
        "address":ctr[3].text,
        "weight": ctr[4].text.isEmpty?"0":ctr[4].text,
        "height": ctr[5].text.isEmpty?"0": ctr[5].text,
        'photo': imgstr,
        // 'password': ctr[6].text
      };
      final Response = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/Member/register"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data),
      );
      if (Response.statusCode == 200) {
        print(jsonDecode(Response.body)['password']);
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
            content: Text(jsonDecode(Response.body)['message']),
          ),
        );
        setState(() {
          Provider.of<UserProvider>(context, listen: false).setCurrentPage(3);
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) {
              return const HomePage();
            },
          ),
        );
      } else {
        setState(() {
          error = jsonDecode(Response.body);
          _formKey.currentState!.validate();
        });
      }
    } catch (e) {
      print(e);
    }
  }

  final TextStyle tstyle = const TextStyle(
      color: Color(0xFF2B2B2B), fontWeight: FontWeight.bold, fontSize: 16);
  // bool _showPassword = false;

  @override
  Widget build(BuildContext context) {
    DateTime dob = _dob ?? DateTime.now();
    String formateddob = DateFormat("yyyy-MM-dd").format(dob);
    String today = DateFormat("yyyy-MM-dd").format(DateTime.now());

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 40, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Add New Member!",
            style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDEBA3B)),
          ),
          const Text(
            "Register",
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1363),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 0.7 * MediaQuery.of(context).size.width,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(40, 20, 40, 16),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
                              style: tstyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 10),
                              child: TextFormField(
                                controller: ctr[0],
                                decoration: tfdec,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Enter your name";
                                  }
                                  if (!RegExp(
                                          r'^[A-Z][a-z]* (?:[A-Z][a-z]* )?[A-Z][a-z]*$')
                                      .hasMatch(value)) {
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
                                    "Date of Birth: ${formateddob != today ? formateddob : "Select date"}",
                                    style: tstyle,
                                  ),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        _selectDate(context);
                                      });
                                    },
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
                                    child: Text(
                                      "Select DOB",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              ageError == true
                                  ? "Minimum age must be 12 yr"
                                  : "",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              "Gender : ",
                              style: tstyle,
                            ),
                            RadioListTile<String>(
                              title: Text(
                                "Male",
                                style: tstyle,
                              ),
                              value: "M",
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                  genderError = false;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text(
                                "Female",
                                style: tstyle,
                              ),
                              value: "F",
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                  genderError = false;
                                });
                              },
                            ),
                            RadioListTile<String>(
                              title: Text(
                                "Other",
                                style: tstyle,
                              ),
                              value: "O",
                              groupValue: _selectedGender,
                              onChanged: (value) {
                                setState(() {
                                  _selectedGender = value;
                                  genderError = false;
                                });
                              },
                            ),
                            Text(
                              genderError == true ? "Must select a gender" : "",
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              "Email",
                              style: tstyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 10),
                              child: TextFormField(
                                controller: ctr[1],
                                decoration: tfdec,
                                validator: (v) {
                                  if (v == null || v.isEmpty) {
                                    return "Enter email";
                                  }
                                  if (!RegExp(
                                          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                      .hasMatch(v)) {
                                    return "Please enter valid email";
                                  }
                                  if (error.containsKey('error') &&
                                      error['error'].containsKey('email') &&
                                      error['error']['email'] is List &&
                                      error['error']['email'].isNotEmpty) {
                                    String temp = error['error']['email'][0];
                                    setState(() {
                                      error['error']['email'] = [];
                                    });
                                    return temp;
                                  }
                                  return null;
                                },
                              ),
                            ),

                            Text(
                              "Contact Number",
                              style: tstyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 10),
                              child: TextFormField(
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
                            ),
                            Text(
                              "Address",
                              style: tstyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 10),
                              child: TextFormField(
                                controller: ctr[3],
                                decoration: tfdec,
                                validator: (value) {
                                  if (!(value == null || value.isEmpty)) {
                                    if (!RegExp(r'^[A-Za-z]+[A-Za-z0-9, -]*$')
                                        .hasMatch(value)) {
                                      return "Enter valid address";
                                    }
                                  }else{
                                    return "Please enter address";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Text(
                              "Weight (in kg)",
                              style: tstyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 10),
                              child: TextFormField(
                                controller: ctr[4],
                                decoration: tfdec,
                                validator: (value) {
                                  if (!(value == null || value.isEmpty)) {
                                    try {
                                      double w = double.parse(value);
                                      if (w < 20 || w > 300) {
                                        return "Enter valid weight";
                                      }
                                    } catch (e) {
                                      return "Enter valid weight";
                                    }
                                  }

                                  return null;
                                },
                              ),
                            ),
                            Text(
                              "Height (in foot)",
                              style: tstyle,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 8, 8, 10),
                              child: TextFormField(
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
                            ),
                            // Text(
                            //   "Password",
                            //   style: tstyle,
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(0, 8, 8, 10),
                            //   child: TextFormField(
                            //     obscureText: !_showPassword,
                            //     controller: ctr[6],
                            //     decoration: InputDecoration(
                            //       filled: true,
                            //       fillColor: Color(0xFFE9E9E9),
                            //       contentPadding: EdgeInsets.symmetric(
                            //           vertical: 0, horizontal: 10),
                            //       border: OutlineInputBorder(
                            //         borderRadius: BorderRadius.circular(12),
                            //       ),
                            //       suffixIcon: IconButton(
                            //         onPressed: () {
                            //           setState(() {
                            //             _showPassword = !_showPassword;
                            //           });
                            //         },
                            //         icon: Icon(_showPassword
                            //             ? Icons.visibility_off
                            //             : Icons.visibility),
                            //       ),
                            //     ),
                            //     validator: (value) {
                            //       if (value == null || value.isEmpty) {
                            //         return "Password cannot be empty";
                            //       } else if (value.length < 8) {
                            //         return "Password must be minimum 8 character";
                            //       }
                            //       return null;
                            //     },
                            //   ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    "Select image :",
                                    style: tstyle,
                                  )),
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        getImage();
                                      },
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
                                      child: Text(
                                        "Open gallery",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: SizedBox(
                                      height: 100,
                                      child: imgstr == null
                                          ? Text(
                                              "no img",
                                              style: tstyle,
                                            )
                                          : Image.memory(base64Decode(imgstr!)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Visibility(
                              visible: imgSizeExceed,
                              child: Center(
                                  child: Text(
                                "File size exceed 500Kb",
                                style: Theme.of(context).textTheme.bodySmall,
                              )),
                            ),
                            Visibility(
                                visible: !imgSelected,
                                child: Center(
                                    child: Text(
                                  "Please Select image",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ))),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                                          ageError == false &&
                                          imgstr != null) {
                                            
                                        registerMember();
                                      } else {
                                        print("Error");
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "Submit",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                        side: MaterialStateProperty.all<
                                            BorderSide>(
                                          BorderSide(
                                              color: Color(0xFF1A1363),
                                              width: 2.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .setCurrentPage(0);
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) => HomePage(),
                                            ),
                                          );
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Cancel"),
                                      )),
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
