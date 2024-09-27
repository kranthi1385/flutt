import 'package:flutter/material.dart';
import 'package:integrated_panel/src/widgets/label_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key,
                      required this.onPressed,
                      required this.text});

  final VoidCallback onPressed;
  final String text;
  @override
  Widget build(BuildContext context) {
    return FilledButton(
            onPressed: onPressed,
            style: ButtonStyle(
              backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor)
            ), 
            child: CustomText(content: text, type: TextType.normal)   
            );
  }
}