
import 'dart:convert';

import 'package:flutter/services.dart';

class RejectionType {
  final int respondentRejectionTypeID;
  final String partnerRejectionName;
  final String partnerRejectionDescription;
  static List<RejectionType> _rejectionTypes = [];
  RejectionType({
    required this.respondentRejectionTypeID,
    required this.partnerRejectionName,
    required this.partnerRejectionDescription,
  });

   factory RejectionType.fromJson(Map<String, dynamic> json) {
    return RejectionType(
      respondentRejectionTypeID: json['RespondentRejectionTypeID'],
      partnerRejectionName: json['PartnerRejectionName'],
      partnerRejectionDescription: json['PartnerRejectionDescription'],
    );
   }

    static int? extractRejectionID(String url) {
    final uri = Uri.parse(url);
    final rejectionIDParam = uri.queryParameters['rejectionID'];
    return rejectionIDParam != null ? int.tryParse(rejectionIDParam) : null;
  }

   static Future<List<RejectionType>> loadRejectionTypes() async {
    if(_rejectionTypes.isNotEmpty){
      return _rejectionTypes;
    }
    final jsonString = await rootBundle.loadString("packages/integrated_panel/assets/rejection_types.json");
    final List<dynamic> jsonResponse = json.decode(jsonString);
    _rejectionTypes = jsonResponse.map((item) => RejectionType.fromJson(item)).toList();
    return _rejectionTypes;
  }

}


