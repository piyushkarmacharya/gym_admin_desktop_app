import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:qr_flutter/qr_flutter.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int numOfMembers = 0;
  String qrStr = "";
  void initState() {
    super.initState();
    fetchData();
    getQrString();
  }

  Future<void> fetchData() async {
    try {
      String url = 'http://127.0.0.1:8000/api/Member/details';
      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        setState(() {
          numOfMembers = data.length;
        });
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Connection Problem")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Connection Problem")));
    }
  }

  Future<void> getQrString() async {
    try {
      final res =
          await http.get(Uri.parse("http://127.0.0.1:8000/api/AttendanceQr"));
      if (res.statusCode == 200) {
        setState(() {
          
        });
        qrStr = jsonDecode(res.body)['qrstr'];
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Connection Problem")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Connection Problem")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.count(
        crossAxisCount: 5,
        children: [
          Card(
            child: numOfMembers == 0
              ? CircularProgressIndicator()
              : Padding(
                padding: const EdgeInsets.all(30.0),
                child: Center(child: Column(children: [Text("Total members"),Text(numOfMembers.toString())],)),
              ),
          ),
          Card(
            child: qrStr == ""
            ? CircularProgressIndicator()
            : Expanded(child: Container(child: QrImageView(data: qrStr,version: QrVersions.auto,size:200,)))
          ),
          
        ],
      ),
    );
  }
}
