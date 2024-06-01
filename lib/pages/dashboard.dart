import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:table_calendar/table_calendar.dart';

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
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  Future<void> getQrString() async {
    try {
      final res =
          await http.get(Uri.parse("http://127.0.0.1:8000/api/AttendanceQr"));
      if (res.statusCode == 200) {
        setState(() {});
        qrStr = jsonDecode(res.body)['qrstr'];
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Connection Problem")));
      }
    } catch (e) {
      print(e);
    }
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Spacer(),
            Column(
              children: [
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: numOfMembers == -1
                      ? CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                              child: Column(
                            children: [
                              Text(
                                "Total members : ",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2B2B2B)),
                              ),
                              Text(numOfMembers.toString(),style: TextStyle(
                        fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B2B2B)),
                    ),
                            ],
                          )),
                        ),
                ),
                Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: qrStr == ""
                      ? CircularProgressIndicator()
                      : Container(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "  Attendance QR",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      color: Color(0xFF2B2B2B)),
                                ),
                                QrImageView(
                                  data: qrStr,
                                  version: QrVersions.auto,
                                  size: 200,
                                ),
                              ],
                            ),
                          ),
                        ),
                ),
                Spacer(),
              ],
            ),
            Spacer(),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(12)),
              width: 500,
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "  Calender",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B2B2B)),
                    ),
                    TableCalendar(
                      firstDay: DateTime.utc(2010, 10, 16),
                      lastDay: DateTime.utc(2030, 3, 14),
                      focusedDay: DateTime.now(),
                      calendarFormat: _calendarFormat,
                      selectedDayPredicate: (day) {
                        return isSameDay(_selectedDay, day);
                      },
                      onDaySelected: (selectedDay, focusedDay) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay =
                              focusedDay; // update `_focusedDay` here as well
                        });
                      },
                      onFormatChanged: (format) {
                        if (_calendarFormat != format) {
                          setState(() {
                            _calendarFormat = format;
                          });
                        }
                      },
                      onPageChanged: (focusedDay) {
                        _focusedDay = focusedDay;
                      },
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
