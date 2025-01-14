import 'package:flutter/material.dart';

class TColors {
  TColors._();

//App basic colors
  static const Color primary = Color(0XFF4b68ff);
  static const Color secondary = Color(0XFFFFE24B);
  static const Color accent = Color(0XFFb0c7ff);

  //Gradient Colors
  static const Gradient linearGradient = LinearGradient(
      begin: Alignment(0.0, 0.0),
      end: Alignment(0.707, -0.707),
      colors: [Color(0xffff9a9e), Color(0xfffad0c4), Color(0xfffad0c4)]);

  //Text colors
  static const Color textPrimary = Color(0XFF333333);
  static const Color textSecondary = Color(0XFFFFE24B);
  static const Color textWhite = Colors.white;

  //Background colors
  static const Color light = Color(0XFFF6F6F6);
  static const Color dark = Color(0XFF272727);
  static const Color primaryBackground = Color(0XFFF3F5FF);

//Backgroundcontainer colors
  static const Color lightContainer = Color(0XFFF6F6F6);
  // static Color darkContainer = TColors.white.withOpacity(0.1);

//Button colors
  static const Color buttonPrimary = Color(0XFF4b68ff);
  static const Color buttonSecondary = Color(0XFF6C757D);
  static const Color buttonDisabled = Color(0XFFC4C4C4);

  //Border colors
  static const Color borderPrimary = Color(0XFFD9D9D9);
  static const Color borderSecondary = Color(0XFFE6E6E6);

  //Error and validation errors
  static const Color error = Color(0XFFD32F2F);
  static const Color success = Color(0XFF388E3C);
  static const Color warning = Color(0XFFF57C00);
  static const Color info = Color(0XFF1976d2);

//central shades
  static const Color black = Color(0XFF232323);
  static const Color darkerGrey = Color(0XFF4F4F4F);
  static const Color darkGrey = Color(0XFF939393);
  static const Color grey = Color(0XFFE0E0E0);
  static const Color softGrey = Color(0XFFF4F4F4);
  static const Color lightGrey = Color(0XFFF9F9F9);
  static const Color white = Color(0XFFFFFFFF);
}
