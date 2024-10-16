import 'package:assignment/features/cart/data/cartModel.dart';
import 'package:assignment/features/home/data/productModel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:async';
import '../../../../utils/internetConnection.dart';
import '../../../../utils/widgets/customSnakBAr.dart';



class AddProductToCartCubit extends Cubit<AddProductToCartStates> {
  AddProductToCartCubit() : super((InitAddProductToCartState()));

  Future<void> addToCart(CartModel product , BuildContext context,dynamic scaffoldMessenger) async {
    emit(LoadingAddProductToCartState());
    final connectivityProvider = Provider.of<ConnectivityProvider>(context,listen: false);
    if (connectivityProvider.isConnected && connectivityProvider.hasInternetAccess ) {
      try {
        String cartId = await CreateNewCart.getBasketId();
        await FirebaseFirestore.instance.collection(cartId).doc().set(product.toMap());
        emit(SuccessAddProductToCartState());
      } catch (e) {
        emit(FailureAddProductToCartState());
      }
    }else{
      emit(FailureAddProductToCartState());
      MySanckBar.snackBar("You are not connected to the internet,try again", scaffoldMessenger);
    }
  }
}






abstract class AddProductToCartStates {}

class InitAddProductToCartState extends AddProductToCartStates {}
class SuccessAddProductToCartState extends AddProductToCartStates {}
class LoadingAddProductToCartState extends AddProductToCartStates {}
class FailureAddProductToCartState extends AddProductToCartStates {}

class CreateNewCart {



  static Future<String> getBasketId()  async {


    final storage = FlutterSecureStorage();
    String? basketId = await storage.read(key: 'cartId') ;

    if (basketId == null) {
      // If basket ID does not exist, generate a new one and store it
      basketId = Uuid().v4();
      final storage = FlutterSecureStorage();
      await storage.write(key: 'cartId', value: basketId);
    }


    return basketId;
  }
}