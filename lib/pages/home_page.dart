import "package:flutter/material.dart";
import "package:gymmanagementsystem/pages/dashboard.dart";
import "package:gymmanagementsystem/pages/members.dart";
import 'package:gymmanagementsystem/pages/register_member.dart';
import "package:gymmanagementsystem/pages/trainers.dart";

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int selected = 0;
  List<String> heading = ["Dashboard", "Trainers", "Members", "Registration"];
  List<Widget> pages = [Dashboard(), Trainers(), Members(), RegisterMember()];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(heading[selected]),
          actions: [
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
            DrawerHeader(child: Text("Heading")),
            ListTile(
              title: Text("Dashboard"),
              onTap: () {
                setState(() {});
                selected = 0;
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Trainers"),
              onTap: () {
                setState(() {});
                selected = 1;
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Members"),
              onTap: () {
                setState(() {});
                selected = 2;
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              title: Text("Registration"),
              onTap: () {
                setState(() {
                  selected = 3;
                  Navigator.of(context).pop();
                });
              },
            ),
            ExpansionTile(
              title: Text("sub"),
              children: [
                ListTile(
                  title: Text("okok"),
                ),
                ListTile(
                  title: Text("okok"),
                ),
              ],
            )
          ],
        )),
        body: pages[selected],
      ),
    );
  }
}
