import 'package:assignment/features/home/data/productModel.dart';
import 'package:assignment/features/home/presenation/manager/fetchProductStates.dart';
import 'package:dio/dio.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/requestFailure.dart';

class GetProductService {
  final Dio _dio = Dio();

  Future<Either< Failure, List<ProductModel>>> getProducts() async {
    final String url = 'https://fakestoreapi.com/products';

    try {
     final response = await _dio.get(url);
      List<dynamic> data = response.data;
      List<ProductModel> producs = [];
      for(int i=0; i<data.length; i++){
        producs.add(ProductModel.fromJson(data[i]));
      }
      print('this is list of products ${producs}');
        return Right(producs);

    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      } else {
        return Left(ServerFailure(e.toString()));
      }
    }
  }
}
class GetProductCubit extends Cubit<FetchProductsStates>{
  GetProductCubit(this.getProductService) : super(InitStateFetchProducts());

  final GetProductService getProductService ;

  Future<void> getProducts () async{
    emit(LoadingStateFetchProducts());

    final result= await getProductService.getProducts();

    print(result.toString());

    result.fold((failure){
      emit(FailureStateFetchProducts(errorMessage: failure.errorMessage));
    } , (products){
      emit(SuccessStateFetchProducts(products: products));
    });
  }
}