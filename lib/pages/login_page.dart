import "dart:collection";
import "dart:convert";
import "dart:ffi";
//Required for jsonDecode

import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:gymmanagementsystem/pages/home_page.dart";
import "package:gymmanagementsystem/user_provider.dart";

import "package:http/http.dart" as http;
//required for connecting to backend

import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _showPassword = false;
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> ctr = [
    TextEditingController(),
    TextEditingController()
  ];
  Map<String, dynamic> data = {};
  String? email;
  Future login() async {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    try {
      final res = await http.post(
        Uri.parse("http://127.0.0.1:8000/api/admin/login"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': ctr[0].text, 'password': ctr[1].text}),
      );

      if (res.statusCode == 200) {
        setState(() {
          data = jsonDecode(res.body);
        });
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(
          SnackBar(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(0),
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(0))),
            backgroundColor: Colors.red,
            margin: EdgeInsets.fromLTRB(
                0.8 * screenWidth, 0, 0, 0.8 * screenHeight),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 1),
            content: Text("Connection problem"),
          ),
        );
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.admin_panel_settings_sharp,
                color: Color(0xFF1A1363),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(141, 50, 70, 50),
          child: Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    height: 500,
                    width: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Sign-in",
                          style: TextStyle(
                              color: Color(0xFF1A1363),
                              fontWeight: FontWeight.bold,
                              fontSize: 36),
                        ),
                        const SizedBox(height: 55),
                        Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Email*",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF332F64)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 8),
                                child: Container(
                                  width: 406,
                                  child: TextFormField(
                                    style: const TextStyle(fontSize: 18),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFF332F64),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFF332F64),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFF332F64),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: const Icon(Icons.email),
                                    ),
                                    controller: ctr[0],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter email";
                                      }
                                      if (!RegExp(
                                              r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                                          .hasMatch(value)) {
                                        return "Please enter valid email";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Password*",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF332F64)),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 8),
                                child: Container(
                                  width: 406,
                                  height: 69,
                                  child: TextFormField(
                                    onFieldSubmitted: (value) async {
                                      if (_formKey.currentState!.validate()) {
                                        email = ctr[0].text;
                                        setState(() {});
                                        await login();
                                        if (data['login'] == true) {
                                          setState(() {});
                                          Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .setUserId(data['id']);
                                              Provider.of<UserProvider>(context,
                                                  listen: false)
                                              .setAdminName(data['name']);
                                              
                                          Navigator.of(context).pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return const HomePage();
                                              },
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          bottomLeft: Radius
                                                              .circular(0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20),
                                                          topLeft:
                                                              Radius.circular(
                                                                  0),
                                                          topRight:
                                                              Radius.circular(
                                                                  20))),
                                              backgroundColor: Colors.red,
                                              margin: EdgeInsets.fromLTRB(
                                                  0,
                                                  0,
                                                  0.7 * screenWidth,
                                                  0.05 * screenHeight),
                                              behavior:
                                                  SnackBarBehavior.floating,
                                              duration: Duration(seconds: 1),
                                              content: Text(
                                                  "Email and password donot match"),
                                            ),
                                          );
                                        }
                                      }
                                    },
                                    style: const TextStyle(fontSize: 18),
                                    obscureText: !_showPassword,
                                    decoration: InputDecoration(
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _showPassword = !_showPassword;
                                          });
                                        },
                                        icon: Icon(_showPassword
                                            ? Icons.visibility_off
                                            : Icons.visibility),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFF332F64),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                          color: Color(0xFF332F64),
                                          width: 2,
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      prefixIcon: const Icon(Icons.lock),
                                    ),
                                    controller: ctr[1],
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter password";
                                      } else if (value.length < 8) {
                                        return "Password cannot be less than 8 character";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: 399,
                                height: 50,
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
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      email = ctr[0].text;
                                      setState(() {});
                                      await login();
                                      if (data['login'] == true) {
                                        setState(() {});
                                        Provider.of<UserProvider>(context,
                                                listen: false)
                                            .setUserId(data['id']);
                                            Provider.of<UserProvider>(context,
                                                listen: false)
                                            .setAdminName(data['name']);
                                            
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return const HomePage();
                                            },
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                    topLeft: Radius.circular(0),
                                                    topRight:
                                                        Radius.circular(20))),
                                            backgroundColor: Colors.red,
                                            margin: EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0.7 * screenWidth,
                                                0.05 * screenHeight),
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                                "Email and password donot match"),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: const Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 27,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Spacer(),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible:
                    MediaQuery.of(context).size.width <= 530 ? false : true,
                child: Expanded(
                  child: Image.asset(
                    "assets/images/logo.png",
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
