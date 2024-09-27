// lib/src/widgets/custom_date_picker.dart
import 'package:flutter/material.dart';
import 'package:integrated_panel/integrated_panel.dart';
import 'package:integrated_panel/src/widgets/label_text.dart';
import '../utils/validators.dart';

class CustomDatePicker extends StatefulWidget {
  final String label;
  final String errorLabel;
  final TextInputType textInputType;
  final Function(String,String) onSaved;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;

  const CustomDatePicker({
    super.key,
    required this.label,
    required this.textInputType,
    required this.onSaved,
    this.errorLabel = "Value should not be empty",
    this.initialDate,  // Nullable to provide defaults internally
    this.firstDate,
    this.lastDate,
  });

  @override
  State<CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  final TextEditingController _controller = TextEditingController();
  String _selectedDOB = "";

  Future<void> _selectDate(BuildContext context) async {
    final selectedDate = await Validators.onSelectDate(
      context: context,
      initialDate: DateTime(DateTime.now().year-1),
      firstDate: DateTime(1900),
      lastDate: DateTime(DateTime.now().year-1),
    );

    if (selectedDate != null) {
      setState(() {
        _selectedDOB = selectedDate;
        _controller.text = _selectedDOB;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var error = widget.errorLabel.replaceAll("Value", widget.label);
    error = widget.errorLabel.replaceAll("should not be empty",AppLocalization.tr('error_label'));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(content: widget.label, type: TextType.label),
          TextFormField(
            controller: _controller,
            style: const TextStyle(fontSize: 16),
            maxLines: 1,
            keyboardType: widget.textInputType,
            onSaved: (value) => widget.onSaved(_controller.text,'BirthDate'),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return error;
              } else if (!Validators.isValidDate(value)) {
                return "Invalid date format MM/DD/YYYY";
              }
              return null;
            },
            decoration: InputDecoration(
              hintText: 'MM/DD/YYYY',
              contentPadding: const EdgeInsets.fromLTRB(10, 8, 8, 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: () => _selectDate(context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
