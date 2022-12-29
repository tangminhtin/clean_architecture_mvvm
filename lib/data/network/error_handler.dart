import 'package:clean_architecture_mvvm/data/network/failure.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';

enum DataSource {
  success,
  noContent,
  badRequest,
  forbidden,
  unauthorised,
  notFound,
  internalServerError,
  connectTimeout,
  cancel,
  receiveTimeout,
  sendTimeout,
  cacheError,
  noInternetConnection,
  unknown,
}

class ErrorHandler implements Exception {
  late Failure failure;

  ErrorHandler.handle(dynamic error) {
    if (error is DioError) {
      // Dio error so its error from response of the API
      failure = _handleError(error);
    } else {
      // Default error
      failure = DataSource.unknown.getFailure();
    }
  }

  Failure _handleError(DioError error) {
    switch (error.type) {
      case DioErrorType.connectTimeout:
        return DataSource.connectTimeout.getFailure();
      case DioErrorType.sendTimeout:
        return DataSource.sendTimeout.getFailure();
      case DioErrorType.receiveTimeout:
        return DataSource.receiveTimeout.getFailure();
      case DioErrorType.response:
        switch (error.response!.statusCode) {
          case ResponseCode.badRequest:
            return DataSource.badRequest.getFailure();
          case ResponseCode.forbidden:
            return DataSource.forbidden.getFailure();
          case ResponseCode.unauthorised:
            return DataSource.unauthorised.getFailure();
          case ResponseCode.notFound:
            return DataSource.notFound.getFailure();
          case ResponseCode.internalServerError:
            return DataSource.internalServerError.getFailure();
          default:
            return DataSource.unknown.getFailure();
        }
      case DioErrorType.cancel:
        return DataSource.cancel.getFailure();
      case DioErrorType.other:
        return DataSource.unknown.getFailure();
    }
  }
}

extension DataSourceExtension on DataSource {
  Failure getFailure() {
    switch (this) {
      case DataSource.badRequest:
        return Failure(
            ResponseCode.badRequest, ResponseMessage.badRequest.tr());
      case DataSource.forbidden:
        return Failure(ResponseCode.forbidden, ResponseMessage.forbidden.tr());
      case DataSource.unauthorised:
        return Failure(
            ResponseCode.unauthorised, ResponseMessage.unauthorised.tr());
      case DataSource.notFound:
        return Failure(ResponseCode.notFound, ResponseMessage.notFound.tr());
      case DataSource.internalServerError:
        return Failure(ResponseCode.internalServerError,
            ResponseMessage.internalServerError.tr());
      case DataSource.connectTimeout:
        return Failure(
            ResponseCode.connectTimeout, ResponseMessage.connectTimeout.tr());
      case DataSource.cancel:
        return Failure(ResponseCode.cancel, ResponseMessage.cancel.tr());
      case DataSource.receiveTimeout:
        return Failure(
            ResponseCode.receiveTimeout, ResponseMessage.receiveTimeout.tr());
      case DataSource.sendTimeout:
        return Failure(
            ResponseCode.sendTimeout, ResponseMessage.sendTimeout.tr());
      case DataSource.cacheError:
        return Failure(
            ResponseCode.cacheError, ResponseMessage.cacheError.tr());
      case DataSource.noInternetConnection:
        return Failure(ResponseCode.noInternetConnection,
            ResponseMessage.noInternetConnection.tr());
      default:
        return Failure(ResponseCode.unknown, ResponseMessage.unknown.tr());
    }
  }
}

class ResponseCode {
  // API status code
  static const int success = 200; // Success with data
  static const int noContent = 201; // Success with no content
  static const int badRequest = 400; // Failure, api rejected the request
  static const int forbidden = 403; // Failure, api rejected the request
  static const int unauthorised = 401; // Failure user is not authorised
  static const int notFound =
      404; // Failure, api url is not correct and not found
  static const int internalServerError =
      500; // Failure, crash happened in server side

  // Local status code
  static const int unknown = -1;
  static const int connectTimeout = -2;
  static const int cancel = -3;
  static const int receiveTimeout = -4;
  static const int sendTimeout = -5;
  static const int cacheError = -6;
  static const int noInternetConnection = -7;
}

class ResponseMessage {
  // API status code
  static const String success = 'Success'; // Success with data
  static const String noContent =
      'Success with no content'; // Success with no content
  static const String badRequest =
      'Bad request, try again later'; // Failure, api rejected the request
  static const String forbidden =
      'Forbidden request, try again later'; // Failure, api rejected the request
  static const String unauthorised =
      'User is unauthorised, try again later'; // Failure user is not authorised
  static const String notFound =
      'Url is not found, try again later'; // Failure, api url is not correct and not found
  static const String internalServerError =
      'Some thing went wrong, try again later'; // Failure, crash happened in server side

  // Local status code
  static const String unknown = 'Some thing went wrong, try again later';
  static const String connectTimeout = 'Time out error, try again later';
  static const String cancel = 'Request was cancelled, try again later';
  static const String receiveTimeout = 'Time out error, try again later';
  static const String sendTimeout = 'Time out error, try again later';
  static const String cacheError = 'Cache error, try again later';
  static const String noInternetConnection = 'Please check your connection';
}

class ApiInternalStatus {
  static const int success = 0;
  static const int failure = 1;
}
