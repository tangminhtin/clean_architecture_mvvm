import 'package:dartz/dartz.dart';
import 'package:clean_architecture_mvvm/data/data_source/remote_data_source.dart';
import 'package:clean_architecture_mvvm/data/mapper/mapper.dart';
import 'package:clean_architecture_mvvm/data/network/error_handler.dart';
import 'package:clean_architecture_mvvm/data/network/network_info.dart';
import 'package:clean_architecture_mvvm/domain/model/model.dart';
import 'package:clean_architecture_mvvm/data/request/request.dart';
import 'package:clean_architecture_mvvm/data/network/failure.dart';
import 'package:clean_architecture_mvvm/domain/repository/repository.dart';

class RepositoryImpl extends Repository {
  final RemoteDataSource _remoteDataSource;
  final NetworkInfo _networkInfo;

  RepositoryImpl(this._remoteDataSource, this._networkInfo);

  @override
  Future<Either<Failure, Authentication>> login(
      LoginRequest loginRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // Its safe to call the API
        final response = await _remoteDataSource.login(loginRequest);
        if (response.status == ApiInternalStatus.success) {
          // Success
          // Return data (success)
          // Return right
          return Right(response.toDomain());
        } else {
          // Return biz logic error
          // Return left
          return Left(
            Failure(response.status ?? ApiInternalStatus.failure,
                response.message ?? ResponseMessage.unknown),
          );
        }
      } catch (error) {
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // Return connection error
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    if (await _networkInfo.isConnected) {
      try {
        // Its safe to call the API
        final response = await _remoteDataSource.forgotPassword(email);
        if (response.status == ApiInternalStatus.success) {
          // Success
          // Return data (success)
          // Return right
          return Right(response.toDomain());
        } else {
          // Return biz logic error
          // Return left
          return Left(
            Failure(response.status ?? ResponseCode.unknown,
                response.message ?? ResponseMessage.unknown),
          );
        }
      } catch (error) {
        // Return biz logic error
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // Return connection error
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }

  @override
  Future<Either<Failure, Authentication>> register(
      RegisterRequest registerRequest) async {
    if (await _networkInfo.isConnected) {
      try {
        // Its safe to call the API
        final response = await _remoteDataSource.register(registerRequest);
        if (response.status == ApiInternalStatus.success) {
          // Success
          // Return data (success)
          // Return right
          return Right(response.toDomain());
        } else {
          // Return biz logic error
          // Return left
          return Left(
            Failure(response.status ?? ResponseCode.unknown,
                response.message ?? ResponseMessage.unknown),
          );
        }
      } catch (error) {
        // Return biz logic error
        return Left(ErrorHandler.handle(error).failure);
      }
    } else {
      // Return connection error
      return Left(DataSource.noInternetConnection.getFailure());
    }
  }
}
