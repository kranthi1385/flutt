import 'package:flutter/material.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:integrated_panel/src/models/question_type.dart';
import 'package:integrated_panel/src/utils/validators.dart';
import 'package:integrated_panel/src/widgets/custom_button.dart';
import 'package:integrated_panel/src/widgets/custom_datepicker.dart';
import 'package:integrated_panel/src/widgets/custom_dropdown.dart';
import 'package:integrated_panel/src/widgets/custom_input_field.dart';
import 'package:integrated_panel/src/widgets/label_text.dart';

class DynamicRegistration extends StatefulWidget {
  const DynamicRegistration(
      {super.key,
      required this.questionsList,
      required this.member,
      required this.onSaved});
  final Function onSaved;
  final List<QuestionData> questionsList;
  final Member member;
  final double textFormFieldRadius = 10.0;

  @override
  State<DynamicRegistration> createState() => _DynamicRegistrationState();
}

class _DynamicRegistrationState extends State<DynamicRegistration> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final Map<String, String> formData = <String, String>{};

  @override
  Widget build(BuildContext context) {
    void onSavedInput(value, propertyName) {
      formData[propertyName] = value;
    }

    Widget dobWidget() {
      return CustomDatePicker(
        textInputType: TextInputType.datetime,
        label: AppLocalization.tr('dateOfBirth'),
        onSaved: onSavedInput,
      );
    }

    List<Widget> getQuestionWidgets() {
      return widget.questionsList.map((e) {
        if (e.answerType == "SingleSelect") {
          return CustomDropdown(
            items: e.translatedAnswers!,
            label: e.translatedQuestion!.displayNameTranslation.toString(),
            onSaved: onSavedInput,
            propertyName: e.translatedQuestion!.questionID.toString(),
            validator: Validators.textValidation,
          );
        } else if (e.answerType == "OpenEnded") {
          return CustomInputText(
            label: e.translatedQuestion!.displayNameTranslation.toString(),
            propertyName: "PostalCode",
            validator: (value, error) {
              if (value != null && value.isNotEmpty) {
                if (e.answerValidationRegularExpression != null) {
                  bool matched =
                      RegExp(e.answerValidationRegularExpression.toString())
                          .hasMatch(value);
                  return matched ? null : "Does not match RegExpression";
                } else {
                  return null;
                }
              } else {
                return error;
              }
            },
            onSaved: onSavedInput,
          );
        } else {
          return const Text("No Questions to ask");
        }
      }).toList(); // Convert the iterable returned by map to a List of Widgets
    }

    return Scaffold(
      body: SafeArea(
          child: SingleChildScrollView(
        padding: const EdgeInsets.all(8),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                CustomText(content: AppLocalization.tr('registration_description'),type: TextType.normal,),
                Visibility(
                  visible: widget.member.birthDate == null ||
                      widget.member.birthDate!.isEmpty,
                  child: dobWidget(),
                ),
                ...getQuestionWidgets(),
                CustomText(content:AppLocalization.tr('consent'),type:TextType.normal),
                Center(
                    child: CustomButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            widget.onSaved(formData);
                          }
                        },
                        text: AppLocalization.tr('continue'))),
              ],
            )),
      )),
    );
  }
}
