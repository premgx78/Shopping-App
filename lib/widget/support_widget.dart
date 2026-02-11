import 'package:flutter/material.dart';

class AppWidget{

  static TextStyle boldTextFieldStyle(){
    return TextStyle(
        color: Colors.black,
        fontSize: 30.0,
        fontWeight: FontWeight.bold);
  }

  static TextStyle lightTextFieldStyle(){
    return TextStyle(
        color: Colors.grey,
        fontSize: 20, fontWeight:
        FontWeight.bold);
  }

  static TextStyle semiBoldTextFieldStyle(){
    return TextStyle(
        color: Colors.black,
        fontSize: 22.0,
        fontWeight: FontWeight.bold);
  }

  static TextStyle normalTextFieldStyle(){
    return TextStyle(
      color: Colors.black,
      fontSize: 18.0,
      fontWeight: FontWeight.w400);
  }
}