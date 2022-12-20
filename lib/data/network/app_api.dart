import 'package:analyzer/file_system/file_system.dart';
import 'package:clean_architecture_mvvm/app/constant.dart';
import 'package:clean_architecture_mvvm/data/responses/responses.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constant.baseUrl)
abstract class AppServiceClient {
  factory AppServiceClient(Dio dio, {String baseUrl}) = _AppServiceClient;

  @POST('/customers/login')
  Future<AuthenticationResponse> login(
    @Field('email') String email,
    @Field('password') String password,
    @Field('imei') String imei,
    @Field('deviceType') String deviceType,
  );

  @POST('/customers/forgotPassword')
  Future<ForgotPasswordResponse> forgotPassword(@Field('email') String email);
}
