import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gymmanagementsystem/pages/home_page.dart';
import 'package:gymmanagementsystem/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> ctr = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

  Future<void> setNewPassword(String oldPass, String newPass) async {
    try {
      final res = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/admin/change-password"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'oldPassword': oldPass,
          'newPassword': newPass,
          'id': Provider.of<UserProvider>(context, listen: false).getUserId()
        }),
      );
      String msg = jsonDecode(res.body)['message'];
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(msg),
          ),
        );
        if (msg == "success") {
          setState(() {
            Provider.of<UserProvider>(context, listen: false).setCurrentPage(0);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          });
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Connection problem")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                height: 500,
                width: 500,
                child: Column(
                  children: [
                    TextFormField(
                      controller: ctr[0],
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Current password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter password";
                        } else if (value.length < 8) {
                          return "Password must me minimum 8 character";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: ctr[1],
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "New password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter password";
                        } else if (value.length < 8) {
                          return "Password must me minimum 8 character";
                        } else if (ctr[0].text == value) {
                          return "Old password and new password cannot be same";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: ctr[2],
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm password",
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter password";
                        } else if (value.length < 8) {
                          return "Password must me minimum 8 character";
                        } else if (ctr[1].text != value) {
                          return "New password and confirm password donot match";
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          if (_formKey.currentState!.validate()) {
                            setNewPassword(ctr[0].text, ctr[1].text);
                          }
                        });
                      },
                      child: Text("Change Password"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
