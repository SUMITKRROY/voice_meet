import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:voice_meet/theme/app_theme.dart'; // Assuming your AppTheme is imported here

class MyText extends StatelessWidget {
  final String label;
  final double? fontSize;
  final bool alignment;

  MyText({
    super.key,
    required this.label,
    this.fontSize,
    this.alignment = false,
  });

  @override
  Widget build(BuildContext context) {
    // Accessing color from the current theme
    Color fontColor = context.watch<AppTheme>().themeMode == ThemeMode.dark
        ? context.theme.appColors.onBackground // Dark theme font color
        : context.theme.appColors.onPrimary; // Light theme font color

    return Text(
      label,
      style: TextStyle(
        fontSize: fontSize ?? 14,
        color: fontColor,
      ),
      textAlign: alignment ? TextAlign.center : TextAlign.start,
    );
  }
}
