import 'package:flutter/material.dart';
import 'package:integrated_panel/integrated_panel.dart';

class ProgressBar extends StatelessWidget {
  const ProgressBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(child: CircularProgressIndicator(
      color: SDKCustomization.instance!.secondaryColor,
    ));
  }
}