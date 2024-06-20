import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gymmanagementsystem/pages/home_page.dart';
import 'package:gymmanagementsystem/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class MemberUpdate extends StatefulWidget {
  final List<String> keys;
  final Map<String, dynamic> obj;
  const MemberUpdate({super.key, required this.keys, required this.obj});
  @override
  State<MemberUpdate> createState() => _MemberUpdate();
}

class _MemberUpdate extends State<MemberUpdate> {
  late final List<TextEditingController> ctr;
  DateTime? _dob;
  String? _selectedGender;
  String? imgstr;
  @override
  void initState() {
    super.initState();
    imgstr = widget.obj['photo'];
    _selectedGender = widget.obj['gender'];
    _dob = DateTime.parse(widget.obj['dob']);
    ctr = [
      TextEditingController(text: widget.obj['name']),
      TextEditingController(text: widget.obj['email']),
      TextEditingController(text: widget.obj['contact_number'].toString()),
      TextEditingController(text: widget.obj['address']),
      TextEditingController(text: widget.obj['weight']==null?"":widget.obj['weight'].toString()),
      TextEditingController(text: widget.obj['height']==null?"":widget.obj['height'].toString()),
    ];
  }

  final _formKey = GlobalKey<FormState>();

  bool genderError = false;
  bool imgSizeExceed = false;
  bool ageError = false;

  InputDecoration tfdec = InputDecoration(
    filled: true,
    fillColor:const Color(0xFFE9E9E9),
    contentPadding:const  EdgeInsets.symmetric(vertical: 0, horizontal: 10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  );
  final TextStyle tstyle = const TextStyle(
      color: Color(0xFF2B2B2B), fontWeight: FontWeight.bold, fontSize: 16);

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? temp = await showDatePicker(
        context: context,
        initialDate: DateTime.parse(widget.obj['dob']),
        firstDate: DateTime(1900),
        lastDate: DateTime.now());
    if (temp != null && temp != _dob) {
      setState(() {
        _dob = temp;
      });
    }
  }

  //For image
  XFile? img;

  Future<void> getImage() async {
    final temp = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (temp != null) {
      setState(
        () {
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
    } else {
      print("select img");
    }
  }

  double getImageSize(XFile temp) {
    final File imgfile = File(temp.path);
    int fileSizeInByte = imgfile.lengthSync();
    return (fileSizeInByte / 1024);
  }
    Map error = {};
  Future<void> updateMember() async {
      final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
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
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/Member/update/${widget.obj['mid']}"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
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
            content: Center(child: Text(jsonDecode(response.body)['message'])),
          ),
        );
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
          error = jsonDecode(response.body);
          _formKey.currentState!.validate();
        });
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime dob = _dob ?? DateTime.now();
    String formateddob = DateFormat("yyyy-MM-dd").format(dob);
    String today = DateFormat("yyyy-MM-dd").format(DateTime.now());

    return SizedBox(
      height: 500,
      width: 700,
      child: Dialog(
          child: Column(
        children: [
          const Text(
            "Update Member Information",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1363),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [Icon(Icons.close)],
                )),
          ),
          Expanded(
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
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
                          if (!RegExp(r'^[A-Z][a-z]* (?:[A-Z][a-z]* )?[A-Z][a-z]*$').hasMatch(value)) {
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
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color(0xFF1A1363)),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24)),
                              ),
                            ),
                            onPressed: () {
                              setState(() {
                                _selectDate(context);
                              });
                            },
                            child: const Text(
                              "Select DOB",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      ageError == true ? "Invalid age for GYM (12 - 80 yr)" : "",
                      style: TextStyle(color: Colors.red[900],fontSize: 11),
                    ),
                    Text(
                      "Gender : ",
                      style: tstyle,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: RadioListTile<String>(
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
                        ),
                        Expanded(
                          child: RadioListTile<String>(
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
                        ),
                        Expanded(
                          child: RadioListTile<String>(
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
                        ),
                      ],
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
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                              .hasMatch(v)) {
                            return "Please enter valid email";
                          }
                          if (error.containsKey('error') &&
                                      error['error'].containsKey('email') &&
                                      error['error']['email'] is List &&
                                      error['error']['email'].isNotEmpty) {
                                    String temp = error['error']['email'][0];
                                    // setState(() {
                                    //   error['error']['email'] = [];
                                    // });
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
                                  } else {
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
                      "Height (in ft)",
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
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                    const Color(0xFF1A1363)),
                                shape: MaterialStateProperty.all<OutlinedBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                ),
                              ),
                              onPressed: () {
                                getImage();
                              },
                              child:const  Text(
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
                    imgSizeExceed == true
                        ? Center(
                            child: Text(
                            "File size exceed 500Kb",
                            style: Theme.of(context).textTheme.bodySmall,
                          ))
                        : const Text(""),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
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
                              setState(() {
                                      error= {};
                                    });
                              
                              if (_selectedGender == null) {
                                setState(() {
                                  genderError = true;
                                });
                                
                              } else {
                                setState(() {
                                  genderError = false;
                                });
                                
                              }
                              if (DateTime.now().year - dob.year < 12||DateTime.now().year - dob.year >80) {
                                setState(() {
                                    ageError = true;
                                });
                              
                              } else {
                                setState(() {
                                  ageError = false;
                                });
                                
                              }
                              if (_formKey.currentState!.validate() &&
                                  genderError == false &&
                                  ageError == false &&
                                  imgstr != null) {
                                    setState(() {
                                      updateMember();
                                    });
                                
                              } else {
                                print("validate please");
                              }
                            },
                            child: const Text(
                              "Update",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){
                            setState(() {
                              Provider.of<UserProvider>(context,listen: false).setCurrentPage(0);
                              Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>HomePage(),),);
                            });
                          }, child: const Text("Cancel",)),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      )),
    );
  }
}
