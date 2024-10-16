

import 'package:flutter/material.dart';

import '../consts.dart';
import 'customText.dart';


class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key, required this.text, this.onPressed,this.backgroundColor=primaryColor, this.textColor=Colors.white
  });
  final String text ;
  final Color backgroundColor;
  final  Function()? onPressed;
  final textColor ;
  @override
  Widget build(BuildContext context) {
    return Padding(

      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: backgroundColor,
              padding: EdgeInsets.symmetric(vertical: 8)
          ),
          onPressed: onPressed, child: CustomText(
        height: 1.4,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        text: text,

        color: textColor,
      )),
    );
  }
}
