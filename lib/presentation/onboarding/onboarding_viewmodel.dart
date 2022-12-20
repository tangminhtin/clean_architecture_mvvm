import 'dart:async';

import 'package:clean_architecture_mvvm/domain/model/model.dart';
import 'package:clean_architecture_mvvm/presentation/base/base_view_model.dart';
import 'package:clean_architecture_mvvm/presentation/resources/assets_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/strings_manager.dart';

class OnBoardingViewModel extends BaseViewModel
    with OnBoardingViewModelInputs, OnBoardingViewModelOutputs {
  // Stream controllers
  final StreamController _streamController =
      StreamController<SliderViewObject>();

  late final List<SliderObject> _list;
  int _currentIndex = 0;

  /// Inputs
  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    _list = _getSliderData();
    // Send this slider data to our view
    _postDataToView();
  }

  @override
  void goNext() {
    _getNextIndex();
    _postDataToView();
  }

  @override
  void goPrevious() {
    _getPreviousIndex();
    _postDataToView();
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  @override
  Sink get inputSliderViewObject => _streamController.sink;

  /// Outputs
  @override
  Stream<SliderViewObject> get outputSliderViewObject =>
      _streamController.stream.map((sliderViewObject) => sliderViewObject);

  // Private functions
  List<SliderObject> _getSliderData() => [
        SliderObject(
          AppStrings.onBoardingTitle1,
          AppStrings.onBoardingSubtitle1,
          ImageAssets.onboardingLogo1,
        ),
        SliderObject(
          AppStrings.onBoardingTitle2,
          AppStrings.onBoardingSubtitle2,
          ImageAssets.onboardingLogo2,
        ),
        SliderObject(
          AppStrings.onBoardingTitle3,
          AppStrings.onBoardingSubtitle3,
          ImageAssets.onboardingLogo3,
        ),
        SliderObject(
          AppStrings.onBoardingTitle4,
          AppStrings.onBoardingSubtitle4,
          ImageAssets.onboardingLogo4,
        ),
      ];

  void _getPreviousIndex() {
    int previousIndex = _currentIndex--; // -1
    if (previousIndex == 0) {
      _currentIndex =
          _list.length - 1; // Infinite loop to go to the length of slider list
    }
  }

  void _getNextIndex() {
    int nextIndex = _currentIndex++; // +1
    if (nextIndex >= _list.length - 1) {
      _currentIndex = 0; // Infinite loop to go to the first item inside slider
    }
  }

  void _postDataToView() {
    inputSliderViewObject.add(
      SliderViewObject(_list[_currentIndex], _list.length, _currentIndex),
    );
  }
}

// Inputs mean the orders that our view model will receive from our view
abstract class OnBoardingViewModelInputs {
  void goNext(); // When user clicks on right arrow or swipe left
  void goPrevious(); // When user clicks on left arrow or swipe right
  void onPageChanged(int index);

  Sink
      get inputSliderViewObject; // This is the way to add data to the stream .. stream input
}

// Outputs mean data or results that will be sent from our view model to our view
abstract class OnBoardingViewModelOutputs {
  Stream<SliderViewObject> get outputSliderViewObject;
}

class SliderViewObject {
  SliderObject sliderObject;
  int numberOfSlides;
  int currentIndex;

  SliderViewObject(
    this.sliderObject,
    this.numberOfSlides,
    this.currentIndex,
  );
}
