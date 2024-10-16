import 'package:assignment/features/cart/data/cartModel.dart';
import 'package:assignment/features/home/data/productModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../../../../utils/internetConnection.dart';
import '../../../../utils/widgets/customSnakBAr.dart';



class AddProductToFavoriteCubit extends Cubit<AddProductToFavoriteStates> {
  AddProductToFavoriteCubit() : super((InitAddProductToFavoriteState()));

  Future<void> addToCart(ProductModel product , BuildContext context,dynamic scaffoldMessenger) async {
    emit(LoadingAddProductToFavoriteState());
    final connectivityProvider = Provider.of<ConnectivityProvider>(context,listen: false);
    if (connectivityProvider.isConnected && connectivityProvider.hasInternetAccess ) {
      try {
        await FirebaseFirestore.instance.collection(FirebaseAuth.instance.currentUser!.uid).doc().set(product.toMap());
        emit(SuccessAddProductToFavoriteState());
      } catch (e) {
        emit(FailureAddProductToFavoriteState());
      }
    }else{
      emit(FailureAddProductToFavoriteState());
      MySanckBar.snackBar("You are not connected to the internet,try again", scaffoldMessenger);
    }
  }
}






abstract class AddProductToFavoriteStates {}

class InitAddProductToFavoriteState extends AddProductToFavoriteStates {}
class SuccessAddProductToFavoriteState extends AddProductToFavoriteStates {}
class LoadingAddProductToFavoriteState extends AddProductToFavoriteStates {}
class FailureAddProductToFavoriteState extends AddProductToFavoriteStates {}

