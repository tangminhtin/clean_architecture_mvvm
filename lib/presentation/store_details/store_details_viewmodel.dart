import 'dart:async';
import 'dart:ffi';

import 'package:clean_architecture_mvvm/domain/model/model.dart';
import 'package:clean_architecture_mvvm/domain/usecase/store_detais_usecase.dart';
import 'package:clean_architecture_mvvm/presentation/base/base_view_model.dart';
import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_render_impl.dart';
import 'package:clean_architecture_mvvm/presentation/common/state_renderer.dart/state_renderer.dart';
import 'package:rxdart/subjects.dart';

class StoreDetailsViewModel extends BaseViewModel
    with StoreDetailsViewModelInput, StoreDetailsViewModelOutput {
  final StreamController _storeDetailsStreamController =
      BehaviorSubject<StoreDetails>();

  StoreDetailsUseCase storeDetailsUseCase;

  StoreDetailsViewModel(this.storeDetailsUseCase);

  /// Inputs
  @override
  void start() {
    _loadData();
  }

  @override
  void dispose() {
    _storeDetailsStreamController.close();
    super.dispose();
  }

  void _loadData() async {
    inputState.add(LoadingState(
      stateRendererType: StateRendererType.fullScreenLoadingState,
    ));
    (await storeDetailsUseCase.execute(Void)).fold(
      (failure) {
        inputState.add(ErrorState(
          StateRendererType.fullScreenErrorState,
          failure.message,
        ));
      },
      (storeDetails) {
        inputState.add(ContentState());
        inputStoreDetails.add(storeDetails);
      },
    );
  }

  @override
  Sink get inputStoreDetails => _storeDetailsStreamController.sink;

  /// Outputs
  @override
  Stream<StoreDetails> get outputStoreDetails =>
      _storeDetailsStreamController.stream.map((stores) => stores);
}

abstract class StoreDetailsViewModelInput {
  Sink get inputStoreDetails;
}

abstract class StoreDetailsViewModelOutput {
  Stream<StoreDetails> get outputStoreDetails;
}
