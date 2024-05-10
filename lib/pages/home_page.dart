import "package:flutter/material.dart";
import 'package:flutter/widgets.dart';
import 'package:gymmanagementsystem/pages/attendance_qr.dart';
import 'package:gymmanagementsystem/pages/change_password.dart';
import "package:gymmanagementsystem/pages/dashboard.dart";
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
  int selected = 0;
  List<String> heading = ["Dashboard", "Attendance QR", "Members", "Register Member","New Staff","Change Password"];
  List<Widget> pages = [Dashboard(), AttendanceQr(), MemberDetails(), RegisterMember(),CreateStaffAcc(),ChangePassword()];
  @override
  Widget build(BuildContext context) {
    String user=Provider.of<UserProvider>(context,listen: false).getUser();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          
          centerTitle: true,
          title: Text(heading[selected]),
          actions: [Text("Logout"),
            GestureDetector(
              child: MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.exit_to_app),
                  )),
              onTap: Navigator.of(context).pop,
            )
          ],
        ),
        drawer: Drawer(
            child: ListView(
          children: [
            DrawerHeader(child: Text("Welcome ${user}"),),
            ListTile(
              title: Text("Dashboard"),
              onTap: () {
                setState(() {});
                selected = 0;
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Attendance QR"),
              onTap: () {
                setState(() {});
                selected = 1;
                Navigator.of(context).pop();
              },
            ),
            ExpansionTile(
              title: Text("Member"),
              children: [
                ListTile(
              title: Text("Members detail"),
              onTap: () {
                setState(() {});
                selected = 2;
                Navigator.of(context).pop();
              },
            ),
                ListTile(
              title: Text("Register new member"),
              onTap: () {
                setState(() {
                  selected = 3;
                  Navigator.of(context).pop();
                });
              },
            ),
              ],
            ),
            
            
            
            Visibility(
              visible: user=="Admin",
              child: ListTile(
                title: Text("New Staff"),
                onTap: () {
                  setState(() {
                    selected = 4;
                    Navigator.of(context).pop();
                  });
                },
              ),
            ),
            ListTile(
              title: Text("Change Password"),
              onTap: () {
                setState(() {
                  selected = 5;
                  Navigator.of(context).pop();
                });
              },
            ),
            
          ],
        )),
        body: pages[selected],
      ),
    );
  }
}
