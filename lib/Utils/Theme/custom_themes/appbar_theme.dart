import 'package:flutter/material.dart';

class EAppBArTheme{
  EAppBArTheme._();

  static const lightAppBArTheam= AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black,size: 24),
    actionsIconTheme: IconThemeData(color:Colors.black,size: 24),
    titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.black),
  );

  static const darkAppBArTheam= AppBarTheme(
    elevation: 0,
    centerTitle: false,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Colors.black,size: 24),
    actionsIconTheme: IconThemeData(color:Colors.white,size: 24),
    titleTextStyle: TextStyle(fontSize: 18,fontWeight: FontWeight.w600,color: Colors.white),
  );
}