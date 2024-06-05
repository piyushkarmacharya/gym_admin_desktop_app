import "package:flutter/material.dart";
import 'package:http/http.dart' as http;
import 'dart:convert';

class FeedbackPage extends StatefulWidget {
  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  List data = [];
  Future<void> getFeedback() async {
    try {
      String url = 'http://127.0.0.1:8000/api/feedback/details';

      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        setState(() {
          List data = jsonDecode(res.body);
          print(data);
        });
      } else {
        print("error in connection");
      }
    } catch (e) {
      print(e);
    }
  }
void initState(){
  super.initState();
  getFeedback();
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("hello"),
    );
  }
}
