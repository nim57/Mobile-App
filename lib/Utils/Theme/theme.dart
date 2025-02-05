import 'package:flutter/material.dart';
import 'custom_themes/appbar_theme.dart';
import 'custom_themes/bottom_sheet_theme.dart';
import 'custom_themes/checkbox_theme.dart';
import 'custom_themes/chip_theme.dart';
import 'custom_themes/elevated_button.dart';
import 'custom_themes/outline_button_theme.dart';
import 'custom_themes/text_field_theme.dart';
import 'custom_themes/text_theme.dart';


class EAppTheme{
  EAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    primaryColor: Colors.blue,
    textTheme : ETextTheme.lightTextTheme,
    chipTheme: EChipTheme.lightChipTheme,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: EAppBArTheme.lightAppBArTheam,
    checkboxTheme: ECheckBoxTheme.lightCheckboxTheme,
    bottomSheetTheme:EBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: EElevatedButtonTheam.lightElevatedButtonTheme,
    outlinedButtonTheme: EOutlineButtonTheme.lightOutlineButton,
    inputDecorationTheme: ETextFormFieldTheme.lightInputDecorationTheme,
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.dark,
    primaryColor: Colors.blue,
    scaffoldBackgroundColor: Colors.black,
    textTheme: ETextTheme.darkTextTheme,
    chipTheme:EChipTheme.darkChipTheme,
    appBarTheme: EAppBArTheme.darkAppBArTheam,
    checkboxTheme: ECheckBoxTheme.darkCheckboxTheme,
    bottomSheetTheme: EBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: EElevatedButtonTheam.darkElevatedButtonTheme,
    outlinedButtonTheme: EOutlineButtonTheme.darkOutlineButton,
    inputDecorationTheme: ETextFormFieldTheme.darkInputDecorationTheme,
  );
}