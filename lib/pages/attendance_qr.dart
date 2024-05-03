import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:qr_flutter/qr_flutter.dart";

class AttendanceQr extends StatefulWidget {
  const AttendanceQr({super.key});
  State<AttendanceQr> createState() => _AttendanceQrState();
}

class _AttendanceQrState extends State<AttendanceQr> {
  String str = "";
  TextEditingController ctr = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Scaffold(
              body: Column(
            children: [
              Spacer(),
              Expanded(
                  flex: 3,
                  child: Container(
                    child: QrImageView(data: str),
                  )),
              Spacer(),
              Expanded(
                flex: 1,
                child: Row(
                  children: [
                    Spacer(flex: 3,),
                    Expanded(
                      flex: 2,
                      child: TextField(
                        decoration: InputDecoration(
                          label:Text("Enter a string"),
                          contentPadding:
                              EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        controller: ctr,
                      ),
                    ),
                    Spacer(flex: 1,),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            str=ctr.text;
                          });
                          
                        },
                        child: Text("Generate"),
                      ),
                    ),
                    Spacer(flex: 3,),
                  ],
                ),
              ),
              Spacer(),
            ],
          )),
        ),
      ),
    );
  }
}
