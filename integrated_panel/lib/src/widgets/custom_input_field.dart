import 'package:flutter/material.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:integrated_panel/src/widgets/label_text.dart';

class CustomInputText extends StatefulWidget {
  const CustomInputText({
    super.key,
    required this.label,
    required this.propertyName,
    this.textInputType,
    this.errorLabel = "Value Should not be empty",
    required this.validator,
    required this.onSaved,
  });
  final String label;
  final String errorLabel;
  final String propertyName;
  final TextInputType? textInputType;
  final String? Function(String?, String) validator;
  final void Function(String?, String?) onSaved;

  @override
  State<CustomInputText> createState() => _CustomInputTextState();
}

class _CustomInputTextState extends State<CustomInputText> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var error = widget.errorLabel.replaceAll("Value", widget.label);
    error = widget.errorLabel.replaceAll("should not be empty",AppLocalization.tr('error_label'));
    
    return Padding(
        padding: 
        const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(content:" ${widget.label}" , type: TextType.label),
            TextFormField(
              style:const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
              controller: _controller,
              keyboardType: widget.textInputType,
              onSaved: (value) {
                widget.onSaved(value, widget.propertyName);
              },
              validator: (value) {
                return widget.validator(value, error);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ],
        ));
  }
}
