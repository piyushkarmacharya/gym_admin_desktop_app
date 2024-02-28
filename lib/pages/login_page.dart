import "dart:convert";

import "package:flutter/material.dart";
import "package:gymmanagementsystem/pages/home_page.dart";
import "package:gymmanagementsystem/user_provider.dart";
import "package:http/http.dart" as http;
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> ctr = [
    TextEditingController(),
    TextEditingController()
  ];
  List data = [];
  String? email;
  Future fetchData(String url) async {
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      setState(() {
        data = jsonDecode(res.body);
      });
    } else {
      print("Cannot connect to that api");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context, listen: false).getUser();
    return Scaffold(
        appBar: AppBar(
          actions: [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.admin_panel_settings_sharp,
                    color: user == "Admin" ? Colors.yellow : Colors.grey,
                  ),
                ),
                onTap: () {
                  setState(() {
                    Provider.of<UserProvider>(context, listen: false)
                        .setUser("Admin");
                  });
                },
              ),
            ),
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(
                    Icons.people,
                    color: user == "Staff" ? Colors.yellow : Colors.grey,
                  ),
                ),
                onTap: () {
                  setState(() {
                    Provider.of<UserProvider>(context, listen: false)
                        .setUser("Staff");
                  });
                },
              ),
            ),
          ],
        ),
        backgroundColor: Colors.blueGrey,
        body: Padding(
          padding: EdgeInsets.fromLTRB(100, 50, 100, 50),
          child: Card(
            elevation: 24,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "$user Login..",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                          Spacer(),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                TextFormField(
                                  decoration: InputDecoration(
                                    labelText: "Email",
                                    prefixIcon: Icon(Icons.email),
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
                                SizedBox(height: 10,),
                                TextFormField(
                                  obscureText: true,
                                  decoration:
                                      InputDecoration(labelText: "Password",prefixIcon: Icon(Icons.lock),),
                                  controller: ctr[1],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter password";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10,),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      email = ctr[0].text;
                                      await fetchData(
                                          "http://127.0.0.1:8000/api/$user/login/$email");
                                      if (data.length == 0) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content:
                                                Text("Email doesnot Exists"),
                                          ),
                                        );
                                      } else {
                                        if (data[0]['email'] == email &&
                                            data[0]['password'] ==
                                                ctr[1].text) {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return HomePage();
                                              },
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text("Incorrect Password"),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                  child: Text("Login"),
                                )
                              ],
                            ),
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Image.asset(
                      "assets/images/logo.png",
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
