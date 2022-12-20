import 'dart:async';

import 'package:clean_architecture_mvvm/app/functions.dart';
import 'package:clean_architecture_mvvm/domain/usecase/forgot_password_usecase.dart';
import 'package:clean_architecture_mvvm/presentation/base/base_view_model.dart';
import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_render_impl.dart';
import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_renderer.dart';

class ForgotPasswordViewModel extends BaseViewModel
    with ForgotPasswordViewModelInputs, ForgotPasswordViewModelOutputs {
  final StreamController _emailStreamController =
      StreamController<String>.broadcast();
  final StreamController _isAllInputValidStreamController =
      StreamController<String>.broadcast();
  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);
  var email = '';

  /// Inputs
  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  void dispose() {
    _emailStreamController.close();
    _isAllInputValidStreamController.close();
  }

  @override
  forgotPassword() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _forgotPasswordUseCase.execute(email)).fold(
      (failure) {
        inputState.add(
          ErrorState(StateRendererType.popupErrorState, failure.message),
        );
      },
      (supportMessage) {
        inputState.add(SuccessState(supportMessage));
      },
    );
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputIsAllInputValid => _isAllInputValidStreamController.sink;

  @override
  setEmail(String email) {
    inputEmail.add(email);
    this.email = email;
    _validate();
  }

  /// Outputs
  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<bool> get outputIsAllInputValid =>
      _isAllInputValidStreamController.stream
          .map((isAllInputValid) => _isAllInputValid());

  /// Private method
  _isAllInputValid() {
    return isEmailValid(email);
  }

  _validate() {
    inputIsAllInputValid.add(null);
  }
}

abstract class ForgotPasswordViewModelInputs {
  setEmail(String email);
  forgotPassword();

  Sink get inputEmail;
  Sink get inputIsAllInputValid;
}

abstract class ForgotPasswordViewModelOutputs {
  Stream<bool> get outputIsEmailValid;
  Stream<bool> get outputIsAllInputValid;
}
