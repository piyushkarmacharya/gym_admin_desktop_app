import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/widgets.dart";
import "package:intl/intl.dart";
import 'package:http/http.dart' as http;
import "dart:convert";

class AttendanceDetails extends StatefulWidget {
  const AttendanceDetails({super.key});

  @override
  State<AttendanceDetails> createState() => _AttendanceDetailsState();
}

class _AttendanceDetailsState extends State<AttendanceDetails> {
  List attendanceDetails=[];
  String _formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  Future<void> _selectDate(BuildContext context) async {
    try{
      final DateTime? temp = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1930),
        lastDate: DateTime.now());
    if (temp != null) {
      setState(() {
        DateTime _selectedDate = temp;
        _formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
        _getAttendanceDetails();
      });
    }
    }catch(e){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()),),);
    }
    
  }
  TableRow getDataRow(int i) {
    TextStyle rowTextStyle=TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.normal);
    // DateTime temp=DateFormat("yyyy-MM-dd HH:mm:ss").parse(attendanceDetails[i]['created_at']==null?"${attendanceDetails[i]['date']} 00:00:00":attendanceDetails[i]['created_at'].toString());
    String time=attendanceDetails[i]['time']==null?"00:00:00":attendanceDetails[i]['time'].toString();
    return TableRow(
      children: [
        TableCell(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(attendanceDetails[i]['mid'].toString(),style: rowTextStyle,),
        )),
        TableCell(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(attendanceDetails[i]['name'].toString(),style: rowTextStyle,),
        )),
        TableCell(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(attendanceDetails[i]['contact_number'].toString(),style: rowTextStyle,),
        )),
        TableCell(child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(time,style: rowTextStyle,),
        ),),
      ],
    );
  }
  Future<void> _getAttendanceDetails() async{
    try{
      final res = await http.get(Uri.parse("http://127.0.0.1:8000/api/attendance/info/$_formattedDate"));
    if (res.statusCode == 200) {
      List data = jsonDecode(res.body);
      setState(() {
        attendanceDetails=data;
      });
      
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Connection problem"),),);
    }
    }catch(e){
           print(e.toString());

    }
      
  }
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAttendanceDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          height: 0.7*MediaQuery.of(context).size.height,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFF77749B),
          ),
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Attendance Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Color(0xFFFFFADF),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "$_formattedDate  ",
                      style: TextStyle(color: Colors.white),
                    ),
                    Container(
                      height: 30,
                      width: 151,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Color(0xFF5D57A3)),
                        ),
                        onPressed: () {
                          setState(() {
                            _selectDate(context);
                          });
                        },
                        child: Text("Select Date",style: TextStyle(color: Colors.white),),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.white,
                      ),
                      onPressed: () async{
                        setState(() {
                          _getAttendanceDetails();
                        });
                        
                      },
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16,16,16,0),
                    child: Table(children: [
                            TableRow(
                              children: [
                                TableCell(child: Text('Member ID',style: TextStyle(color: Color(0xFFFFFADF),fontSize: 14,fontWeight: FontWeight.bold,),)),
                                TableCell(child: Text('Name',style: TextStyle(color: Color(0xFFFFFADF),fontSize: 14,fontWeight: FontWeight.bold,),)),
                                TableCell(child: Text('Contact',style: TextStyle(color: Color(0xFFFFFADF),fontSize: 14,fontWeight: FontWeight.bold,),)),
                                TableCell(child: Text('Attendance Time',style: TextStyle(color: Color(0xFFFFFADF),fontSize: 14,fontWeight: FontWeight.bold,),)),
                                
                              ],
                            ),]),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Table(
                        children: [
                          ...List.generate(attendanceDetails.length, (index) => getDataRow(index))
                          // Add more rows as needed
                        ],
                      ),
                    ),
                  ),
                ),
                Text("Total presence : ${attendanceDetails.length}",style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.normal),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
