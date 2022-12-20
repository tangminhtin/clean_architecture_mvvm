import 'package:dartz/dartz.dart';
import 'package:clean_architecture_mvvm/data/network/failure.dart';

abstract class BaseUseCase<In, Out> {
  Future<Either<Failure, Out>> execute(In input);
}
