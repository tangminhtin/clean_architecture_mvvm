import 'package:clean_architecture_mvvm/data/network/error_handler.dart';

class Failure {
  int code; // 200 or 400
  String message; // Error or Success

  Failure(this.code, this.message);
}

class DefaultFailure extends Failure {
  DefaultFailure() : super(ResponseCode.unknown, ResponseMessage.unknown);
}
