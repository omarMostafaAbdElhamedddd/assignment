
import 'package:assignment/features/auth/userAuth/login/liginView.dart';
import 'package:assignment/utils/widgets/customText.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        },icon: Icon(Icons.arrow_back , color: Colors.green,),),
        elevation: 1,
        backgroundColor: Colors.white,
        title: CustomText(text: 'Profile ',fontSize: 20,color:Colors.green,),
      ),

      body: FirebaseAuth.instance.currentUser?.uid !=null ?  Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [



                 CircleAvatar(
                   radius: 80,
                     backgroundColor: Colors.grey.shade300,
                     child: Icon(

                       Icons.perm_identity_rounded , size: 100,color: Colors.green,)),
                  SizedBox(height: 30,),
                  CustomText(text: 'Your account', fontSize: 20,),
                  SizedBox(height: 8,),
                  CustomText(text: FirebaseAuth.instance.currentUser!.email.toString()),
          ],
        ),
      ) : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomText(
              textAlign: TextAlign.center,
              text: 'You do not have an account,please create account' , maxLines: 3,fontSize: 18,),
           SizedBox(height: 20,),

            GestureDetector(
              onTap: (){
                Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, an,sc){
                  return LoginView();
                }));
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 100),
                padding: EdgeInsets.symmetric(horizontal:  30 , vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.green),
                  ),
                  child: Center(child: CustomText(text: 'Login' , fontSize: 18,color: Colors.green,))),
            )
          ],
        ),
      ),
    );
  }
}
