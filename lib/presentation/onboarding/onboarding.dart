import 'package:clean_architecture_mvvm/app/app_prefs.dart';
import 'package:clean_architecture_mvvm/app/di.dart';
import 'package:clean_architecture_mvvm/domain/model/model.dart';
import 'package:clean_architecture_mvvm/presentation/onboarding/onboarding_viewmodel.dart';
import 'package:clean_architecture_mvvm/presentation/resources/assets_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/routes_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/strings_manager.dart';
import 'package:clean_architecture_mvvm/presentation/resources/values_manager.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:clean_architecture_mvvm/presentation/resources/color_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  final PageController _pageController = PageController(initialPage: 0);
  final OnBoardingViewModel _onBoardingViewModel = OnBoardingViewModel();
  final AppPreferences _appPreferences = instance<AppPreferences>();

  void _bind() {
    _appPreferences.setOnBoardingScreenView();
    _onBoardingViewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<SliderViewObject>(
      stream: _onBoardingViewModel.outputSliderViewObject,
      builder: (context, snapshot) => _getContentWidget(snapshot.data),
    );
  }

  Widget _getContentWidget(SliderViewObject? sliderViewObject) {
    if (sliderViewObject == null) {
      return Container();
    }

    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        backgroundColor: ColorManager.white,
        elevation: AppSize.s0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: ColorManager.white,
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.dark,
        ),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: sliderViewObject.numberOfSlides,
        onPageChanged: (index) {
          _onBoardingViewModel.onPageChanged(index);
        },
        itemBuilder: (context, index) =>
            OnBoardingPage(sliderViewObject.sliderObject),
      ),
      bottomSheet: Container(
        color: ColorManager.white,
        height: AppSize.s100,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.loginRoute,
                  );
                },
                child: Text(
                  AppStrings.skip.tr(),
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ),
            ),
            // Add layout for indicator and arrows
            _getBottomSheetWidget(sliderViewObject),
          ],
        ),
      ),
    );
  }

  Widget _getBottomSheetWidget(SliderViewObject sliderViewObject) {
    return Container(
      color: ColorManager.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left arrow
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              onTap: () {
                // Go to previous slide
                _onBoardingViewModel.goPrevious();
              },
              child: SizedBox(
                height: AppSize.s20,
                width: AppSize.s20,
                child: SvgPicture.asset(
                  ImageAssets.leftArrowIc,
                ),
              ),
            ),
          ),
          // Circles indicator
          Row(
            children: [
              for (int i = 0; i < sliderViewObject.numberOfSlides; i++)
                Padding(
                  padding: const EdgeInsets.all(AppPadding.p8),
                  child: _getProperCircle(i, sliderViewObject.currentIndex),
                ),
            ],
          ),
          // Right arrow
          Padding(
            padding: const EdgeInsets.all(AppPadding.p14),
            child: GestureDetector(
              onTap: () {
                // Go to next slide
                _onBoardingViewModel.goNext();
              },
              child: SizedBox(
                height: AppSize.s20,
                width: AppSize.s20,
                child: SvgPicture.asset(
                  ImageAssets.rightArrowIc,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getProperCircle(int index, int _currentIndex) {
    if (index == _currentIndex) {
      return SvgPicture.asset(ImageAssets.hollowCircleIc); // Selected slide
    } else {
      return SvgPicture.asset(ImageAssets.solidCircleIc); // Unselected slide
    }
  }

  @override
  void dispose() {
    _onBoardingViewModel.dispose();
    super.dispose();
  }
}

class OnBoardingPage extends StatelessWidget {
  final SliderObject _sliderObject;

  const OnBoardingPage(this._sliderObject, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(height: AppSize.s40),
        Padding(
          padding: const EdgeInsets.all(
            AppPadding.p8,
          ),
          child: Text(
            _sliderObject.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline1,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppPadding.p8),
          child: Text(
            _sliderObject.subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.subtitle1,
          ),
        ),
        const SizedBox(
          height: AppSize.s60,
        ),
        SvgPicture.asset(_sliderObject.image),
      ],
    );
  }
}
