import 'package:clean_architecture_mvvm/app/app_prefs.dart';
import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_render_impl.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture_mvvm/app/di.dart';
import 'package:clean_architecture_mvvm/presentation/resources/routes_manager.dart';
import 'package:clean_architecture_mvvm/presentation/login/login_viewmodel.dart';
import 'package:clean_architecture_mvvm/presentation/resources/assets_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/color_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/strings_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/values_manager.dart';
import 'package:flutter/scheduler.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginViewModel _loginViewModel = instance<LoginViewModel>();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _bind() {
    _loginViewModel.start();
    _usernameController.addListener(
        () => _loginViewModel.setUsername(_usernameController.text));
    _passwordController.addListener(
        () => _loginViewModel.setPassword(_passwordController.text));
    _loginViewModel.isUserLoggedInSuccessfullyStreamController.stream
        .listen((token) {
      // Navigate to main screen
      SchedulerBinding.instance.addPostFrameCallback((_) {
        _appPreferences.setUserToken(token);
        _appPreferences.setIsUserLoggedIn();
        resetModules();
        Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
      });
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  void dispose() {
    _loginViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.white,
      body: Scaffold(
        body: StreamBuilder<FlowState>(
          stream: _loginViewModel.outputState,
          builder: (context, snapshot) {
            return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                    () {
                  _loginViewModel.login();
                }) ??
                _getContentWidget();
          },
        ),
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      padding: const EdgeInsets.only(
        top: AppPadding.p100,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Image(image: AssetImage(ImageAssets.splashLogo)),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                  stream: _loginViewModel.outputIsUsernameValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: AppStrings.username.tr(),
                        labelText: AppStrings.username.tr(),
                        errorText: (snapshot.data ?? true)
                            ? null
                            : AppStrings.usernameError.tr(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                  stream: _loginViewModel.outputIsPasswordValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      controller: _passwordController,
                      decoration: InputDecoration(
                        hintText: AppStrings.password.tr(),
                        labelText: AppStrings.password.tr(),
                        errorText: (snapshot.data ?? true)
                            ? null
                            : AppStrings.passwordError.tr(),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: AppSize.s28),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                  stream: _loginViewModel.outputIsAllInputsValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () => _loginViewModel.login()
                            : null,
                        child: Text(AppStrings.login.tr()),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: AppPadding.p8,
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(Routes.forgotPasswordRoute);
                      },
                      child: Text(
                        AppStrings.forgetPassword.tr(),
                        style: Theme.of(context).textTheme.subtitle2,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed(Routes.registerRoute);
                      },
                      child: Text(
                        AppStrings.registerText.tr(),
                        style: Theme.of(context).textTheme.subtitle2,
                        textAlign: TextAlign.end,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
