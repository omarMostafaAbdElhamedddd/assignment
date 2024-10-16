


import 'dart:developer';


import 'package:assignment/features/auth/userAuth/signUp/presentation/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/internetConnection.dart';
import '../../../../../utils/widgets/customSnakBAr.dart';
import '../data/userModel.dart';



class SignUpCubit extends Cubit<SignUpStates> {
  SignUpCubit() : super(SignUpInitial());

  Future<void> signUp(String email, String password, BuildContext context, dynamic scaffoldMessenger) async {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
    if (connectivityProvider.isConnected && connectivityProvider.hasInternetAccess) {
      emit(SignUpLoading()); // Emit loading state
      try {
        print(email + password);
        // Attempt to sign up
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // await FirebaseFirestore.instance.collection('users').doc().set(UserModell(email: email, password: password).dataToMapp());

        emit(SignUpSuccess(userCredential)); // Emit success state
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'email-already-in-use') {
          message = 'The email address is already in use by another account.';
        } else if (e.code == 'invalid-email') {
          message = 'The email address is invalid.';
        } else if (e.code == 'weak-password') {
          message = 'The password is too weak.';
        } else {
          message = 'An error occurred during registration. Please try again.';
        }
        emit(SignUpFailure(message)); // Emit failure state with specific error message
      } catch (e) {
        emit(SignUpFailure('An unexpected error occurred. Please try again.')); // Emit general failure state
      }
    } else {
      MySanckBar.snackBar("You are not connected to the internet, please ensure internet connectivity", scaffoldMessenger);
    }
  }
}



