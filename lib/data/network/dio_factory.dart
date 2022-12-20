import 'package:clean_architecture_mvvm/app/app_prefs.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:clean_architecture_mvvm/app/constant.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

const String applicationJson = 'application/json';
const String contentType = 'content-type';
const String accept = 'accept';
const String authorization = 'authorization';
const String defaultLanguage = 'language';

class DioFactory {
  final AppPreferences _appPreferences;

  DioFactory(this._appPreferences);

  Future<Dio> getDio() async {
    Dio dio = Dio();
    int timeOut = 60 * 1000; // 1 min
    String language = await _appPreferences.getAppLanguage();

    Map<String, String> headers = {
      contentType: applicationJson,
      accept: applicationJson,
      authorization: Constant.token,
      defaultLanguage: language,
    };

    dio.options = BaseOptions(
      baseUrl: Constant.baseUrl,
      connectTimeout: timeOut,
      receiveTimeout: timeOut,
      headers: headers,
    );

    if (kReleaseMode) {
      print('Release mode no logs');
    } else {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    return dio;
  }
}
