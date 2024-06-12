import "package:flutter/material.dart";
import "package:gymmanagementsystem/pages/attendance_details.dart";
import "package:gymmanagementsystem/pages/attendance_qr.dart";
import "package:gymmanagementsystem/pages/change_password.dart";
import "package:gymmanagementsystem/pages/feedbackPage.dart";
import "package:gymmanagementsystem/pages/home_page.dart";
import "package:gymmanagementsystem/pages/login_page.dart";
import "package:gymmanagementsystem/pages/try.dart";
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
      //ChangeNotifierProvider is used to manage state
      create: (context) => UserProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor:const Color(0xFFECE9E9),
          textTheme: TextTheme(
              bodySmall: TextStyle(
            color: Colors.red[900],
          )),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFFECE9E9),
          ),
          fontFamily: 'Poppins',
          useMaterial3: true,
        ),
        home:  const LoginPage(),
      ),
    );
  }
}
