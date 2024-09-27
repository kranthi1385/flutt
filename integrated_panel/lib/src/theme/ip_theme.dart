// lib/src/theme/custom_theme_data.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SDKCustomization {
  final Color mainColor;
  final Color secondaryColor;
  final String fontFamily;
  final bool isDarkMode;

  static SDKCustomization? instance;

  SDKCustomization._internal({
    required this.mainColor,
    required this.secondaryColor,
    required this.fontFamily,
    required this.isDarkMode,
  });

  factory SDKCustomization({
    required Color mainColor,
    required Color secondaryColor,
    required String fontFamily,
    required bool isDarkMode,
  }) {
    instance ??= SDKCustomization._internal(
      mainColor: mainColor,
      secondaryColor: secondaryColor,
      fontFamily: fontFamily,
      isDarkMode: isDarkMode,
    );
    return instance!;
  }
  
  CupertinoThemeData get cupertinoThemeData {
    return CupertinoThemeData(
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    primaryColor: instance!.mainColor,
    textTheme: CupertinoTextThemeData(
      // Text styles for Cupertino components
      textStyle: TextStyle(
        fontFamily: fontFamily,
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 16,
      ),
      actionTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 16,
      ),
      navTitleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 20,
      ),
      navLargeTitleTextStyle: TextStyle(
        fontFamily: fontFamily,
        fontWeight: FontWeight.bold,
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 32,
      ),
      tabLabelTextStyle: TextStyle(
        fontFamily: fontFamily,
        color: isDarkMode ? Colors.white : Colors.black,
        fontSize: 14,
      ),
    ),
    // Equivalent to appBarTheme in Cupertino
    barBackgroundColor: instance!.mainColor,
    scaffoldBackgroundColor: isDarkMode ? Colors.black87 : Colors.white,
    // Button theme
    primaryContrastingColor: instance!.secondaryColor, // Similar to secondary color
  );
}
          
  
  ThemeData get themeData {
    return isDarkMode
        ? ThemeData.dark().copyWith(
            primaryColor: instance!.mainColor,
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontFamily: fontFamily, color: Colors.white,fontSize: 16), // Text color for body
              headlineMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold,color: Colors.white),
              headlineSmall: TextStyle(fontFamily: fontFamily,fontSize: 14,color: Colors.white),
              titleSmall: TextStyle(fontFamily: fontFamily,color:Colors.black,fontSize: 14)
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: instance!.mainColor,
            ),
            cardColor: Colors.black87,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: const Color.fromARGB(255, 0, 0, 0), // Darker background for text fields
              labelStyle: const TextStyle(color: Colors.white), // Increase contrast
              hintStyle: const TextStyle(color: Colors.white), // Lighter hint text for contrast
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.white),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: mainColor, // Button text color
                textStyle: TextStyle(fontFamily: fontFamily),
              ),
            ),
            colorScheme: const ColorScheme.dark().copyWith(
              primary: instance!.mainColor,
              secondary: instance!.secondaryColor,
              
            ),
          )
        : ThemeData.light().copyWith(
            primaryColor: instance!.mainColor,
            textTheme: TextTheme(
              bodyLarge: TextStyle(fontFamily: fontFamily, color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold), // Darker text
              headlineMedium: TextStyle(fontFamily: fontFamily, fontWeight: FontWeight.bold,color: Colors.black),
              headlineSmall: TextStyle(fontFamily: fontFamily,fontSize: 14,color: Colors.black),
              titleSmall: TextStyle(fontFamily: fontFamily,color:Colors.black,fontSize: 14)
            ),
            appBarTheme: AppBarTheme(
              backgroundColor: instance!.mainColor,
            ),
            cardColor: Colors.white,
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: Colors.white, // Lighter background for text fields
              labelStyle: const TextStyle(color: Colors.black), // Increase contrast
              hintStyle: const TextStyle(color: Colors.black54), // Lighter hint text for contrast
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: const BorderSide(color: Colors.black),
              ),
            ),
            elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: instance!.mainColor, // Button text color
                textStyle: TextStyle(fontFamily: fontFamily),
              ),
            ),
            colorScheme: const ColorScheme.light().copyWith(
              primary: instance!.mainColor,
              secondary: instance!.secondaryColor,
            ),
          );
  }
}


