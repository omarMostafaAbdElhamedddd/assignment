
import 'package:flutter/cupertino.dart';

class CustomVerticalSizeBox extends StatelessWidget {
  const CustomVerticalSizeBox({super.key , this.padding=1});
  final double padding ;
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      height:SizeConfig.defaultSize!*padding,
    );
  }
}

class CustomHorizentalSizeBox extends StatelessWidget {
  const CustomHorizentalSizeBox({super.key , this.padding=1});
  final double padding ;
  @override
  Widget build(BuildContext context) {
    return  SizedBox(
      width:SizeConfig.defaultSize!*padding,
    );
  }
}

class SizeConfig{
  static double? screenWidth;
  static double ? screenHeight ;
  static Orientation ? orientation;
  static double ? defaultSize;

  void init(BuildContext context){
    screenWidth=MediaQuery.of(context).size.width;
    screenHeight=MediaQuery.of(context).size.height;
    defaultSize= orientation==Orientation.landscape ?
    screenWidth!*0.1 : screenHeight!*0.05;

  }
}