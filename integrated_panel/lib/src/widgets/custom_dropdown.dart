import 'package:flutter/material.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:integrated_panel/src/models/question_type.dart';
import 'package:integrated_panel/src/widgets/label_text.dart';

class CustomDropdown extends StatefulWidget {
  const CustomDropdown(
      {super.key,
      required this.label,
      required this.propertyName,
      required this.items,
      required this.validator,
      required this.onSaved,
      this.textStyle,
      this.errorLabel = "Value Should not be empty",
      this.textInputType,
      });
  final String label;
  final String errorLabel;
  final String propertyName;
  final TextStyle? textStyle; 
  final TextInputType? textInputType;
  final List<TranslatedAnswers> items;
  final String? Function(String?, String) validator;
  final void Function(String, String) onSaved;

  @override
  State<CustomDropdown> createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  final _controller = TextEditingController();
  String? selectedItem;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var label = widget.label;
    var items = widget.items.map((e) => DropdownMenuItem(
            value: e.answerID.toString(),
            child: CustomText(content:e.translation.toString(),type: TextType.normal,)))
        .toList();
    items.sort((a, b) {
      return (a.child as CustomText).content.compareTo((b.child as CustomText).content);
    });
    var error = widget.errorLabel.replaceAll("Value", label).replaceAll(':', '');
    error = widget.errorLabel.replaceAll("should not be empty",AppLocalization.tr('error_label'));
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(content:" $label",type:TextType.label),
            TextFormField(
              style: const TextStyle(fontSize: 14),
              maxLines: 1,
              onSaved: (value) {
                widget.onSaved(selectedItem!, widget.propertyName);
              },
              controller: _controller,
              validator: (value) {
                return widget.validator(selectedItem, error);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
                // hintText: label,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                suffixIcon: DropdownButtonHideUnderline(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: DropdownButton<String>(
                      borderRadius: const BorderRadius.all(
                          Radius.circular(14)),
                      value: selectedItem, // Currently selected item
                      // icon: const Icon(Icons.arrow_downward), // Down arrow icon
                      // iconSize: 24.0, // Icon size
                      isExpanded: true,
                      isDense: true,
                      // List of dropdown items
                      items: items,
                      onChanged: (String? newValue) {
                        setState(() {
                          selectedItem = newValue!; // Update selected item
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
