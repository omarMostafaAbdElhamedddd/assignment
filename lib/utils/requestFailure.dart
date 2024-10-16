import 'package:dio/dio.dart';
abstract class Failure {
  String errorMessage;
  Failure(this.errorMessage);
}

class ServerFailure extends Failure {
  ServerFailure(super.errorMessage);

  factory ServerFailure.fromDioError(DioException dioError) {
    switch (dioError.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection to the server timed out.');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Sending data took longer than expected.');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receiving data from the server took longer than expected.');
      case DioExceptionType.badCertificate:
        return ServerFailure('There was an issue with the security certificate.');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(dioError.response!.statusCode!, dioError.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure('The request was canceled.');
      case DioExceptionType.connectionError:
        return ServerFailure('No internet connection.');
      case DioExceptionType.unknown:
        return ServerFailure('An unexpected error occurred, please try again.');
      default:
        return ServerFailure('An unknown error occurred, please try again later.');
    }
  }

  factory ServerFailure.fromResponse(int statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
      return ServerFailure('Request rejected or unauthorized.');
    } else if (statusCode == 404) {
      return ServerFailure('Request not found.');
    } else if (statusCode == 500) {
      return ServerFailure('Internal server error.');
    } else {
      return ServerFailure('An unexpected error occurred, please try again later.');
    }
  }
}
