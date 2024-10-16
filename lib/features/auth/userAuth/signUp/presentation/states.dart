import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// Define login states
abstract class SignUpStates {}

class SignUpInitial extends SignUpStates {}

class SignUpLoading extends SignUpStates {}

class SignUpSuccess extends SignUpStates {
  final UserCredential userCredential;

  SignUpSuccess(this.userCredential);
}

class SignUpFailure extends SignUpStates {
  final String errorMessage;

  SignUpFailure(this.errorMessage);
}
