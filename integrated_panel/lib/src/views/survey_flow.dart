import 'package:flutter/material.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:integrated_panel/src/utils/constants.dart';
import 'package:integrated_panel/src/views/registration_view.dart';
import 'package:integrated_panel/src/views/surveys_view.dart';
import 'package:integrated_panel/src/widgets/label_text.dart';
import 'package:integrated_panel/src/widgets/loader.dart';
import 'package:integrated_panel/src/widgets/sidebar.dart';

class SurveyFlow extends StatefulWidget {
  const SurveyFlow(
      {super.key,
      required this.onSaved,
      required this.onError,
      required this.onSurveyEnd});
  final Function onSaved;
  final Function onSurveyEnd;
  final Function onError;
  @override
  State<SurveyFlow> createState() => _SurveyFlowState();
}

class _SurveyFlowState extends State<SurveyFlow> {
  bool isLoading = true;
  bool isRegistered = false;
  bool registrationRequired = false;

  // Simulating a background check
  Future<void> checkPanelistDetails() async {
    List<Questions> missingQuestions =
        Constants.getMissingQuestions(Constants.member.toJson());
    if (missingQuestions.isEmpty) {
      setState(() {
        isRegistered = true; // Assume user is not registered yet
        registrationRequired = !isRegistered; // Registration required
        isLoading = false; // Loading completed
      });
    } else {
      setState(() {
        isRegistered = false; // Assume user is not registered yet
        registrationRequired = !isRegistered; // Registration required
        isLoading = false; // Loading completed
      });
    }
  }

  @override
  void initState() {
    super.initState();
    if (Constants.isDataCheck) {
      isLoading = false;
      registrationRequired = false;
    } else {
      checkPanelistDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    final heading = isLoading
        ? ''
        : registrationRequired
            ? AppLocalization.tr('almost_there')
            : AppLocalization.tr('survey');
    return Theme(
        data: SDKCustomization.instance!.themeData,
        child: Scaffold(
          drawer: const Sidebar(),
            appBar: AppBar(
              title: CustomText(content: heading, type: TextType.header),
            ),
            body: isLoading
                ? const ProgressBar()
                : registrationRequired
                    ? RenderRegistrationViewSDK(
                        appKey: Constants.appKey,
                        member: Constants.member,
                        onError: widget.onError,
                        onSaved: (memberCode, member) {
                          // Save member details
                          widget.onSaved(memberCode, member);
                          setState(() {
                            isRegistered = true;
                            registrationRequired = false;
                          });
                        })
                    : RenderSurveyViewSDK(
                        partnerGuid: Constants.member.partnerGUID.toString(),
                        panlistId: Constants.member.memberCode.toString(),
                        onSurveyEnd: widget.onSurveyEnd)));
  }
}
