import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    fetchData();
    getQrString();
  }

  void _showMessage(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
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
        _showMessage("Connection Problem");
      }
    } catch (e) {
      debugPrint(e.toString());
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
        _showMessage("Connection Problem");
      }
    } catch (e) {
      _showMessage(e.toString());
    }
  }

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime? _selectedDay;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Spacer(),
            Column(
              children: [
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: numOfMembers == -1
                      ? const CircularProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Center(
                              child: Column(
                            children: [
                              const Text(
                                "Total members : ",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2B2B2B)),
                              ),
                              Text(
                                numOfMembers.toString(),
                                style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF2B2B2B)),
                              ),
                            ],
                          )),
                        ),
                ),
                const Spacer(),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12)),
                  child: qrStr == ""
                      ? const CircularProgressIndicator()
                      : SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
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
                const Spacer(),
              ],
            ),
            const Spacer(),
            Visibility(
              visible: MediaQuery.of(context).size.width > 1055,
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                width: 500,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
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
                            // update `_focusedDay` here as well
                          });
                        },
                        onFormatChanged: (format) {
                          if (_calendarFormat != format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          }
                        },
                        onPageChanged: (focusedDay) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
