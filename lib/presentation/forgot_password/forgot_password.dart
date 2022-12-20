import 'package:clean_architecture_mvvm/presentation/resources/strings_manager.dart';
import 'package:flutter/material.dart';
import 'package:clean_architecture_mvvm/app/di.dart';
import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_render_impl.dart';
import 'package:clean_architecture_mvvm/presentation/resources/assets_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/color_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/values_manager.dart';
import 'package:clean_architecture_mvvm/presentation/forgot_password/forgot_password_viewmodel.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTextEditingController =
      TextEditingController();
  final ForgotPasswordViewModel _forgotPasswordViewModel =
      instance<ForgotPasswordViewModel>();

  bind() {
    _forgotPasswordViewModel.start();
    _emailTextEditingController.addListener(() =>
        _forgotPasswordViewModel.setEmail(_emailTextEditingController.text));
  }

  @override
  void initState() {
    bind();
    super.initState();
  }

  @override
  void dispose() {
    _forgotPasswordViewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<FlowState>(
        stream: _forgotPasswordViewModel.outputState,
        builder: (context, snapshot) {
          return snapshot.data?.getScreenWidget(context, _getContentWidget(),
                  () {
                _forgotPasswordViewModel.forgotPassword();
              }) ??
              _getContentWidget();
        },
      ),
    );
  }

  Widget _getContentWidget() {
    return Container(
      constraints: const BoxConstraints.expand(),
      padding: const EdgeInsets.only(top: AppPadding.p100),
      color: ColorManager.white,
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Image(
                image: AssetImage(ImageAssets.splashLogo),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                  stream: _forgotPasswordViewModel.outputIsEmailValid,
                  builder: (context, snapshot) {
                    return TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: _emailTextEditingController,
                      decoration: InputDecoration(
                        hintText: AppStrings.emailHint,
                        labelText: AppStrings.emailHint,
                        errorText: (snapshot.data ?? true)
                            ? null
                            : AppStrings.invalidEmail,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(
                height: AppSize.s28,
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: AppPadding.p28,
                  right: AppPadding.p28,
                ),
                child: StreamBuilder<bool>(
                  stream: _forgotPasswordViewModel.outputIsAllInputValid,
                  builder: (context, snapshot) {
                    return SizedBox(
                      width: double.infinity,
                      height: AppSize.s40,
                      child: ElevatedButton(
                        onPressed: (snapshot.data ?? false)
                            ? () => _forgotPasswordViewModel.forgotPassword()
                            : null,
                        child: const Text(AppStrings.resetPassword),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
