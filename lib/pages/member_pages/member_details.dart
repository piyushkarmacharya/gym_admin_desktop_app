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
  String email = "";
  //Return datarow for datatable using list.generate
  // List<DataRow> getDataRow(List obj) {
  //   return List.generate(
  //     obj.length,
  //     (i) {
  //       return DataRow(
  //         cells: List.generate(
  //           3,
  //           (j) => DataCell(
  //             keys[j] != "photo"
  //                 ? Padding(
  //                     padding: const EdgeInsets.all(16.0),
  //                     child: Text(obj[i][keys[j]].toString()),
  //                   )
  //                 : GestureDetector(
  //                     onTap: () {
  //                       creatMemberDialog(obj, i);
  //                     },
  //                     child: Padding(
  //                       padding: const EdgeInsets.all(8.0),
  //                       child: MouseRegion(
  //                         cursor: SystemMouseCursors.click,
  //                         child: Container(
  //                             width: 60,
  //                             height: 60,
  //                             decoration: BoxDecoration(
  //                                 borderRadius: BorderRadius.circular(40)),
  //                             child: ClipOval(
  //                               child: Image.memory(
  //                                   base64Decode(obj[i][keys[j]].toString())),
  //                             )),
  //                       ),
  //                     ),
  //                   ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  Future<dynamic> creatMemberDialog(List<dynamic> obj, int i) {
    return showDialog(
        context: context,
        builder: (context) {
          return MemberDialog(keys: keys, obj: obj, i: i);
        });
  }

  Future<List> getMembersDetail() async {
    //setting condition if user uses quick search i.e email!=""
    String url = (email == "")
        ? 'http://127.0.0.1:8000/api/Member/details'
        : 'http://127.0.0.1:8000/api/Member/details/$email';
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
                return SingleChildScrollView(
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
                              children: [
                                Text("Quick search : "),
                                SizedBox(
                                  width: 300,
                                  child: TextField(
                                    controller: ctr,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 0),
                                        label: Text("Email"),
                                        border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        )),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        email = ctr.text;
                                      });
                                    },
                                    child: Text("Search"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // DataTable(
                          //   border: TableBorder.all(),
                          //   columns: List.generate(
                          //     3,
                          //     (index) => DataColumn(
                          //       label: Text(keys[index]),
                          //     ),
                          //   ),
                          //   rows: getDataRow(snapshot.data),
                          // )
                          Expanded(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 200,
                                        height: 200,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(40),
                                        ),
                                        child: Image.memory(
                                          base64Decode(snapshot.data[index]
                                                  ['photo']
                                              .toString()),
                                        ),
                                      ),
                                      Column(
                                        children: [
                                          Text(snapshot.data[index]['name']),
                                          Text(snapshot.data[index]['email']),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            }));
  }
}
