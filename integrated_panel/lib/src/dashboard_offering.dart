import 'dart:convert';
import 'package:integrated_panel/src/services/api_service.dart';
import 'package:flutter/material.dart';
import 'package:integrated_panel/src/models/survey.dart';
import 'package:integrated_panel/src/utils/constants.dart';
import 'package:integrated_panel/src/utils/logger.dart';
import 'package:integrated_panel/src/views/surveys_view.dart';


class DashboardApi{

  DashboardApi._();
  /// Retrieves a list of surveys based on the provided parameters.
  ///
  /// This method fetches surveys from the internal [_DashboardApi] class by
  /// providing the necessary identifiers and preferences.
  ///
  /// **Parameters:**
  /// - [panlistId] (`String`): The identifier for the specific panlist or survey list.
  /// - [partnerGuid] (`String`): A unique identifier for the partner associated with the surveys.
  /// - [noSurveys] (`int`): The number of surveys to retrieve.
  /// - [mobileCompatible] (`bool`, optional): Indicates whether to fetch surveys compatible with mobile devices. Defaults to `true`.
  ///
  /// **Returns:**
  /// A `Future<List<Survey>>` that resolves to a list of [Survey] objects.
  static Future<List<Survey>> getSurveys({required String panlistId,required String partnerGuid,required int noSurveys,bool mobileCompatible=true}) async {
    return _DashboardApi()._getSurveys(panlistId: panlistId, partnerGuid: partnerGuid, noSurveys: noSurveys);
  }
  
  /// Retrieves the next profile survey based on the provided parameters.
  ///
  /// This method fetches the next survey tailored to the user's profile from
  /// the internal [_DashboardApi] class, handling redirection URLs for cancellation
  /// and return actions.
  ///
  /// **Parameters:**
  /// - [panlistId] (`String`): The identifier for the specific panlist or survey list.
  /// - [partnerGuid] (`String`): A unique identifier for the partner associated with the surveys.
  /// - [cancelUrl] (`String`): The URL to redirect the user if they cancel the survey.
  /// - [returnUrl] (`String`): The URL to redirect the user upon successful completion of the survey.
  ///
  /// **Returns:**
  /// A `Future<List<Survey>>` that resolves to a list of [Survey] objects representing the next profile survey.
  static Future<List<Survey>> getNextProfileSurvey({required String panlistId,required String partnerGuid,required String cancelUrl,required String returnUrl}) async {
    return _DashboardApi()._getNextProfileSurvey(panlistId: panlistId, partnerGuid:partnerGuid,cancelUrl:cancelUrl,returnUrl:returnUrl);
  }
  
  /// Renders the survey view SDK widget.
  ///
  /// This method creates and returns an instance of [RenderSurveyViewSDK] with the provided parameters.
  /// The widget is responsible for displaying surveys to the user and handling the survey completion process.
  ///
  /// **Parameters:**
  /// - [partnerGuid] (`String`): A unique identifier for the partner associated with the survey.
  /// - [panlistId] (`String`): The identifier for the specific panlist or survey list.
  /// - [onSurveyEnd] (`Function`): A callback function invoked when the survey is completed.
  ///
  /// **Returns:**
  /// A [Widget] that represents the survey view SDK, ready to be integrated into the widget tree.
  static Widget getSurveyView({required String partnerGuid, required String panlistId,required Function onSurveyEnd}){
    return RenderSurveyViewSDK(partnerGuid: partnerGuid, panlistId: panlistId,onSurveyEnd: onSurveyEnd);
  }

}


class _DashboardApi {
  
  Future<List<Survey>> _getSurveys({required String panlistId,required String partnerGuid,required int noSurveys,bool mobileCompatible=true}) async {
    try{
      Map<String,dynamic> qparams = <String,dynamic> {
        'memberCode':panlistId,
        'partnerGuid':partnerGuid,
        'NumberOfSurveys':"$noSurveys",
        'mobileCompatible':"$mobileCompatible"
      };
      ClientService cls =  ClientService(url:EndPoints.survey.url);
      String val = await cls.get(headers: {},params:qparams);
      var json = jsonDecode(val);
      if(json is List){
        final data = (json).cast<Map<String,dynamic>>();
        List<Survey> surveys = data.map((e) => Survey.fromMap(e)).toList();
        return surveys;  
      } else {
        Logger.info(val);
        return List.empty();
      }
    }
    catch (ex){
      rethrow;
    }
  }

  Future<List<Survey>> _getNextProfileSurvey({required String panlistId,required String partnerGuid,required String cancelUrl,required String returnUrl}) async {
    
    Map<String,dynamic> qparams = <String,dynamic> {
      'memberCode':panlistId,
      'partnerGuid':partnerGuid,
      'cancelURl':cancelUrl,
      'returnUrl':returnUrl
    };
    ClientService cls =  ClientService(url: EndPoints.survey.url);
    String val = await cls.get(headers: {},params:qparams);
    final data = (jsonDecode(val) as List).cast<Map<String,dynamic>>();
    List<Survey> surveys = data.map((e) => Survey.fromMap(e)).toList();
    return surveys;
  }

}