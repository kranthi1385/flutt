import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_integrate_ip/surveys_view.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:uuid/uuid.dart';

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({super.key});

  @override
  State<RegistrationForm> createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  onSaved(panlistId,member) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SurveyView(
              partnerGUID: "5EEBF4DD-D7A6-4762-93DB-928B66FC043F",
              panlistId: panlistId,
            ),
          ));
    }
  }

  onError(String errormessage) {
    log("something went wrong");
  }

  @override
  Widget build(BuildContext context) {
    var uuid = const Uuid().v4();
    Member mem = Member(memberCode: uuid);
    mem.partnerGUID = "5EEBF4DD-D7A6-4762-93DB-928B66FC043F";
    return Scaffold(
        appBar: AppBar(title: const Text("Registration")),
        body: MemberManage.registrationView(
          member: mem,
          onSaved: onSaved,
          onError: onError,
        ));
  }
}
