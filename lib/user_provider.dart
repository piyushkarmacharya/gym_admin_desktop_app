import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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