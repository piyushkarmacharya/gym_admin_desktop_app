import "package:flutter/material.dart";
import "package:intl/intl.dart";
import 'package:http/http.dart' as http;
import "dart:convert";

class AttendanceDetails extends StatefulWidget {
  const AttendanceDetails({super.key});

  @override
  State<AttendanceDetails> createState() => _AttendanceDetailsState();
}

class _AttendanceDetailsState extends State<AttendanceDetails> {
  List attendanceDetails = [];
  String _formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    try {
      final DateTime? temp = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1930),
          lastDate: DateTime.now());
      if (temp != null) {
        setState(() {
          DateTime selectedDate = temp;
          _formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);
          _getAttendanceDetails();
        });
      }
    } catch (e) {
      _showMessage(e.toString());
    }
  }

  TableRow getDataRow(int i) {
    TextStyle rowTextStyle = const TextStyle(
        color: Colors.white, fontSize: 14, fontWeight: FontWeight.normal);
    // DateTime temp=DateFormat("yyyy-MM-dd HH:mm:ss").parse(attendanceDetails[i]['created_at']==null?"${attendanceDetails[i]['date']} 00:00:00":attendanceDetails[i]['created_at'].toString());
    String time = attendanceDetails[i]['time'] == null
        ? "00:00:00"
        : attendanceDetails[i]['time'].toString();
    return TableRow(
      children: [
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            attendanceDetails[i]['mid'].toString(),
            style: rowTextStyle,
          ),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            attendanceDetails[i]['name'].toString(),
            style: rowTextStyle,
          ),
        )),
        TableCell(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            attendanceDetails[i]['contact_number'].toString(),
            style: rowTextStyle,
          ),
        )),
        TableCell(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              time,
              style: rowTextStyle,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _getAttendanceDetails() async {
    try {
      final res = await http.get(Uri.parse(
          "http://127.0.0.1:8000/api/attendance/info/$_formattedDate"));
      if (res.statusCode == 200) {
        List data = jsonDecode(res.body);
        setState(() {
          attendanceDetails = data;
        });
      } else {
        _showMessage("Connection Problem");
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    _getAttendanceDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 0.7 * MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFF77749B),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Attendance Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFFFFFADF),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "$_formattedDate  ",
                      style: const TextStyle(color: Colors.white),
                    ),
                    SizedBox(
                      height: 30,
                      width: 151,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(
                              const Color(0xFF5D57A3)),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectDate(context);
                          });
                        },
                        child: const Text(
                          "Select Date",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () async {
                        setState(() {
                          _getAttendanceDetails();
                        });
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                  child: Table(children: const [
                    TableRow(
                      children: [
                        TableCell(
                            child: Text(
                          'Member ID',
                          style: TextStyle(
                            color: Color(0xFFFFFADF),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        TableCell(
                            child: Text(
                          'Name',
                          style: TextStyle(
                            color: Color(0xFFFFFADF),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        TableCell(
                            child: Text(
                          'Contact',
                          style: TextStyle(
                            color: Color(0xFFFFFADF),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                        TableCell(
                            child: Text(
                          'Attendance Time',
                          style: TextStyle(
                            color: Color(0xFFFFFADF),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                      ],
                    ),
                  ]),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Table(
                        children: [
                          ...List.generate(attendanceDetails.length,
                              (index) => getDataRow(index))
                          // Add more rows as needed
                        ],
                      ),
                    ),
                  ),
                ),
                Text(
                  "Total presence : ${attendanceDetails.length}",
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
