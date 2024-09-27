import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

class AppLocalization {
  Locale locale;
  static late Map<String, String>? _localizedStrings;

  AppLocalization(this.locale);

  // Load the JSON file for the given locale
  Future<void> load() async {
    String jsonString = await rootBundle.loadString('packages/integrated_panel/assets/translations/${locale.languageCode}-${locale.countryCode}.json');
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    _localizedStrings = jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  Future<void> setLocal(Locale locale) async {
    this.locale = locale;
    await load();
  }
  // Retrieve the translated value for a given key
  static String tr(String key) {
    return _localizedStrings?[key] ?? key;
  }
  
}
