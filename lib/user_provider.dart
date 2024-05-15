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
  
  int userId=0;
 

  void setUserId(int userId){
    this.userId=userId;
    notifyListeners();
  }
  int getUserId(){
    return userId;
  }


}