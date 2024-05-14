import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:gymmanagementsystem/pages/attendance_details.dart';
import 'package:gymmanagementsystem/pages/attendance_qr.dart';
import 'package:gymmanagementsystem/pages/change_password.dart';
import "package:gymmanagementsystem/pages/dashboard.dart";
import 'package:gymmanagementsystem/pages/login_page.dart';
import 'package:gymmanagementsystem/pages/register_member.dart';
import 'package:gymmanagementsystem/pages/member_pages/member_details.dart';
import 'package:gymmanagementsystem/pages/create_staff_acc.dart';
import 'package:gymmanagementsystem/user_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextStyle drawerTextStyle=TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.normal);
  List<String> heading = [
    "Dashboard",
    "Attendance QR",
    "Attendance Detail",
    "Members",
    "Register Member",
    "New Staff",
    "Change Password",
  ];
  List<Widget> pages = [
    Dashboard(),
    AttendanceQr(),
    AttendanceDetails(),
    MemberDetails(),
    RegisterMember(),
    CreateStaffAcc(),
    ChangePassword()
  ];
  @override
  Widget build(BuildContext context) {
    int selected =
        Provider.of<UserProvider>(context, listen: false).getCurrentPage();
    String user = Provider.of<UserProvider>(context, listen: false).getUser();
    return SafeArea(
      child: Scaffold(
        body: Row(
          children: [
            Container(
              width: 226,
              child: Drawer(
                  backgroundColor: Color(0xFF1A1363),
                  shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                  child: ListView(
                    
                    children: [
                      DrawerHeader(
                        child: Text("Welcome ${user}",style: drawerTextStyle,),
                      ),
                      ListTile(
                        leading: Icon(Icons.dashboard,color: Colors.white,),
                        title: Text("Dashboard",style: drawerTextStyle,),
                        onTap: () {
                          setState(() {});
                          Provider.of<UserProvider>(context, listen: false)
                              .setCurrentPage(0);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.qr_code,color: Colors.white,),
                        title: Text("Attendance QR",style: drawerTextStyle,),
                        onTap: () {
                          setState(() {});
                          Provider.of<UserProvider>(context, listen: false)
                              .setCurrentPage(1);
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.assignment,color: Colors.white,),
                        title: Text("Attendance Details",style: drawerTextStyle,),
                        onTap: () {
                          setState(() {});
                          Provider.of<UserProvider>(context, listen: false)
                              .setCurrentPage(2);
                        },
                      ),
                      ExpansionTile(
                        leading: Icon(Icons.people,color: Colors.white,),
                        title: Text("Member",style: drawerTextStyle,),
                        children: [
                          ListTile(
                            leading: Icon(Icons.assignment_ind,color: Colors.white,),
                            title: Text("Members detail",style: drawerTextStyle,),
                            onTap: () {
                              setState(() {});
                              Provider.of<UserProvider>(context, listen: false)
                                  .setCurrentPage(3);
                            },
                          ),
                          ListTile(
                            leading: Icon(Icons.person_add,color: Colors.white,),
                            title: Text("Register new member",style: drawerTextStyle,),
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
                      Visibility(
                        visible: user == "Admin",
                        child: ListTile(
                          title: Text("New Staff",style: drawerTextStyle,),
                          onTap: () {
                            setState(
                              () {
                                Provider.of<UserProvider>(context,
                                        listen: false)
                                    .setCurrentPage(5);
                              },
                            );
                          },
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.password,color: Colors.white,),
                        title: Text("Change Password",style: drawerTextStyle,),
                        onTap: () {
                          setState(() {
                            Provider.of<UserProvider>(context, listen: false)
                                .setCurrentPage(6);
                          });
                        },
                      ),
                    ],
                  )),
            ),
            Expanded(
                child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(heading[selected]),
                actions: [
                  Text("Logout"),
                  GestureDetector(
                    onTap:(){Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) {
                                              return LoginPage();
                                            },
                                          ),
                                        );},
                    child: const MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.exit_to_app),
                        )),
                  )
                ],
              ),
              body: pages[selected],
            ))
          ],
        ),
      ),
    );
  }
}
