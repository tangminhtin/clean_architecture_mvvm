import 'package:flutter/material.dart';

import 'package:clean_architecture_mvvm/data/mapper/mapper.dart';
import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_renderer.dart';
import 'package:clean_architecture_mvvm/presentation/resources/strings_manager.dart';

abstract class FlowState {
  StateRendererType getStateRendererType();
  String getMessage();
}

/// Loading State (POPUP, FULL SCREEN)
class LoadingState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  LoadingState({required this.stateRendererType, String? message})
      : message = message ?? AppStrings.loading;

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

/// Error State (POPUP, FULL LOADING)
class ErrorState extends FlowState {
  StateRendererType stateRendererType;
  String message;

  ErrorState(this.stateRendererType, this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => stateRendererType;
}

/// Content State
class ContentState extends FlowState {
  ContentState();

  @override
  String getMessage() => empty;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.contentScreenState;
}

/// Empty State
class EmptyState extends FlowState {
  String message;

  EmptyState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() =>
      StateRendererType.emptyScreenState;
}

/// Success State
class SuccessState extends FlowState {
  String message;

  SuccessState(this.message);

  @override
  String getMessage() => message;

  @override
  StateRendererType getStateRendererType() => StateRendererType.popupSuccess;
}

extension FlowStateExtension on FlowState {
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (this.runtimeType) {
      case LoadingState:
        if (getStateRendererType() == StateRendererType.popupLoadingState) {
          // Showing popup  dialog
          showPopup(context, getStateRendererType(), getMessage());
          // Return the content UI of the screen
          return contentScreenWidget;
        } else {
          // StateRenderType.fullScreenLoadingState
          return StateRenderer(
            stateRendererType: getStateRendererType(),
            message: getMessage(),
            retryActionFunction: retryActionFunction,
          );
        }
      case ErrorState:
        dismissDialog(context);
        if (getStateRendererType() == StateRendererType.popupErrorState) {
          // Showing popup  dialog
          showPopup(context, getStateRendererType(), getMessage());
          // Return the content UI of the screen
          return contentScreenWidget;
        } else {
          // StateRenderType.fullScreenErrorState
          return StateRenderer(
            stateRendererType: getStateRendererType(),
            message: getMessage(),
            retryActionFunction: retryActionFunction,
          );
        }
      case ContentState:
        dismissDialog(context);
        return contentScreenWidget;
      case EmptyState:
        return StateRenderer(
          stateRendererType: getStateRendererType(),
          message: getMessage(),
          retryActionFunction: retryActionFunction,
        );
      case SuccessState:
        dismissDialog(context);
        showPopup(
          context,
          StateRendererType.popupSuccess,
          getMessage(),
          title: AppStrings.success,
        );
        return contentScreenWidget;

      default:
        return contentScreenWidget;
    }
  }

  bool _isThereCurrentDialogShowing(BuildContext context) =>
      ModalRoute.of(context)?.isCurrent != true;

  void dismissDialog(BuildContext context) {
    if (_isThereCurrentDialogShowing(context)) {
      Navigator.of(context, rootNavigator: true).pop(true);
    }
  }

  showPopup(
      BuildContext context, StateRendererType stateRendererType, String message,
      {String title = empty}) {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => showDialog(
        context: context,
        builder: (BuildContext context) => StateRenderer(
          stateRendererType: stateRendererType,
          message: message,
          title: title,
          retryActionFunction: () {},
        ),
      ),
    );
  }
}
