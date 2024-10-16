import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/widgets/customText.dart';

class NoAccount extends StatelessWidget {
  const NoAccount({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomText(text: 'You do not have account, please login to continue' , color: Colors.green,fontSize: 20,),
        SizedBox(height: 30,),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 20 , vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.green),

          ),
          child: Center(child: CustomText(text: 'Login',),),
        ),
      ],
    );
  }
}
