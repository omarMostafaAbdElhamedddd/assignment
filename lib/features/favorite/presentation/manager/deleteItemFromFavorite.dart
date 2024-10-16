

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../../utils/internetConnection.dart';
import '../../../../utils/widgets/customSnakBAr.dart';
import '../../../home/data/productModel.dart';

class DeleteProductFromFavoriteCubit extends Cubit<DeleteProductFromFavoriteStates> {
  DeleteProductFromFavoriteCubit() : super((InitDeleteProductFromFavoriteState()));

  Future<void> deleteFromCart(String cartId ,String productId, BuildContext context,dynamic scaffoldMessenger) async {
    emit(LoadingDeleteProductFromFavoriteState());
    final connectivityProvider = Provider.of<ConnectivityProvider>(context,listen: false);
    if (connectivityProvider.isConnected && connectivityProvider.hasInternetAccess ) {
      try {
        await FirebaseFirestore.instance.collection(cartId).doc(productId).delete();
        emit(SuccessDeleteProductFromFavoriteState());
      } catch (e) {
        emit(FailureDeleteProductFromFavoriteState());
      }
    }else{
      emit(FailureDeleteProductFromFavoriteState());
      MySanckBar.snackBar("You are not connected to the internet,try again", scaffoldMessenger);
    }
  }
}






abstract class DeleteProductFromFavoriteStates {}

class InitDeleteProductFromFavoriteState extends DeleteProductFromFavoriteStates {}
class SuccessDeleteProductFromFavoriteState extends DeleteProductFromFavoriteStates {}
class LoadingDeleteProductFromFavoriteState extends DeleteProductFromFavoriteStates {}
class FailureDeleteProductFromFavoriteState extends DeleteProductFromFavoriteStates {}