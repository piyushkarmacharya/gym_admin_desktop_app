import 'dart:convert';
import 'package:flutter/material.dart';
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
    'mid',
    'name',
    'dob',
    'gender',
    'email',
    'contact_number',
    'address',
    'weight',
    'height'
  ];
  List<DataRow> getAbc(List obj) {
    return List.generate(
      obj.length,
      (i) {
        return DataRow(
          cells: List.generate(
            keys.length,
            (j) => DataCell(
              Text(obj[i][keys[j]].toString()),
            ),
          ),
        );
      },
    );
  }

  Future<List> getMembersDetail() async {
    try {
      final res =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/Member/details'));
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        await Future.delayed(Duration(seconds: 2));
        return data;
      } else {
        throw res.statusCode;
      }
    } catch (e) {
      rethrow;
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text("Quick search : "),
                              SizedBox(
                                width: 300,
                                child: TextField(
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 0),
                                    label: Text("Email"),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    )
                                  ),
                                  
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: ElevatedButton(onPressed: (){}, child:Text("Search"),),
                              ),
                            ],
                          ),
                        ),
                        DataTable(
                          columns: List.generate(
                            keys.length,
                            (index) => DataColumn(
                              label: Text(keys[index]),
                            ),
                          ),
                          rows: getAbc(snapshot.data),
                        ),
                      ],
                    ),
                  ),
                );
              }
            }));
  }
}
