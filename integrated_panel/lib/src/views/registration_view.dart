// import 'dart:io';

// import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:integrated_panel/src/models/question_type.dart';
import 'package:integrated_panel/src/utils/constants.dart';
import 'package:integrated_panel/src/utils/logger.dart';
import 'package:integrated_panel/src/widgets/dynamic_registration.dart';
import 'package:integrated_panel/src/widgets/loader.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A StatefulWidget that renders the registration view within the SDK.
///
/// This widget handles the registration process by displaying the necessary
/// UI components and managing user interactions. It communicates the results
/// of the registration process through callback functions.
///
/// **Parameters:**
/// - [appKey]: A unique key associated with the application, used for authentication or identification.
/// - [member]: An instance of the [Member] class containing member details.
/// - [onSaved]: A callback function invoked when the registration is successfully saved.
/// - [onError]: A callback function invoked when an error occurs during registration.
/// - [cultureId]: An optional parameter specifying the culture or locale identifier. Defaults to `1` if not provided.
class RenderRegistrationViewSDK extends StatefulWidget {
  /// Creates a [RenderRegistrationViewSDK] widget.
  ///
  /// All parameters marked as `required` must be provided when creating an instance.
  /// The [cultureId] parameter is optional and defaults to `1` if not specified.
  const RenderRegistrationViewSDK({
    super.key,
    required this.appKey,
    required this.member,
    required this.onSaved,
    required this.onError,
    this.cultureId = 1,
  });

  /// The culture or locale identifier.
  ///
  /// This parameter can be used to localize the registration view based on
  /// different cultures or languages. It defaults to `1` if not provided.
  final int? cultureId;

  /// Callback function invoked when the registration is successfully saved.
  ///
  /// This function allows the parent widget or controller to handle the success
  /// event, such as navigating to another screen or displaying a success message.
  final Function onSaved;

  /// Callback function invoked when an error occurs during registration.
  ///
  /// This function allows the parent widget or controller to handle errors,
  /// such as displaying error messages or logging issues.
  final Function onError;

  /// An instance of the [Member] class containing details about the member being registered.
  ///
  /// The [Member] class typically includes information such as name, email,
  /// contact details, and other relevant registration data.
  final Member member;

  /// A unique key associated with the application.
  ///
  /// The [appKey] is used for authentication, identification, or configuration
  /// purposes during the registration process.
  final String appKey;  

  @override
  State<RenderRegistrationViewSDK> createState() =>
      _RenderRegistrationViewSDK();
}


class _RenderRegistrationViewSDK extends State<RenderRegistrationViewSDK> {
  final List<String> formData = [];

  onSavedInput(value) async {
    try {
      List<RegistrationAnswers> rs = [];
      var member = value as Map<String, dynamic>;
      var mem = Member.fromJson(member);
      for (final m in member.entries) {
        if (int.tryParse(m.key) is int) {
          RegistrationAnswers ras = RegistrationAnswers(questionID: int.parse(m.key));
          var ans = Answers();
          ans.answerID = int.parse(m.value);
          ras.answers = List.filled(1, ans);
          rs.add(ras);
        }
      }
      mem.isActive = widget.member.isActive;
      mem.isTest = widget.member.isTest;
      mem.partnerGUID = widget.member.partnerGUID;
      mem.memberCode = widget.member.memberCode;
      mem.registrationAnswers = rs;
      var json = mem.toJson();
      if(Logger.isMockMode()){
        widget.onSaved(mem.memberCode,mem);
        return;
      }
      await MemberManage.updateMember(member: json);
      final prefs = await SharedPreferences.getInstance();
      prefs.setBool('dataCheck', true);
      Constants.isDataCheck = true;
      widget.onSaved(mem.memberCode,mem);
    } catch (ex,stacktrace) {
      Logger.error(ex.toString(),stacktrace);
      widget.onError(ex.toString());
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<dynamic>> fetchData() async {
    Map<String,dynamic> memberMapping = widget.member.toJson();
    List<Questions> missingQuestions = Constants.getMissingQuestions(memberMapping);
    List<Future<QuestionData>> futureList = [];
    for (var e in missingQuestions) {
      if(int.tryParse(e.value) != null){
        final future = MemberManage.getQuestionInfo(appKey: widget.appKey,questionId:e.value,culture: Constants.cultureId.toString());
        futureList.add(future);
      }
    }
    // Wait for both futures to complete
    final results = await Future.wait(futureList);
    return results;
  }

  @override
  Widget build(BuildContext context) {
    return _buildMaterialLayout();
  }



Widget _buildMaterialLayout() {
  return Theme(
    data: SDKCustomization.instance!.themeData,
    child: FutureBuilder(
      future: fetchData(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ProgressBar(); // Assuming this is a Material Progress Indicator
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return LayoutBuilder(builder: (context, constraints) {
            double maxWidth = constraints.maxWidth > 600
                ? 600
                : MediaQuery.of(context).size.shortestSide;
            return Center(
              child: SizedBox(
                width: maxWidth,
                child: DynamicRegistration(
                  questionsList: snapshot.data,
                  onSaved: onSavedInput,
                  member: widget.member,
                ),
              ),
            );
          });
        }
      },
    ),
  );
}
}



// https://training.ups.toluna.com/TrafficUI/MSCUI/page.aspx?pgtid=22