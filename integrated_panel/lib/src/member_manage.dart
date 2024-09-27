import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:integrated_panel/src/models/culture.dart';
import 'package:integrated_panel/src/services/api_service.dart';
import 'package:integrated_panel/src/models/member.dart';
import 'package:integrated_panel/src/models/question_type.dart';
import 'package:integrated_panel/src/utils/constants.dart';
import 'package:integrated_panel/src/views/registration_view.dart';

class MemberManage{

  // Private constructor to prevent instantiation
  MemberManage._();

  /// Adds a new member to the system.
  ///
  /// This method takes a [Map] containing member details and delegates the
  /// addition process to the internal [_MemberManage] class.
  ///
  /// **Parameters:**
  /// - [member]: A [Map<String, dynamic>] containing the member's details to be added.
  ///
  /// **Returns:**
  /// A [Future<String>] that resolves to a confirmation message or an error message.
  static Future<String> addMember({required Map<String, dynamic> member}) async { 
    return await _MemberManage()._addMember(member: member);
  }

  /// Updates an existing member's details in the system.
  ///
  /// This method takes a [Map] containing updated member details and delegates the
  /// update process to the internal [_MemberManage] class.
  ///
  /// **Parameters:**
  /// - [member]: A [Map<String, dynamic>] containing the member's updated details.
  ///
  /// **Returns:**
  /// A [Future<String>] that resolves to a confirmation message or an error message.
  static Future<String> updateMember({required Map<String, dynamic> member}) async { 
    return await _MemberManage()._updateMember(member: member);
  }

   /// Retrieves a member's details based on their [memberCode] and [partnerGuid].
  ///
  /// This method fetches the member information from the internal [_MemberManage] class.
  ///
  /// **Parameters:**
  /// - [memberCode]: A [String] representing the unique code of the member.
  /// - [partnerGuid]: A [String] representing the unique identifier of the partner.
  ///
  /// **Returns:**
  /// A [Future<Member>] that resolves to a [Member] object containing the member's details.
  static Future<Member> getMember({
    required String memberCode,
    required String partnerGuid,
  }) async {
    return await _MemberManage()._getMember(memberCode: memberCode, partnerGuid: partnerGuid);
  }

  /// Retrieves Question details based on their [memberCode] and [partnerGuid].
  ///
  /// This method fetches the member information from the internal [_MemberManage] class.
  ///
  /// **Parameters:**
  /// - [memberCode]: A [String] representing the unique code of the member.
  /// - [partnerGuid]: A [String] representing the unique identifier of the partner.
  ///
  /// **Returns:**
  /// A [Future<Member>] that resolves to a [Member] object containing the member's details.
  static Future<QuestionData> getQuestionInfo({required String appKey, required String questionId,required String culture}) async{
    return await _MemberManage()._getQuestionInfo(appKey:appKey, qestionId: questionId,culture: culture);
  }


 /// Renders the registration view SDK widget.
  ///
  /// This method creates and returns an instance of [RenderRegistrationViewSDK] with the provided parameters.
  ///
  /// **Parameters:**
  /// - [onSaved]: A [Function] callback invoked when the registration is successfully saved.
  /// - [member]: A [Member] object containing the member's details.
  /// - [onError]: A [Function] callback invoked when an error occurs during registration.
  ///
  /// **Returns:**
  /// A [Widget] that represents the registration view SDK.
  static Widget registrationView({required Function onSaved,required Member member,required Function onError}){
    return RenderRegistrationViewSDK(appKey: Constants.appKey, onSaved: onSaved, member: member, onError: onError);
  } 
}


class _MemberManage{

  final Map<String,String> _headers = {
    "Content-Type": "application/json",
    "Accept":"application/json;version=2.0"
};

  Future<String> _addMember({required Map<String,dynamic> member}) async{
    ClientService cs = ClientService(url :EndPoints.user.url);
    Map<String,dynamic> body = member;
    String response = await cs.post(headers: _headers,body: jsonEncode(body));
    return response;
  }

  Future<String> _updateMember({required Map<String,dynamic> member}) async{
    ClientService cs = ClientService(url :EndPoints.user.url);
    Map<String,dynamic> body = member;
    String response = await cs.put(headers: _headers,body: jsonEncode( body));
    return response;
  }

  Future<Member> _getMember({required String memberCode,required String partnerGuid}) async{
    ClientService cs = ClientService(url: EndPoints.user.url);
    Map<String,dynamic> qparams = <String,dynamic> {
      'memberCode':memberCode,
      'partnerGuid':partnerGuid,
    };
    String response = await cs.get( headers: _headers,params:qparams);
    Member mem = Member.fromJson(jsonDecode(response) as Map<String,dynamic>);
    return mem;
  }
  
   Future<List<Culture>> _getCultures() async{
    ClientService cs = ClientService(url: EndPoints.culture.url);
    String response = await cs.get(headers: _headers);
     _headers.remove("Accept");
      _headers["PARTNER_AUTH_KEY"] = Constants.appKey;
    List<Culture> cultures = (jsonDecode(response) as List).map((e)=> Culture.fromJson(e)).toList();
    return cultures;
  }

  Future<QuestionData> _getQuestionInfo({required String appKey, required String qestionId,required String culture}) async{
      String url = EndPoints.question.url;
      url =  url.replaceAll("{QuestionId}", qestionId).replaceAll("{CultureId}",culture );
      ClientService cs = ClientService(url:url);
      _headers.remove("Accept");
      _headers["PARTNER_AUTH_KEY"] = Constants.appKey;
      String val = await cs.get(headers: _headers);
      List<QuestionData> qd = (jsonDecode(val) as List).map((e) => QuestionData.fromJson(e)).toList();
      return qd[0];
  }
}
    