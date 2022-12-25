import 'package:dartz/dartz.dart';
import 'package:clean_architecture_mvvm/data/network/failure.dart';
import 'package:clean_architecture_mvvm/data/request/request.dart';
import 'package:clean_architecture_mvvm/domain/model/model.dart';
import 'package:clean_architecture_mvvm/domain/repository/repository.dart';
import 'package:clean_architecture_mvvm/domain/usecase/base_usecase.dart';

class RegisterUseCase
    implements BaseUseCase<RegisterUserInput, Authentication> {
  final Repository _repository;

  const RegisterUseCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUserInput input) async {
    return await _repository.register(RegisterRequest(
      input.countryMobileCode,
      input.username,
      input.email,
      input.password,
      input.mobileNumber,
      input.profilePicture,
    ));
  }
}

class RegisterUserInput {
  String countryMobileCode;
  String username;
  String email;
  String password;
  String mobileNumber;
  String profilePicture;

  RegisterUserInput(
    this.countryMobileCode,
    this.username,
    this.email,
    this.password,
    this.mobileNumber,
    this.profilePicture,
  );
}
