import "package:flutter/material.dart";
import "package:gymmanagementsystem/pages/login_page.dart";
import "package:gymmanagementsystem/pages/member_details.dart";
import 'package:gymmanagementsystem/pages/register_member.dart';
import "package:gymmanagementsystem/user_provider.dart";
import "package:provider/provider.dart";


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context)=>UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: TextTheme(
            bodySmall: TextStyle(
              color: Colors.red[900],
            )
          ),
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.blueGrey,
          ),
          fontFamily: 'PlayFairDisplay',
          useMaterial3: true,
        ),
        home: MemberDetails(),
      ),
    );
  }
}
