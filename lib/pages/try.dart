import 'dart:convert';
import 'dart:io';

import "package:flutter/material.dart";
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

class Try extends StatefulWidget {
  const Try({super.key});
  @override
  State<Try> createState() => _TryState();
}

class _TryState extends State<Try> {
  XFile? img;
  String? _base64img;

  double getImageSize(XFile temp) {
    final File imageFile = File(temp.path);
    int fileSizeInBytes = imageFile.lengthSync();
    double fileSizeInKB = fileSizeInBytes / 1024;

    return fileSizeInKB;
  }

  Future<void> getImage() async {
    final temp = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (temp != null) {
      if(getImageSize(temp)<500){
        setState(() {
        img = temp;
      });
     
      _base64img = base64Encode(File(img!.path).readAsBytesSync());
      }else{
        print("Size exceed 500");
      }
      
    } else {
      print("no pic");
    }
  }

  Future<void> sendimg() async {
    String temp = _base64img!;
    final Map<String, dynamic> data = {'img': temp};
    final response = await http.post(
      Uri.parse("http://127.0.0.1:8000/api/img"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (response.statusCode == 200) {
      print("Success");
    } else {
      print(response.statusCode);
    }
  }

  List temp = [];
  Future<void> getting() async {
    final response = await http.get(
      Uri.parse("http://127.0.0.1:8000/api/img/get"),
    );
    if (response.statusCode == 200) {
      print("Success");
      setState(() {
        temp = jsonDecode(response.body);
      });
    } else {
      print(response.statusCode);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                getImage();
              });
            },
            child: Text("click"),
          ),
          ElevatedButton(
              onPressed: () async {
                await getting();
              },
              child: Text("Get")),
          temp.length != 0
              ? Image.memory(base64Decode(temp[3]["img"]!))
              : SizedBox(
                  child: Text("no"),
                ),
          ElevatedButton(
              onPressed: () {
                if(getImageSize(img!)<500){
                  sendimg();
                }else{
                  print("Size of image exceed from 500Kb");
                }
                
              },
              child: Text("Send")),
        ],
      ),
    ));
  }
}
