import 'package:assignment/utils/widgets/customText.dart';
import 'package:flutter/material.dart';

class PaymentView extends StatelessWidget {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back , color: Colors.green,),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
        title: CustomText(text: 'Payment',color: Colors.green,fontSize: 20,),
      ),

      body: Center(child:Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: CustomText(
          textAlign: TextAlign.center,
          maxLines: 2,
          text: 'Here We complete payment operation',fontSize: 20,),
      ),),
    );
  }
}
