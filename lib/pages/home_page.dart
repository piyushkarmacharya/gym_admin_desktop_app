import "package:flutter/material.dart";
import 'package:gymmanagementsystem/pages/attendance_details.dart';
import 'package:gymmanagementsystem/pages/attendance_qr.dart';
import 'package:gymmanagementsystem/pages/change_password.dart';
import "package:gymmanagementsystem/pages/dashboard.dart";
import 'package:gymmanagementsystem/pages/feedback_page.dart';
import 'package:gymmanagementsystem/pages/login_page.dart';
import 'package:gymmanagementsystem/pages/register_member.dart';
import 'package:gymmanagementsystem/pages/member_pages/member_details.dart';
import 'package:gymmanagementsystem/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle drawerTextStyle = const TextStyle(
      color: Colors.white, fontSize: 10, fontWeight: FontWeight.normal);
  List<String> heading = [
    "Dashboard",
    "Attendance QR",
    "Attendance Detail",
    "Members",
    "Register Member",
    "Change Password",
  ];
  List<Widget> pages = const [
    Dashboard(),
    AttendanceQr(),
    AttendanceDetails(),
    MemberDetails(),
    RegisterMember(),
    ChangePassword(),
    FeedbackPage()
  ];
  @override
  Widget build(BuildContext context) {
    int selected =
        Provider.of<UserProvider>(context, listen: false).getCurrentPage();
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            SizedBox(
              width: 226,
              child: Drawer(
                  backgroundColor: const Color(0xFF1A1363),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: ListView(
                    children: [
                      DrawerHeader(
                        child: Center(
                          child: Text(
                            "     Welcome\n ${Provider.of<UserProvider>(context, listen: false).getAdminName()}",
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.dashboard,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Dashboard",
                          style: drawerTextStyle,
                        ),
                        onTap: () {
                          setState(() {});
                          Provider.of<UserProvider>(context, listen: false)
                              .setCurrentPage(0);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.qr_code,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Attendance QR",
                          style: drawerTextStyle,
                        ),
                        onTap: () {
                          setState(() {});
                          Provider.of<UserProvider>(context, listen: false)
                              .setCurrentPage(1);
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.assignment,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Attendance Details",
                          style: drawerTextStyle,
                        ),
                        onTap: () {
                          setState(() {});
                          Provider.of<UserProvider>(context, listen: false)
                              .setCurrentPage(2);
                        },
                      ),
                      ExpansionTile(
                        leading: const Icon(
                          Icons.people,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Member",
                          style: drawerTextStyle,
                        ),
                        children: [
                          ListTile(
                            leading: const Icon(
                              Icons.assignment_ind,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Members detail",
                              style: drawerTextStyle,
                            ),
                            onTap: () {
                              setState(() {});
                              Provider.of<UserProvider>(context, listen: false)
                                  .setCurrentPage(3);
                            },
                          ),
                          ListTile(
                            leading: const Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                            title: Text(
                              "Register new member",
                              style: drawerTextStyle,
                            ),
                            onTap: () {
                              setState(() {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .setCurrentPage(4);
                              });
                            },
                          ),
                        ],
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.password,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Change Password",
                          style: drawerTextStyle,
                        ),
                        onTap: () {
                          setState(() {
                            Provider.of<UserProvider>(context, listen: false)
                                .setCurrentPage(5);
                          });
                        },
                      ),
                      ListTile(
                        leading: const Icon(
                          Icons.feedback,
                          color: Colors.white,
                        ),
                        title: Text(
                          "Feedbacks",
                          style: drawerTextStyle,
                        ),
                        onTap: () {
                          setState(() {
                            Provider.of<UserProvider>(context, listen: false)
                                .setCurrentPage(6);
                          });
                        },
                      ),
                      SizedBox(
                        height: 0.2 * MediaQuery.of(context).size.height,
                      ),
                    ],
                  )),
            ),
            Expanded(
                child: Scaffold(
              appBar: AppBar(
                actions: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) {
                              return const LoginPage();
                            },
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: const Color(0xFF1A1363),
                              borderRadius: BorderRadius.circular(24)),
                          child: const Padding(
                            padding: EdgeInsets.fromLTRB(10.0, 8, 10, 8),
                            child: Row(
                              children: [
                                Text(
                                  "Logout  ",
                                  style: TextStyle(color: Colors.white),
                                ),
                                Icon(
                                  Icons.logout,
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
                toolbarHeight: 111,
                centerTitle: true,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 78,
                      width: 111,
                      child: Image.asset(
                        "assets/images/logo.png",
                      ),
                    ),
                    Visibility(
                      visible: MediaQuery.of(context).size.width > 610,
                      child: const Text(
                        "CLUB\nDESPERADO",
                        style: TextStyle(
                            color: Color(0xFF1A1363),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ),
              body: pages[selected],
            ))
          ],
        ),
      ),
    );
  }
}
