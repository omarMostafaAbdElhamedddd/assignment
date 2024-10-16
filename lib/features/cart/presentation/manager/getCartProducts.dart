
//
// import 'package:assignment/features/cart/data/cartModel.dart';
// import 'package:assignment/features/home/data/productModel.dart';
// import 'package:assignment/features/home/presenation/manager/fetchProductStates.dart';
// import 'package:dio/dio.dart';
// import 'package:dartz/dartz.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// import '../../../../utils/requestFailure.dart';
// import 'getCartProductsStates.dart';
//
// class GetCartProductService {
//   final Dio _dio = Dio();
//
//   Future<Either< Failure, List<CartModel>>> getCartProducts(int userId) async {
//     final String url = 'https://fakestoreapi.com/carts/user/100';
//
//     try {
//       final response = await _dio.get(url);
//       List<dynamic> data = response.data;
//
//       print(data);
//
//       print(data);
//       List<CartModel> producs = [];
//       for(int i=0; i<data.length; i++){
//         producs.add(CartModel.fromJson(data[i]));
//       }
//       print('this is list of cart products ${producs}');
//       return Right(producs);
//
//     } catch (e) {
//       if (e is DioException) {
//         return Left(ServerFailure.fromDioError(e));
//       } else {
//         return Left(ServerFailure(e.toString()));
//       }
//     }
//   }
// }
// class GetCartProductCubit extends Cubit<FetchCartProductsStates>{
//   GetCartProductCubit(this.getCartProductService) : super(InitStateFetchCartProducts());
//
//   final GetCartProductService getCartProductService ;
//
//   Future<void> getProducts (int userId) async{
//     emit(LoadingStateFetchCartProducts());
//
//     final result= await getCartProductService.getCartProducts(userId);
//
//     print(result.toString());
//
//     result.fold((failure){
//       emit(FailureStateFetchCartProducts(errorMessage: failure.errorMessage));
//     } , (products){
//       emit(SuccessStateFetchCartProducts(products: products));
//     });
//   }
// }