import 'package:flutter/material.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:integrated_panel/src/utils/constants.dart';
import 'package:integrated_panel/src/utils/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IntegratedPanel {
 static Future<void> initialize({
  /// The required app key.
  required String appKey,
  
  /// The required member object.
  required Member member,
  
  /// Optional debug mode flag. Defaults to false.
  bool debugMode = false,
  
  /// Optional mock mode flag. Defaults to false.
  bool mockMode = false,

  /// Optional QA flag. Defaults to false.
  bool isQAEnabled = false,
  
  /// The language code. Defaults to "en-US".
  String language = "en-US",
  
  /// The culture ID. Defaults to 1.
  int cultureId = 1,
  
  /// The required SDK customization object.
  required SDKCustomization customization,
}) async {
  // Enable logging if debug mode is enabled.
  Logger.enableLogging(debugMode);
  
  // Enable mock mode if it's enabled.
  Logger.enableMockMode(mockMode);
  
  // Set the app key and member in the Constants class.
  Constants.appKey = appKey;
  Constants.member = member;
  
  // Get an instance of SharedPreferences.
  final prefs = await SharedPreferences.getInstance();
  
  // Set the language code in the Constants class.
  Constants.langCode = language;

  // Set QA flag in the Constants class
  Constants.isQAEnabled = isQAEnabled;
  
  // Get the data check flag from SharedPreferences, defaulting to false if not found.
  bool isDataCheck = prefs.getBool('dataCheck') ?? false;
  
  // Set the data check flag in the Constants class.
  Constants.isDataCheck = isDataCheck;
  
  // Split the language code into its components (e.g., "en-US" -> ["en", "US"]).
  var locals = language.split('-');
  
  // Set the culture ID in the Constants class.
  Constants.cultureId = cultureId;
  
  // If the member is valid and not in mock mode, perform the following operations.
  if (member.isValid() && !mockMode) {
    // Create a list to hold the futures.
    List<Future<dynamic>> futureList = [];
    
    // Add the AppLocalization load future to the list.
    futureList.add(AppLocalization(Locale(locals[0], locals[1])).load());
    
    // If data check is not enabled, add the MemberManage add member future to the list.
    if (!isDataCheck) {
      futureList.add(MemberManage.addMember(member: member.toJson()));
    }
    
    // Wait for all the futures to complete.
    await Future.wait(futureList);
  } else {
    // If the member is not valid or in mock mode, load the AppLocalization and log an error.
    await AppLocalization(Locale(locals[0], locals[1])).load();
    Logger.error('Member is not valid or in Mock', null);
  }
}
}
// Add Comments to this code file ?