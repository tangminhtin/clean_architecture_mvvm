import 'dart:io';
import 'dart:async';

import 'package:clean_architecture_mvvm/app/functions.dart';
import 'package:clean_architecture_mvvm/domain/usecase/register_usecase.dart';
import 'package:clean_architecture_mvvm/presentation/base/base_view_model.dart';
import 'package:clean_architecture_mvvm/presentation/common/freezed_data_classes.dart';
import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_render_impl.dart';
import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_renderer.dart';

class RegisterViewModel extends BaseViewModel
    with RegisterViewModelInput, RegisterViewModelOutput {
  final StreamController _usernameStreamController =
      StreamController<String>.broadcast();

  final StreamController _mobileNumberStreamController =
      StreamController<String>.broadcast();

  final StreamController _emailStreamController =
      StreamController<String>.broadcast();

  final StreamController _passwordStreamController =
      StreamController<String>.broadcast();

  final StreamController _profilePictureStreamController =
      StreamController<File>.broadcast();

  final StreamController _isAllInputValidStreamController =
      StreamController<void>.broadcast();

  final StreamController isUserLoggedInSuccessfullyStreamController =
      StreamController<bool>();

  final RegisterUseCase _registerUseCase;
  RegisterObject registerObject = RegisterObject('', '', '', '', '', '');

  RegisterViewModel(this._registerUseCase);

  /// Inputs
  @override
  void start() {
    // View tells state renderer, please show the content of the screen;
    inputState.add(ContentState());
  }

  @override
  register() async {
    inputState.add(
        LoadingState(stateRendererType: StateRendererType.popupLoadingState));
    (await _registerUseCase.execute(RegisterUserInput(
      registerObject.countryMobileCode,
      registerObject.username,
      registerObject.email,
      registerObject.password,
      registerObject.mobileNumber,
      registerObject.profilePicture,
    )))
        .fold(
      (failure) {
        // Left -> failure
        inputState.add(
            ErrorState(StateRendererType.popupErrorState, failure.message));
      },
      (data) {
        // Right -> success (data)
        inputState.add(ContentState());
        // Navigate to main screen after the login
        isUserLoggedInSuccessfullyStreamController.add(true);
      },
    );
  }

  @override
  void dispose() {
    _usernameStreamController.close();
    _mobileNumberStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _profilePictureStreamController.close();
    _isAllInputValidStreamController.close();
    isUserLoggedInSuccessfullyStreamController.close();
    super.dispose();
  }

  @override
  setCountryCode(String countryCode) {
    if (countryCode.isNotEmpty) {
      // Update register view object with countryCode value
      registerObject = registerObject.copyWith(countryMobileCode: countryCode);
    } else {
      // Reset countryCode value in register view object
      registerObject = registerObject.copyWith(countryMobileCode: '');
    }
    _validate();
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    if (isEmailValid(email)) {
      // Update register view object with email value
      registerObject = registerObject.copyWith(email: email);
    } else {
      // Reset email value in register view object
      registerObject = registerObject.copyWith(email: '');
    }
    _validate();
  }

  @override
  setMobileNumber(String mobileNumber) {
    inputMobileNumber.add(mobileNumber);
    if (_isMobileNumberValid(mobileNumber)) {
      // Update register view object with mobileNumber value
      registerObject = registerObject.copyWith(mobileNumber: mobileNumber);
    } else {
      // Reset mobileNumber value in register view object
      registerObject = registerObject.copyWith(mobileNumber: '');
    }
    _validate();
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    if (_isPasswordValid(password)) {
      // Update register view object with password value
      registerObject = registerObject.copyWith(password: password);
    } else {
      // Reset password value in register view object
      registerObject = registerObject.copyWith(password: '');
    }
    _validate();
  }

  @override
  setProfilePicture(File file) {
    inputProfilePicture.add(file);
    if (file.path.isNotEmpty) {
      // Update register view object with profilePicture value
      registerObject = registerObject.copyWith(profilePicture: file.path);
    } else {
      // Reset profilePicture value in register view object
      registerObject = registerObject.copyWith(profilePicture: '');
    }
    _validate();
  }

  @override
  setUsername(String username) {
    inputUsername.add(username);
    if (_isUsernameValid(username)) {
      // Update register view object with username value
      registerObject = registerObject.copyWith(username: username);
    } else {
      // Reset username value in register view object
      registerObject = registerObject.copyWith(username: '');
    }
    _validate();
  }

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputMobileNumber => _mobileNumberStreamController.sink;

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputProfilePicture => _profilePictureStreamController.sink;

  @override
  Sink get inputUsername => _usernameStreamController.sink;

  @override
  Sink get inputAllInputsValid => _isAllInputValidStreamController.sink;

  /// Outputs
  @override
  Stream<bool> get outputIsAllInputsValid =>
      _isAllInputValidStreamController.stream.map((_) => _validateAllInputs());

  @override
  Stream<bool> get outputIsUsernameValid => _usernameStreamController.stream
      .map((username) => _isUsernameValid(username));

  @override
  Stream<String?> get outputErrorUsername => outputIsUsernameValid
      .map((isUsernameValid) => isUsernameValid ? null : 'Invalid username');

  @override
  Stream<bool> get outputIsEmailValid =>
      _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<String?> get outputErrorEmail => outputIsEmailValid
      .map((isEmailValid) => isEmailValid ? null : 'Invalid email');

  @override
  Stream<bool> get outputIsMobileNumberValid =>
      _mobileNumberStreamController.stream
          .map((mobileNumber) => _isMobileNumberValid(mobileNumber));

  @override
  Stream<String?> get outputErrorMobileNumber =>
      outputIsMobileNumberValid.map((isMobileNumberValid) =>
          isMobileNumberValid ? null : 'Invalid mobile number');

  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream
      .map((password) => _isPasswordValid(password));

  @override
  Stream<String?> get outputErrorPassword => outputIsPasswordValid
      .map((isPasswordValid) => isPasswordValid ? null : 'Invalid password');

  @override
  Stream<File?> get outputProfilePicture =>
      _profilePictureStreamController.stream.map((file) => file);

  /// Private method
  bool _isUsernameValid(String username) {
    return username.length >= 8;
  }

  bool _isMobileNumberValid(String mobileNumber) {
    return mobileNumber.length >= 10;
  }

  bool _isPasswordValid(String password) {
    return password.length >= 8;
  }

  bool _validateAllInputs() {
    return registerObject.profilePicture.isNotEmpty &&
        registerObject.email.isNotEmpty &&
        registerObject.password.isNotEmpty &&
        registerObject.mobileNumber.isNotEmpty &&
        registerObject.username.isNotEmpty &&
        registerObject.countryMobileCode.isNotEmpty;
  }

  _validate() {
    inputAllInputsValid.add(null);
  }
}

abstract class RegisterViewModelInput {
  register();

  setUsername(String username);
  setMobileNumber(String mobileNumber);
  setCountryCode(String countryCode);
  setEmail(String email);
  setPassword(String password);
  setProfilePicture(File file);

  Sink get inputUsername;
  Sink get inputMobileNumber;
  Sink get inputEmail;
  Sink get inputPassword;
  Sink get inputProfilePicture;
  Sink get inputAllInputsValid;
}

abstract class RegisterViewModelOutput {
  Stream<bool> get outputIsUsernameValid;
  Stream<String?> get outputErrorUsername;

  Stream<bool> get outputIsMobileNumberValid;
  Stream<String?> get outputErrorMobileNumber;

  Stream<bool> get outputIsEmailValid;
  Stream<String?> get outputErrorEmail;

  Stream<bool> get outputIsPasswordValid;
  Stream<String?> get outputErrorPassword;

  Stream<File?> get outputProfilePicture;
  Stream<bool> get outputIsAllInputsValid;
}
