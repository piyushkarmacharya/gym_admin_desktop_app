import "dart:convert";
//Required for jsonDecode

import "package:flutter/material.dart";
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
  final _formKey = GlobalKey<FormState>();
  final List<TextEditingController> ctr = [
    TextEditingController(),
    TextEditingController()
  ];
  Map<String, dynamic> data = {};
  String? email;
  Future login(String url) async {
    try{
        final res = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': ctr[0].text, 'password': ctr[1].text}),
    );
    
    if (res.statusCode == 200) {
      setState(() {
        data = jsonDecode(res.body);
      });
    } else {
            ScaffoldMessenger.of(context,).showSnackBar(SnackBar(duration: Duration(seconds: 1),content: Text("Connection problem"),),);

    }
    }catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(duration: Duration(seconds: 1),content: Text("Connection problem"),),);
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
                                "$user",
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
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    labelText: "Password",
                                    prefixIcon: Icon(Icons.lock),
                                  ),
                                  controller: ctr[1],
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter password";
                                    }else if(value.length<8){
                                      return "Password cannot be less than 8 character";
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                ElevatedButton(
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      email = ctr[0].text;
                                      
                                      await login(
                                          "http://127.0.0.1:8000/api/$user/login");
                                      if (data['login'] == true) {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return HomePage();
                                            },
                                          ),
                                        );
                                      } else if(data.length==0){}else{
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            duration: Duration(seconds: 1),
                                            content: Text(
                                                "Email and password donot match"),
                                          ),
                                        );
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
