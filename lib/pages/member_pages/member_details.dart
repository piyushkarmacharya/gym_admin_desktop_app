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
      
      return data;
    } else {
      throw res.statusCode;
    }
  }

  @override
  Widget build(BuildContext context) {
    print(MediaQuery.of(context).size);
    
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
                    child: SizedBox(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width-224,
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
                                  width:0.2*MediaQuery.of(context).size.width,
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
                                    style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color(0xFF1A1363)),
                                    shape: MaterialStateProperty.all<
                                        OutlinedBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(24)),
                                    ),
                                  ),
                                    onPressed: () {
                                      setState(() {
                                        name = ctr.text;
                                      });
                                    },
                                    child: Text("Search",style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        ),
                                  ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GridView.count(
                                
                                crossAxisCount: MediaQuery.of(context).size.width<=1100?(MediaQuery.of(context).size.width<=855?1:2):3,
                                children: List.generate(
                                  snapshot.data.length,
                                (index) {
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          10, 8, 10, 8),
                                      child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                            barrierDismissible: false,
                                              context: context,
                                              builder: (context) {
                                                return Dialog(
                                                  child: MemberDialog(
                                                      keys: keys,
                                                      obj: snapshot.data[index],
                                                      ),
                                                );
                                              });
                                        },
                                        child: Card(
                                          color: Colors.white,
                                          elevation: 10,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
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
                          ),
                          SizedBox(
                            height: 30,
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}
