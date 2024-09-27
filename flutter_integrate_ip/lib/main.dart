import 'dart:convert';
import 'dart:developer';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_integrate_ip/utils/utils.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
// Declare a late variable to hold the Member object.
  late Member member;

// Get the current platform brightness.
  final Brightness brightness =
      WidgetsBinding.instance.window.platformBrightness;

// Get an instance of SharedPreferences.
  final prefs = await SharedPreferences.getInstance();

// Check if the 'member' key exists in SharedPreferences.
  if (prefs.containsKey('member')) {
    // If it exists, retrieve the member data from SharedPreferences and decode it from JSON.
    final mem = jsonDecode(prefs.getString('member').toString());
    // Create a new Member object from the decoded JSON data.
    member = Member.fromJson(mem);
  } else {
    // If the 'member' key does not exist, generate a new UUID.
    var uuid = const Uuid().v4();
    log(uuid);

    // Create a new Member object with default values.
    member = Member(
      memberCode: uuid,
      partnerGUID: '5EEBF4DD-D7A6-4762-93DB-928B66FC043F',
      isActive: true,
      isTest: true,
      birthDate: '02/02/1997',
      postalCode: '45230',
    );
  }

// Define the app key as a constant.
  const appkey = 'BD9A4EC1-4A13-4A73-9F41-386600C1454B';

// Create a new SDKCustomization object with the specified colors, font family, and dark mode setting.
  final customization = SDKCustomization(
    mainColor: Colors.blue,
    secondaryColor: Colors.green,
    fontFamily: 'serif',
    isDarkMode: brightness == Brightness.dark ? true : false,
  );

// Initialize the IntegratedPanel SDK with the required configurations.
await IntegratedPanel.initialize(
  appKey: appkey, // A unique key associated with your application, used for authentication and identification.
  debugMode: true, // Enables debug mode for verbose logging and easier troubleshooting during development.
  mockMode: false, // Disables mock mode to ensure real API interactions are performed.
  language: 'es-US', // Sets the language for the SDK's user interface.
  cultureId: 3, // Specifies the culture or locale identifier, which may affect formatting and localization settings.
  customization: customization, // Provides customization options for the SDK's appearance and behavior, allowing for UI tweaks and feature toggles.
  member: member, // Passes a [Member] object containing user-specific information required for personalized interactions within the SDK.
);

  runApp(const HomePage());
}

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    onSurveyEnd(message, survey) {
      log(survey);
      log(message);
    }

    onSaved(message, Member member) async {
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('member', jsonEncode(member.toJson()));
      log(message);
    }

    onError(message) {
      log(message);
    }

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Integrated Panel',
        theme: lightTheme,
        darkTheme: darkTheme,
        themeMode: ThemeMode.dark,
        home: SurveyFlow(
          onError: onError,
          onSaved: onSaved,
          onSurveyEnd: onSurveyEnd,
        ));
  }
}

// https://training.ups.toluna.com/TrafficUI/MSCUI/page.aspx?pgtid=22