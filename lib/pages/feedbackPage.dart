import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:gymmanagementsystem/pages/home_page.dart';
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

  Future<void> deleteFeedback(int id) async {
    try {
      final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
      String url = 'http://127.0.0.1:8000/api/feedback/delete/$id';

      final res = await http.get(Uri.parse(url));
      if (res.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(0),
                                                    bottomRight:
                                                        Radius.circular(20),
                                                    topLeft: Radius.circular(0),
                                                    topRight:
                                                        Radius.circular(20))),
                                            backgroundColor: Colors.green,
                                            margin: EdgeInsets.fromLTRB(
                                                0,
                                                0,
                                                0.7 * screenWidth,
                                                0.05 * screenHeight),
                                            behavior: SnackBarBehavior.floating,
                                            duration: Duration(seconds: 1),
                                            content: Center(
                                              child: Text(
                                                  jsonDecode(res.body)['message']),
                                            ),
                                          ),);
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
                        height: 0.2 * screenHeight,
                        child: Card(
                          elevation: 10,
                          color: Color(0xFF77749B),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 8, 8),
                            child: Row(
                              children: [
                                Text(
                                  data[index]['date'].toString(),
                                  style: TextStyle(color: Colors.white),
                                ),
                                Expanded(
                                    child: Container(
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(20, 0, 0, 0),
                                    child: SingleChildScrollView(
                                        scrollDirection: Axis.vertical,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "By ${data[index]['name'].toString()} (${data[index]['mid'].toString()}): ",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Text(
                                              "- ${data[index]['feedback'].toString()}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        )),
                                  ),
                                )),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                      onPressed: () {
                                        deleteFeedback(data[index]['id']);
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomePage()));
                                      },
                                      icon: Icon(
                                          color: Colors.white, Icons.delete)),
                                ),
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
