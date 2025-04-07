import 'package:flutter/material.dart';
import 'color_app.dart';
import 'font_manager.dart';

mixin AppTextStyles {
  //* ShamelBook
  static TextStyle getShamelBookStyle(
      {double fontSize = FontSizeManager.s14,
      FontWeight fontWeight = FontWeightManager.regular,
      Color color = AppColors.grayOneColor}) {
    return TextStyle(
      fontFamily: FontFamilyNames.shamelBook,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }

  //* ShamelBold
  static TextStyle getShamelBoldStyle(
      {double fontSize = FontSizeManager.s14,
      FontWeight fontWeight = FontWeightManager.regular,
      Color color = AppColors.grayOneColor}) {
    return TextStyle(
      fontFamily: FontFamilyNames.shamelBold,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }

  //* UltraLight
  static TextStyle getUltraLightStyle(
      {double fontSize = FontSizeManager.s14,
      FontWeight fontWeight = FontWeightManager.regular,
      Color color = AppColors.grayOneColor}) {
    return TextStyle(
      fontFamily: FontFamilyNames.dINNextLTArabicUltraLight,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }

//* regular
  static TextStyle getRegularStyle(
      {double fontSize = FontSizeManager.s14,
      FontWeight fontWeight = FontWeightManager.regular,
      Color color = AppColors.grayOneColor}) {
    return TextStyle(
      fontFamily: FontFamilyNames.dINNextLTArabicRegular,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }

//* medium
  static TextStyle getMediumStyle(
      {double fontSize = FontSizeManager.s14,
      FontWeight fontWeight = FontWeightManager.regular,
      Color color = AppColors.grayOneColor}) {
    return TextStyle(
      fontFamily: FontFamilyNames.dINNextLTArabicMedium,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }

//* Bold
  static TextStyle getBoldStyle(
      {double fontSize = FontSizeManager.s14,
      FontWeight fontWeight = FontWeightManager.regular,
      Color color = AppColors.grayOneColor}) {
    return TextStyle(
      fontFamily: FontFamilyNames.dINNextLTArabicBold,
      fontWeight: fontWeight,
      fontSize: fontSize,
      color: color,
    );
  }
}
