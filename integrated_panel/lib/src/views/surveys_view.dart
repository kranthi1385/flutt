import 'package:flutter/material.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:integrated_panel/src/models/rejectiontypes.dart';
import 'package:integrated_panel/src/models/survey.dart';
import 'package:integrated_panel/src/utils/constants.dart';
import 'package:integrated_panel/src/utils/logger.dart';
import 'package:integrated_panel/src/widgets/label_text.dart';
import 'package:integrated_panel/src/widgets/loader.dart';
import 'package:integrated_panel/src/widgets/survey_card.dart';
import 'package:integrated_panel/src/widgets/web_view_component.dart';

/// This widget is responsible for displaying surveys to the user and handling
/// the survey completion process. It communicates the end of the survey through
/// a callback function provided by the parent widget or controller.
///
/// **Parameters:**
/// - [partnerGuid]: A unique identifier for the partner associated with the survey.
/// - [panlistId]: An identifier for the specific panlist or survey list.
/// - [onSurveyEnd]: A callback function invoked when the survey is completed.
class RenderSurveyViewSDK extends StatefulWidget {
  /// Creates a [RenderSurveyViewSDK] widget.
  ///
  /// All parameters marked as `required` must be provided when creating an instance.
  const RenderSurveyViewSDK({
    super.key,
    required this.partnerGuid,
    required this.panlistId,
    required this.onSurveyEnd,
  });

  /// A unique identifier for the partner associated with the survey.
  ///
  /// This GUID is used to fetch surveys specific to the partner and ensure
  /// that the correct survey data is loaded and displayed to the user.
  final String partnerGuid;

  /// An identifier for the specific panlist or survey list.
  ///
  /// The [panlistId] helps in categorizing and retrieving the appropriate
  /// set of surveys that belong to a particular list or category.
  final String panlistId;

  /// Callback function invoked when the survey is completed.
  ///
  /// This function allows the parent widget or controller to handle the
  /// survey completion event, such as navigating to another screen,
  /// updating the UI, or performing other actions based on the survey result.
  ///
  /// **Signature:**
  /// ```dart
  /// void Function()
  /// ```
  final Function onSurveyEnd;

  @override
  State<RenderSurveyViewSDK> createState() => _RenderSurveyViewSDKState();
}

class _RenderSurveyViewSDKState extends State<RenderSurveyViewSDK> {
  static const int initialSurveyCount = 5;
  static const int extendedSurveyCount = 20;
  late int _noSurveys = initialSurveyCount;
  late List<Questions> missingQuestions;
  late String dob;
  late String postalCode;
  late List<RejectionType> rejectionTypes;

  Future<List<Survey>> fetchAllDetails() async {
    try {
      if (Logger.isMockMode()) {
        return await Constants.loadSurveys(_noSurveys);
      }

      var surveys = await DashboardApi.getSurveys(
        partnerGuid: widget.partnerGuid,
        panlistId: widget.panlistId,
        noSurveys: _noSurveys,
        mobileCompatible: true,
      );

      rejectionTypes = await RejectionType.loadRejectionTypes();
      return surveys;
    } catch (e, stackTrace) {
      Logger.error(e.toString(), stackTrace); // Add logging or error handling
      return [];
    }
  }

  List<Survey> sortSurveys(List<Survey> surveys) {
    surveys.sort((a, b) {
      // Sort by IR descending (higher IR first)
      int biR = b.iR ?? 0;
      int aiR = a.iR ?? 0;
      int irComparison = biR.compareTo(aiR);
      if (irComparison != 0) return irComparison;

      // Sort by Duration ascending (convert String to int)
      int durationA = int.tryParse(a.duration.toString()) ?? 0;
      int durationB = int.tryParse(b.duration.toString()) ?? 0;
      int durationComparison = durationA.compareTo(durationB);
      if (durationComparison != 0) return durationComparison;

      double partnerAmountA = a.partnerAmount ?? 0.0;
      double partnerAmountB = b.partnerAmount ?? 0.0;
      // If Duration is also the same, sort by PartnerAmount descending (higher amount first)
      int partnerAmountComparison = partnerAmountB.compareTo(partnerAmountA);
      return partnerAmountComparison;
    });

    return surveys;
  }

  void handleRejection(String message, Survey survey) {
    if (message.contains('success')) {
      final content = survey.memberAmount! > 0.0 
  ? AppLocalization.tr('success_message'):AppLocalization.tr('success_message');
          
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomText(
        content: content,
        type: TextType.normal,
      )));
      widget.onSurveyEnd("success", survey.toMap().toString());
    }
    if (message.contains('Error')) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: CustomText(
        content: AppLocalization.tr('error'),
        type: TextType.normal,
      )));
      widget.onSurveyEnd("success", survey.toMap().toString());
    }
    final rejectionID = RejectionType.extractRejectionID(message);
    if (rejectionID == null) {
      return;
    }
    if (rejectionTypes.isEmpty) {
      return;
    }
    final rejection = rejectionTypes.firstWhere(
      (type) => type.respondentRejectionTypeID == rejectionID,
    );
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(rejection.partnerRejectionDescription)));
    widget.onSurveyEnd(
        rejection.partnerRejectionDescription, survey.toMap().toString());
  }

  onTakeSurvey(Survey survey) async {
    var result = await Navigator.push(
        context,
        BottomToTopPageRoute(
            widget: WebViewScreen(
          url: survey.uRL.toString(),
        )));
    handleRejection(result, survey);
    setState(() {
      _noSurveys = initialSurveyCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: SDKCustomization.instance!.themeData,
      child: FutureBuilder(
        future: fetchAllDetails(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const ProgressBar();
          } else if (snapshot.hasError) {
            Logger.error(snapshot.error.toString(), snapshot.stackTrace);
            return Center(
                child: Text(snapshot.error.toString().replaceAll('"', '')));
          } else {
            List<Survey> futureSurveys = sortSurveys(snapshot.data);
            if (futureSurveys.isEmpty) {
              return Center(child: Text(AppLocalization.tr('no_survey')));
            }
            double maxWidth = MediaQuery.of(context).size.width > 600
                ? 600
                : MediaQuery.of(context).size.width * 0.9;
            return LayoutBuilder(builder: (context, constraints) {
              // Adjust the card width based on screen size
              return ListView.builder(
                itemCount: futureSurveys.length + 1,
                itemBuilder: (context, index) {
                  if (index == futureSurveys.length) {
                    // When we reach the end of the list, show the "Show More" button
                    if (futureSurveys.length == initialSurveyCount) {
                      return Center(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 50),
                          ),
                          child: CustomText(
                              content: AppLocalization.tr('show_more'),
                              type: TextType.normal),
                          onPressed: () {
                            setState(() {
                              _noSurveys =
                                  extendedSurveyCount; // Load more surveys
                            });
                          },
                        ),
                      );
                    } else {
                      return const SizedBox
                          .shrink(); // Don't show the button if not at the initial count
                    }
                  }
                  return Center(
                    child: SizedBox(
                      width: maxWidth,
                      child: SurveyCard(
                        surveyId: futureSurveys[index].surveyID.toString(),
                        surveyName: futureSurveys[index].name.toString(),
                        reward: futureSurveys[index].memberAmount.toString(),
                        date: futureSurveys[index].duration.toString(),
                        surveyUrl: futureSurveys[index].uRL.toString(),
                        onTakeSurvey: () {
                          onTakeSurvey(futureSurveys[index]);
                        },
                      ),
                    ),
                  );
                },
              );
            });
          }
        },
      ),
    );
  }
}
