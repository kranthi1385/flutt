import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier{
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  set themeMode(ThemeMode themeMode){
    _themeMode = themeMode;
    notifyListeners();
  }

  void toggleTheme(){
    if(_themeMode == ThemeMode.light){
      themeMode = ThemeMode.dark;
    }else {
      themeMode = ThemeMode.light;
    }
    notifyListeners();
  }
}