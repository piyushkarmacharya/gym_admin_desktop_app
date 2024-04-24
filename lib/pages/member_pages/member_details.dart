import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:gymmanagementsystem/pages/member_pages/member_dialog.dart';
import 'package:http/http.dart' as http;

class MemberDetails extends StatefulWidget {
  const MemberDetails({super.key});

  @override
  State<MemberDetails> createState() {
    return _MemberDetailsState();
  }
}

class _MemberDetailsState extends State<MemberDetails> {
  List<String> keys = [
    'photo',
    'name',
    'email',
    'mid',
    'dob',
    'gender',
    'contact_number',
    'address',
    'weight',
    'height',
  ];

  TextEditingController ctr = TextEditingController();
  String name = "";


  Future<List> getMembersDetail() async {
    //setting condition if user uses quick search i.e email!=""
    String url = (name == "")
        ? 'http://127.0.0.1:8000/api/Member/details'
        : 'http://127.0.0.1:8000/api/Member/details/$name';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      await Future.delayed(Duration(seconds: 2));
      return data;
    } else {
      throw res.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
            future: getMembersDetail(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              } else {
                return SafeArea(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Quick search : "),
                                  SizedBox(
                                    width: 300,
                                    child: TextField(
                                      controller: ctr,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        prefixIcon: Icon(Icons.search),
                                        label: Text("Enter Name"),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      onSubmitted: (value) {
                                        setState(() {
                                          name = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          name = ctr.text;
                                        });
                                      },
                                      child: Text("Search"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                           
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          50, 8, 50, 8),
                                      child: GestureDetector(
                                        onTap: () {showDialog(context: context, builder: (context){return Dialog(child:MemberDialog(keys: keys, obj:snapshot.data, i: index),);});},
                                        child: Card(
                                          elevation: 10,
                                          child: Row(
                                            children: [
                                              Spacer(),
                                              Container(
                                                width: 200,
                                                height: 200,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                ),
                                                child: Image.memory(
                                                  base64Decode(snapshot
                                                      .data[index][keys[0]]
                                                      .toString()),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Text(snapshot.data[index]
                                                      [keys[1]]),
                                                  Text(snapshot.data[index]
                                                      [keys[2]]),
                                                  Text(snapshot.data[index]
                                                          [keys[6]]
                                                      .toString()),
                                                ],
                                              ),
                                              Spacer()
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}
