import 'package:flutter/material.dart';

//For state management this class is created
class UserProvider extends ChangeNotifier{
  
  String user="Admin";
  void setUser(String user){
    this.user=user;
    notifyListeners();
  }
  String getUser(){
    return user;
  }


}