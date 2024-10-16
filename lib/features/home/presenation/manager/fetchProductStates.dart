import '../../data/productModel.dart';

abstract class FetchProductsStates {}

class InitStateFetchProducts extends FetchProductsStates {}

class SuccessStateFetchProducts extends FetchProductsStates {
 List<ProductModel> products;

  SuccessStateFetchProducts({required this.products});

}
class FailureStateFetchProducts extends FetchProductsStates {
  String errorMessage ;
  FailureStateFetchProducts({required this.errorMessage});

}
class LoadingStateFetchProducts extends FetchProductsStates {}