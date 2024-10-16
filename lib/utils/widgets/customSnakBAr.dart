import 'package:flutter/material.dart';
class MySanckBar {
  static snackBar( String message , var scaffoldMessenger,{Duration duration = const Duration(microseconds: 300)}){
    scaffoldMessenger.currentState!.hideCurrentSnackBar();
    scaffoldMessenger.currentState!.showSnackBar( SnackBar(
        backgroundColor: Color(0xffFFD700),
        behavior: SnackBarBehavior.floating,
        content: Text(message , style: TextStyle(
            color: Colors.black
        ),)));

  }

}