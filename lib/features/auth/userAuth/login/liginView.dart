
import 'package:assignment/features/auth/userAuth/login/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../../utils/consts.dart';
import '../../../../utils/responsiveSise.dart';
import '../../../../utils/widgets/cusromBuildTextFormField.dart';
import '../../../../utils/widgets/customButton.dart';
import '../../../../utils/widgets/customSnakBAr.dart';
import '../../../../utils/widgets/customText.dart';
import '../../../home/presenation/view/homeView.dart';
import '../signUp/presentation/signUpView.dart';
import 'logic.dart';
class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  String? email;
  String? password;
  bool secureText =  true;

  GlobalKey<ScaffoldMessengerState> scaffoldMessenger = GlobalKey();
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ScaffoldMessenger(
      key: scaffoldMessenger,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,

                children: [
                CustomVerticalSizeBox(),


                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(logo, height: SizeConfig.screenHeight! * .22,),
                            SizedBox(height: 20,),

                            CustomText(
                              textAlign: TextAlign.center,
                              text: 'Login',
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 50),
                            CustomText(text: 'Enter your email address', fontSize: 16),
                            SizedBox(height: 4),
                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: primaryColor,
                              onChanged: (data) {
                                email = data;
                              },
                              validator: (data) {
                                if (data == null || data.trim().isEmpty) {
                                  return 'Please enter an email address';
                                }
                                // Regular expression for email validation
                                final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                );
                                // Trim the input to remove any leading/trailing spaces
                                final trimmedData = data.trim();

                                if (!emailRegex.hasMatch(trimmedData)) {
                                  return 'Please enter a valid email address';
                                }

                                return null;
                              },

                              decoration: buildInputDecoration(hintText: 'Enter your email'),
                            ),

                            SizedBox(height: 30),

                            CustomText(text: 'Enter your password', fontSize: 16),
                            SizedBox(height: 4),
                            TextFormField(
                              cursorColor: primaryColor,
                              onChanged: (data) {
                                password = data;
                              },
                              validator: (data) {
                                if (data == null || data.isEmpty) {
                                  return 'Please enter your password';
                                }
                                // Check if password is at least 8 characters long
                                if (data.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                // Regular expression to check for at least one letter and one number
                                final passwordRegex = RegExp(
                                    r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
                                if (!passwordRegex.hasMatch(data)) {
                                  return 'Password must contain both letters and numbers';
                                }
                                return null;
                              },
                              decoration: buildInputDecoration(
                                  suffixIcon: IconButton(onPressed:(){
                                    setState(() {
                                      secureText = !secureText;
                                    });
                                  }, icon: secureText ?  Icon(Icons.visibility_outlined , color: primaryColor,)  : Icon(Icons.visibility_off_outlined , color: primaryColor,) ),
                                  hintText: 'Enter your password'),
                              obscureText: secureText, // Hide password input
                            ),

                            SizedBox(height: 50),

                            BlocProvider(
                              create: (context) => LoginCubit(),
                              child: BlocConsumer<LoginCubit, LoginState>(
                                  listener: (context, state) {
                                    if (state is LoginFailure) {
                                      MySanckBar.snackBar(state.errorMessage, scaffoldMessenger);
                                    }
                                    if (state is LoginSuccess) {
                                      Navigator.pushReplacement(context, PageRouteBuilder(pageBuilder: (context, an, sc) {
                                        return HomeView();
                                      }));
                                    }
                                  },
                                  builder: (context, state) {
                                    return CustomButton(
                                      text: 'Login',
                                      onPressed: state is LoginLoading ? null : () async {
                                        FocusScope.of(context).unfocus();
                                        if (formKey.currentState!.validate()) {
                                          context.read<LoginCubit>().signIn(email!, password!, context , scaffoldMessenger);
                                          final storage = FlutterSecureStorage();
                                          await storage.write(key: 'token', value: '2');
                                        } else {
                                          print('Login failed');
                                        }
                                      },
                                    );
                                  }
                              ),
                            ),

                            SizedBox(height: 40),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(text:'Don\'t have an account?'),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.push(context, PageRouteBuilder(pageBuilder: (context, an, sc) {
                                        return SignUpView();
                                      }));
                                    },
                                    child: CustomText(text: 'Create an account',decoration: TextDecoration.underline,fontWeight: FontWeight.w600,)
                                ),
                              ],
                            ),
                            SizedBox(height: 40,),

                            InkWell(
                              onTap: (){
                                Navigator.push(context,PageRouteBuilder(pageBuilder: (context, an,sc){
                                  return HomeView();
                                }));
                              },
                              child: CustomText(
                                fontSize: 18,
                                color: Colors.green,
                                decoration: TextDecoration.underline,
                                  textAlign: TextAlign.center,
                                  text: 'Enter as Guest'),
                            ),
                            SizedBox(height: 30,),
                          ],
                        ),
                      ),
                    ),
                  )

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}


