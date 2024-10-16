
import 'package:assignment/features/auth/userAuth/signUp/presentation/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';


import '../../../../../utils/consts.dart';
import '../../../../../utils/responsiveSise.dart';
import '../../../../../utils/widgets/cusromBuildTextFormField.dart';
import '../../../../../utils/widgets/customButton.dart';
import '../../../../../utils/widgets/customSnakBAr.dart';
import '../../../../../utils/widgets/customText.dart';
import '../../login/liginView.dart';
import 'logic.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  String? email;
  String? password;
  String? name;
  bool secureText = true;

  GlobalKey<FormState> formKey = GlobalKey();
  GlobalKey<ScaffoldMessengerState> scaffoldMessenger = GlobalKey();

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
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Image.asset(
                              logo,
                              height: SizeConfig.screenHeight! * .18,
                            ),
                            SizedBox(height: 16,),
                            CustomText(
                              textAlign: TextAlign.center,
                              text: 'Create a New Account',
                              color: Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.w600,
                            ),
                            SizedBox(height: 40),
                            CustomText(text: 'Enter your email', fontSize: 16),
                            SizedBox(height: 4),

                            TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              cursorColor: primaryColor,
                              onChanged: (data) {
                                email = data;
                              },
                              validator: (data) {
                                if (data == null || data.isEmpty) {
                                  return 'Please enter your email';
                                }
                                final emailRegex = RegExp(
                                  r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
                                );
                                if (!emailRegex.hasMatch(data)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              decoration: buildInputDecoration(
                                  hintText: 'Enter your email'),
                            ),
                            SizedBox(height: 15),
                            CustomText(text: 'Enter your password', fontSize: 16),
                            SizedBox(height: 4),
                            TextFormField(
                              cursorColor: primaryColor,
                              onChanged: (data) {
                                password = data;
                              },
                              validator: (data) {
                                if (data == null || data.isEmpty) {
                                  return 'Please enter a password';
                                }
                                if (data.length < 8) {
                                  return 'Password must be at least 8 characters long';
                                }
                                final passwordRegex = RegExp(
                                    r'^(?=.*[a-zA-Z])(?=.*\d).{8,}$');
                                if (!passwordRegex.hasMatch(data)) {
                                  return 'Password must contain letters and numbers';
                                }
                                return null;
                              },
                              decoration: buildInputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          secureText = !secureText;
                                        });
                                      },
                                      icon: secureText
                                          ? Icon(
                                        Icons.visibility_outlined,
                                        color: primaryColor,
                                      )
                                          : Icon(
                                        Icons.visibility_off_outlined,
                                        color: primaryColor,
                                      )),
                                  hintText: 'Enter your password'),
                              obscureText: secureText, // Hide password input
                            ),
                            SizedBox(height: 15),
                            CustomText(text: 'Confirm your password', fontSize: 16),
                            SizedBox(height: 4),
                            TextFormField(
                              cursorColor: primaryColor,
                              validator: (data) {
                                if (data == null || data.isEmpty) {
                                  return 'Please confirm your password';
                                } else if (password != data) {
                                  return 'Passwords do not match';
                                } else {
                                  return null;
                                }
                              },
                              decoration: buildInputDecoration(
                                  suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          secureText = !secureText;
                                        });
                                      },
                                      icon: secureText
                                          ? Icon(
                                        Icons.visibility_outlined,
                                        color: primaryColor,
                                      )
                                          : Icon(
                                        Icons.visibility_off_outlined,
                                        color: primaryColor,
                                      )),
                                  hintText: 'Confirm your password'),
                              obscureText: secureText, // Hide password input
                            ),

                            SizedBox(height: 50),
                            BlocProvider(
                              create: (context) => SignUpCubit(),
                              child: BlocConsumer<SignUpCubit, SignUpStates>(
                                listener: (context, state) {
                                  if (state is SignUpFailure) {
                                    MySanckBar.snackBar(
                                        state.errorMessage, scaffoldMessenger);
                                  } else if (state is SignUpSuccess) {
                                    Navigator.pushReplacement(context,
                                        PageRouteBuilder(
                                            pageBuilder: (context, an, sc) {
                                              return LoginView();
                                            }));
                                  }
                                },
                                builder: (context, state) {
                           {
                                    return CustomButton(
                                      text: 'Sign Up',
                                      onPressed: state is SignUpLoading
                                          ? null
                                          : () async {
                                        FocusScope.of(context).unfocus();
                                        if (formKey.currentState!
                                            .validate()) {
                                          context
                                              .read<SignUpCubit>()
                                              .signUp(
                                              email!,
                                              password!,
                                              context,
                                              scaffoldMessenger);
                                          final storage =
                                          FlutterSecureStorage();
                                          await storage.write(
                                              key: 'token', value: '2');
                                        } else {
                                          print('Sign up failed');
                                        }
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                            SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CustomText(
                                  text: 'Already have an account?',
                                  fontSize: 16,
                                ),
                                GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);
                                    },
                                    child: CustomText(
                                      decoration: TextDecoration.underline,
                                      text: 'Login',
                                      fontWeight: FontWeight.w600,
                                    )),
                              ],
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

