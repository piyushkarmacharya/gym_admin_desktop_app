import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
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
          data = jsonDecode(res.body);
        });
      } else {
        print("error in connection");
      }
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    getFeedback();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    print(data);
    return Scaffold(
      body: data.length == 0
          ? CircularProgressIndicator()
          : Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
                height: double.infinity,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Container(
                        height: 0.2*screenHeight,
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20,8,8,8),
                            child: Row(
                              children: [
                                Text(data[index]['date'].toString()),
                                Expanded(
                                   
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(20,0,0,0),
                                      child: SingleChildScrollView(
                                          scrollDirection: Axis.vertical,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text("By ${data[index]['name'].toString()} (${data[index]['mid'].toString()}): "),
                                              Text("- ${data[index]['feedback'].toString()}"
                                                  ),
                                            ],
                                          )),
                                    )),
                              ],
                            ),
                          ),
                        ));
                  },
                ),
              ),
          ),
    );
  }
}
