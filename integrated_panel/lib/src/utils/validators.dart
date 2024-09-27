import 'package:flutter/material.dart';

class Validators {

  static String? validateEmail(String? email, String error) {
    final RegExp emailRegExp = RegExp(r'^[\w-]+(\.[a-zA-Z0-9_+-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,6}$');
    return (email?.isNotEmpty ?? false) && emailRegExp.hasMatch(email!) ? null : error;
  }

  // Validates a phone number (basic example, can be customized)
  static bool isValidPhoneNumber(String phone) {
    final phoneRegex = RegExp(r'^\+?[0-9]{7,15}$');
    return phoneRegex.hasMatch(phone);
  }

  static String? textValidation(String? value, String error) {
    return (value?.isNotEmpty ?? false) ? null : error;
  }

  static bool isValidDate(String str) {
    final RegExp pattern = RegExp(r'^[0-1][0-9]/[0-3][0-9]/[0-9]{4}$');
    return pattern.hasMatch(str);
  }

  static Future<String?> onSelectDate(
      {required BuildContext context,
      required DateTime initialDate,
      required DateTime firstDate,
      required DateTime lastDate}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );

    if (picked != null) {
      // Format the picked date as MM/DD/YYYY
      var pickedMonth =
          picked.month < 10 ? '0${picked.month}' : '${picked.month}';
      var pickedDay = picked.day < 10 ? '0${picked.day}' : '${picked.day}';
      return '$pickedMonth/$pickedDay/${picked.year}';
    }
    return null;
  }

}
