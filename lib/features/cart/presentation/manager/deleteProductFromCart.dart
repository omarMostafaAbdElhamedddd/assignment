

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../utils/internetConnection.dart';
import '../../../../utils/widgets/customSnakBAr.dart';
import '../../../home/data/productModel.dart';

class DeleteProductFromCartCubit extends Cubit<DeleteProductFromCartStates> {
  DeleteProductFromCartCubit() : super((InitDeleteProductFromCartState()));

  Future<void> deleteFromCart(String cartId ,String productId, BuildContext context,dynamic scaffoldMessenger) async {
    emit(LoadingDeleteProductFromCartState());
    final connectivityProvider = Provider.of<ConnectivityProvider>(context,listen: false);
    if (connectivityProvider.isConnected && connectivityProvider.hasInternetAccess ) {
      try {
        await FirebaseFirestore.instance.collection(cartId).doc(productId).delete();
        emit(SuccessDeleteProductFromCartState());
      } catch (e) {
        emit(FailureDeleteProductFromCartState());
      }
    }else{
      emit(FailureDeleteProductFromCartState());
      MySanckBar.snackBar("You are not connected to the internet,try again", scaffoldMessenger);
    }
  }
}






abstract class DeleteProductFromCartStates {}

class InitDeleteProductFromCartState extends DeleteProductFromCartStates {}
class SuccessDeleteProductFromCartState extends DeleteProductFromCartStates {}
class LoadingDeleteProductFromCartState extends DeleteProductFromCartStates {}
class FailureDeleteProductFromCartState extends DeleteProductFromCartStates {}