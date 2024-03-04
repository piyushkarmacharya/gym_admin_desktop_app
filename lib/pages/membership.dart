import 'package:flutter/material.dart';

class Membership extends StatefulWidget{

  State<Membership> createState()=>_MembershipState();
}

class _MembershipState extends State<Membership>{
  final _formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:Form(
        key:_formkey,
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                label: Text("Enter"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
