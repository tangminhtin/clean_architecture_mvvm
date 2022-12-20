import 'dart:async';

import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_render_impl.dart';

abstract class BaseViewModel extends BaseViewModelInputs
    with BaseViewModelOutputs {
  final StreamController _inputStateStreamController =
      StreamController<FlowState>.broadcast();

  @override
  Sink get inputState => _inputStateStreamController.sink;

  @override
  Stream<FlowState> get outputState =>
      _inputStateStreamController.stream.map((flowState) => flowState);

  @override
  void dispose() {
    _inputStateStreamController.close();
  }

  // Shared variables and functions that will be used through any view model.
}

abstract class BaseViewModelInputs {
  void start(); // will be called while init of view model
  void dispose(); // will be called when view model dies

  Sink get inputState;
}

abstract class BaseViewModelOutputs {
  Stream<FlowState> get outputState;
}
