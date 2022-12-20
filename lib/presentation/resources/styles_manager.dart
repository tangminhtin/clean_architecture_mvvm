import 'package:clean_architecture_mvvm/presentation/resources/font_manager.dart';
import 'package:flutter/material.dart';

TextStyle _getTextStyle(
    double fontSize, String fontFamily, FontWeight fontWeight, Color color) {
  return TextStyle(
    fontFamily: fontFamily,
    fontSize: fontSize,
    color: color,
    fontWeight: fontWeight,
  );
}

// Regular text style
TextStyle getRegularStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, FontWeightManager.regular, color);
}

// Light text style
TextStyle getLightStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, FontWeightManager.light, color);
}

// bold text style
TextStyle getBoldStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, FontWeightManager.bold, color);
}

// SemiBold text style
TextStyle getSemiBoldStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, FontWeightManager.semiBold, color);
}

// Medium text style
TextStyle getMediumStyle({
  double fontSize = FontSize.s12,
  required Color color,
}) {
  return _getTextStyle(
      fontSize, FontConstants.fontFamily, FontWeightManager.medium, color);
}
