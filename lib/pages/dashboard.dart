import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Dashboard extends StatefulWidget{
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int numOfMembers=0;
  void initState(){
    super.initState();
    fetchData();
  }


  Future<void> fetchData() async {
    try {
      String url = 'http://127.0.0.1:8000/api/Member/details';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        await Future.delayed(Duration(seconds: 2));
        setState(() {
          numOfMembers = data.length;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
 
  @override
  Widget build(BuildContext context) {
  
    return Scaffold(
      body:numOfMembers==0?CircularProgressIndicator():Text("$numOfMembers")
    );
  }
}