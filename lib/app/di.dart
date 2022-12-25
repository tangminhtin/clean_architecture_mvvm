import 'package:clean_architecture_mvvm/domain/usecase/forgot_password_usecase.dart';
import 'package:clean_architecture_mvvm/domain/usecase/register_usecase.dart';
import 'package:clean_architecture_mvvm/presentation/forgot_password/forgot_password_viewmodel.dart';
import 'package:clean_architecture_mvvm/presentation/register/register_viewmodel.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:clean_architecture_mvvm/app/app_prefs.dart';
import 'package:clean_architecture_mvvm/data/data_source/remote_data_source.dart';
import 'package:clean_architecture_mvvm/data/network/app_api.dart';
import 'package:clean_architecture_mvvm/data/network/dio_factory.dart';
import 'package:clean_architecture_mvvm/data/network/network_info.dart';
import 'package:clean_architecture_mvvm/data/repository/repository_impl.dart';
import 'package:clean_architecture_mvvm/domain/repository/repository.dart';
import 'package:clean_architecture_mvvm/domain/usecase/login_usecase.dart';
import 'package:clean_architecture_mvvm/presentation/login/login_viewmodel.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async {
  final sharedPrefs = await SharedPreferences.getInstance();

  // Shared prefs instance
  instance.registerLazySingleton<SharedPreferences>(() => sharedPrefs);

  // App prefs instance
  instance
      .registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  // Network info
  instance.registerLazySingleton<NetworkInfo>(
      () => NetworkInfoImpl(DataConnectionChecker()));

  // Dio factory
  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  // App service client
  final dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  // Remote data source
  instance.registerLazySingleton<RemoteDataSource>(
      () => RemoteDataSourceImplementer(instance()));

  // Repository
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(instance(), instance()));
  initAppModule();
}

initLoginModule() {
  if (!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }
}

initForgotPasswordModule() {
  if (!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(
        () => ForgotPasswordUseCase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(
        () => ForgotPasswordViewModel(instance()));
  }
}

initRegisterModule() {
  if (!GetIt.I.isRegistered<RegisterUseCase>()) {
    instance
        .registerFactory<RegisterUseCase>(() => RegisterUseCase(instance()));
    instance.registerFactory<RegisterViewModel>(
        () => RegisterViewModel(instance()));
    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }
}
