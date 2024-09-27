import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:integrated_panel/src/models/survey.dart';

class Constants {
  static String langCode = "en-US";
  static int cultureId = 1;
  static const apiTimeout = 30;
  static late Member member;
  static late String appKey;
  static bool isDataCheck = false;
  static bool isQAEnabled = false;

  static var ipCoreUrl = isQAEnabled
      ? "https://upstraffic.qab.tolunainsights-internal.com"
      : "https://training.ups.toluna.com";
  static const ipRefDataUrl = "http://tws.toluna.com/";

  static final Map<String, String> _apiUrls = {
    "survey": "$ipCoreUrl/IntegratedPanelService/api/Surveys",
    "user": "$ipCoreUrl/IntegratedPanelService/api/Respondent",
    "profile":
        "$ipCoreUrl/IntegratedPanelService/api/Profile/GetNextProfileUrl",
    "question":
        "$ipRefDataUrl/IPUtilityService/ReferenceData/QuestionAndAnswersData/{QuestionId}/{CultureId}",
    "culture": "$ipRefDataUrl/IPUtilityService/ReferenceData/Cultures"
  };
  static String getUrl(String key) {
    return _apiUrls[key]!;
  }

// Function to check missing questions
  static List<Questions> getMissingQuestions(Map<String, dynamic> member) {
    List<Questions> missingQuestions = [];
    // Extract RegistrationAnswers
    if (member.containsKey('RegistrationAnswers')) {
      // Handle birthdate separately
      if (member['BirthDate'] == null ||
          (member['BirthDate'] as String).isEmpty) {
        missingQuestions.add(Questions.birthdate);
      }
      List<dynamic> registrationAnswers = member['RegistrationAnswers'];
      // Check each enum question if it exists in RegistrationAnswers
      for (Questions question in Questions.values) {
        bool questionFound = false;
        // Check if this question is in RegistrationAnswers
        for (var answerGroup in registrationAnswers) {
          if (answerGroup['QuestionID'].toString() == question.value) {
            questionFound = true;
            break;
          }
        }
        // If the question is not found in answers, mark it as missing
        if (!questionFound) {
          missingQuestions.add(question);
        }
      }
    } else {
      // If 'RegistrationAnswers' is not present, assume all questions are missing
      missingQuestions = List.from(Questions.values);
    }
    // Handle PostalCode separately
    if (member['PostalCode'] != null &&
        (member['PostalCode'] as String).isNotEmpty) {
      missingQuestions.remove(Questions.postalCode);
    }

    return missingQuestions;
  }

  static Future<List<Survey>> loadSurveys(int count) async {
    String jsonString = await rootBundle
        .loadString('packages/integrated_panel/assets/surveys_info.json');
    var json = jsonDecode(jsonString);
    final data = (json as List).cast<Map<String, dynamic>>();
    Iterable<Survey> surveys = data.map((e) => Survey.fromMap(e));
    return surveys.take(count).toList();
  }
}

enum EndPoints { user, profile, survey, question, culture }

extension EndPointsExtension on EndPoints {
  String get url => Constants.getUrl(name);
}

enum Questions {
  birthdate,
  gender,
  country,
  postalCode,
  // ethnicity,
  // state,
  // city,
  // language
}

extension QuestionsExtension on Questions {
  String get value {
    switch (this) {
      case Questions.birthdate:
        return 'BirthDate';
      case Questions.gender:
        return '1001007';
      case Questions.country:
        return '1001001';
      case Questions.postalCode:
        return '1001042';
      // case Questions.ethnicity:
      //   return '1001012';
      //case Questions.state:
      //   return '2910012';
      //case Questions.city:
      //   return '1001032';
      // case Questions.language:
      //   return '1001002';
      default:
        return '';
    }
  }
}
