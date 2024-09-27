import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:integrated_panel/integrated_panel.dart';

class SurveyView extends StatefulWidget {
  const SurveyView({super.key,required this.partnerGUID,required this.panlistId,});
  final String partnerGUID;
  final String panlistId;

  @override
  State<SurveyView> createState() => _SurveyViewState();
}

class _SurveyViewState extends State<SurveyView> {


  @override
  Widget build(BuildContext context) {
    final memberGuid =  widget.panlistId.isNotEmpty ? widget.panlistId :
    "cdd234ce-32a8-4bd1-b103-18d33a11123d";
    final String partnerGuid = widget.partnerGUID.isNotEmpty ? widget.partnerGUID : "5EEBF4DD-D7A6-4762-93DB-928B66FC043F";
    return Scaffold(
      // drawer: const Sidebar(),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:const Text("Surveys"),
        ),
      body:  DashboardApi.getSurveyView(
          partnerGuid:partnerGuid,
          panlistId: memberGuid ,
          onSurveyEnd: (String message,String surveyId){
              log(message);
              log(surveyId);
          },
          )
    );
  }
}
