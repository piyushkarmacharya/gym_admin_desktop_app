import 'package:flutter/material.dart';

//For state management this class is created
class UserProvider extends ChangeNotifier{
   int currentPage=0;
  
  void setCurrentPage(int pageId){
    this.currentPage=pageId;
    notifyListeners();
  }
  int getCurrentPage(){
    return currentPage;
  }
  
  String user="Admin";
  int userId=0;
  void setUser(String user){
    this.user=user;
    notifyListeners();
  }
  String getUser(){
    return user;
  }

  void setUserId(int userId){
    this.userId=userId;
    notifyListeners();
  }
  int getUserId(){
    return userId;
  }


}