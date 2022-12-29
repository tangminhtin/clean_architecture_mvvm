import 'dart:async';

import 'package:clean_architecture_mvvm/domain/usecase/login_usecase.dart';
import 'package:clean_architecture_mvvm/presentation/base/base_view_model.dart';
import 'package:clean_architecture_mvvm/presentation/common/freezed_data_classes.dart';
import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_render_impl.dart';
import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_renderer.dart';

class LoginViewModel extends BaseViewModel
    with LoginViewModelInputs, LoginViewModelOutputs {
  final StreamController _usernameStreamController =
      StreamController<String>.broadcast();
  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();
  final StreamController _isAllInputsValidStreamController =
      StreamController<void>.broadcast();
  final StreamController isUserLoggedInSuccessfullyStreamController =
      StreamController<String>();

  LoginObject loginObject = LoginObject('', '');
  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  /// Inputs
  @override
  void dispose() {
    _usernameStreamController.close();
    _passwordStreamController.close();
    _isAllInputsValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
  }

  @override
  void start() {
    // View tells state renderer, please show the content of the screen
    inputState.add(ContentState());
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUsername => _usernameStreamController.sink;

  @override
  Sink get inputIsAllInputsValid => _isAllInputsValidStreamController.sink;

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(
      password: password,
    ); // Data class operation same as kotlin
    _validate();
  }

  @override
  setUsername(String username) {
    inputUsername.add(username);
    loginObject = loginObject.copyWith(
      username: username,
    ); // Data class operation same as kotlin
    _validate();
  }

  @override
  login() async {
    inputState.add(LoadingState(
        stateRendererType: StateRendererType.fullScreenLoadingState));
    (await _loginUseCase.execute(
            LoginUseCaseInput(loginObject.username, loginObject.password)))
        .fold(
      (failure) {
        // Left -> Failure
        inputState.add(ErrorState(
          StateRendererType.fullScreenErrorState,
          failure.message,
        ));
      },
      (data) {
        // Right -> Success (data)
        inputState.add(ContentState());

        // Navigator to main screen after login
        isUserLoggedInSuccessfullyStreamController.add('abcdefgh');
      },
    );
  }

  /// Outputs
  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsUsernameValid => _usernameStreamController.stream
      .map((username) => _isUsernameValid(username));

  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputsValidStreamController.stream.map((_) => _isAllInputsValid());

  /// Private functions
  void _validate() => inputIsAllInputsValid.add(null);
  bool _isPasswordValid(String password) => password.isNotEmpty;
  bool _isUsernameValid(String username) => username.isNotEmpty;
  bool _isAllInputsValid() =>
      _isPasswordValid(loginObject.password) &&
      _isUsernameValid(loginObject.username);
}

abstract class LoginViewModelInputs {
  // Three functions for actions
  setUsername(String username);
  setPassword(String password);
  login();

  // Two sinks for streams
  Sink get inputUsername;
  Sink get inputPassword;
  Sink get inputIsAllInputsValid;
}

abstract class LoginViewModelOutputs {
  Stream<bool> get outputIsUsernameValid;
  Stream<bool> get outputIsPasswordValid;
  Stream<bool> get outputIsAllInputsValid;
}
