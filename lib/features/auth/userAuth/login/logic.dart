

import 'dart:developer';

import 'package:assignment/features/auth/userAuth/login/states.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../utils/internetConnection.dart';
import '../../../../utils/widgets/customSnakBAr.dart';


class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> signIn(String email, String password, BuildContext context, dynamic scaffoldMessenger) async {
    final connectivityProvider = Provider.of<ConnectivityProvider>(context, listen: false);
    if (connectivityProvider.isConnected && connectivityProvider.hasInternetAccess) {
      emit(LoginLoading());
      try {
        print(email + password);
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        emit(LoginSuccess(userCredential)); // Emit success state
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'user-not-found') {
          message = 'Email not found, please create an account.';
        } else if (e.code == 'wrong-password') {
          message = 'Incorrect password for this user.';
        } else {
          message = 'Email not found or password is incorrect.';
        }
        emit(LoginFailure(message)); // Emit failure state with message
      } catch (e) {
        emit(LoginFailure('An unexpected error occurred. Please try again.')); // Emit general failure state
      }
    } else {
      MySanckBar.snackBar("You are not connected to the internet, please check your connection.", scaffoldMessenger);
    }
  }
}


