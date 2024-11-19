import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:gymmanagementsystem/pages/home_page.dart';
import 'package:gymmanagementsystem/user_provider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});
  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> ctr = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController()
  ];

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
        backgroundColor:
            msg == "Old password donot match" ? Colors.red : Colors.green,
        margin:
            EdgeInsets.fromLTRB(0, 0, 0.7 * screenWidth, 0.05 * screenHeight),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        content: Center(child: Text(msg)),
      ),
    );
  }

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
        _showMessage(msg);
        if (msg == "Successfully changed password") {
          setState(() {
            Provider.of<UserProvider>(context, listen: false).setCurrentPage(0);
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          });
        }
      } else {
        _showMessage("Connection Problem");
      }
    } catch (e) {
      _showMessage(e.toString());
    }
  }

  final List<bool> _showPassword = [false, false, false];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 500,
                width: 500,
                child: Column(
                  children: [
                    TextFormField(
                      controller: ctr[0],
                      obscureText: !_showPassword[0],
                      decoration: InputDecoration(
                        labelText: "Current password",
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword[0] = !_showPassword[0];
                            });
                          },
                          icon: Icon(_showPassword[0]
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        prefixIcon: const Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter password";
                        } else if (value.length < 8) {
                          return "Password must be minimum 8 character";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: ctr[1],
                      obscureText: !_showPassword[1],
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword[1] = !_showPassword[1];
                            });
                          },
                          icon: Icon(_showPassword[1]
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        labelText: "New password",
                        prefixIcon: const Icon(Icons.lock),
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
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: ctr[2],
                      obscureText: !_showPassword[2],
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _showPassword[2] = !_showPassword[2];
                            });
                          },
                          icon: Icon(_showPassword[2]
                              ? Icons.visibility_off
                              : Icons.visibility),
                        ),
                        labelText: "Confirm password",
                        prefixIcon: const Icon(Icons.lock),
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
                    const SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
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
                          if (_formKey.currentState!.validate()) {
                            setNewPassword(ctr[0].text, ctr[1].text);
                          }
                        });
                      },
                      child: const Text(
                        "Change Password",
                        style: TextStyle(color: Colors.white),
                      ),
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
