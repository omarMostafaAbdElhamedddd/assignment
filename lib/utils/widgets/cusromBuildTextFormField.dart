import 'package:flutter/material.dart';

InputDecoration buildInputDecoration({required String hintText,Widget? suffixIcon}) {
  return InputDecoration(
      suffixIcon: suffixIcon,
      alignLabelWithHint: true, // Ensures the label aligns with the center if any
      isDense: true, // Makes the content denser


      contentPadding: EdgeInsets.symmetric(vertical: 16 , horizontal: 16),


      hintStyle: TextStyle(fontSize: 14 , fontFamily: 'JF Flat'),

      border: InputBorder.none,

      // Add border radius using enabledBorder and focusedBorder
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        // Adjust the radius as needed
        borderSide: BorderSide(
            color:
            Colors.transparent), // Invisible border
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        // Same radius for focused state
        borderSide: BorderSide(
            color:
            Colors.transparent), // Invisible border
      ),
      fillColor: Colors.grey.shade200,
      filled: true,
      hintText: hintText);
}