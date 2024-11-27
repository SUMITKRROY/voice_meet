import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../theme/app_theme.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  late ThemeMode _currentMode;

  @override
  void initState() {
    super.initState();
    _currentMode = context.read<AppTheme>().themeMode;
  }

  void _updateThemeMode(ThemeMode mode) {
    context.read<AppTheme>().themeMode = mode;
    setState(() {
      _currentMode = mode; // Update the UI based on selected theme
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Select Theme Mode:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ToggleButtons(
              isSelected: [
                _currentMode == ThemeMode.light,
                _currentMode == ThemeMode.dark,
                _currentMode == ThemeMode.system,
              ],
              onPressed: (int index) {
                setState(() {
                  if (index == 0) {
                    _updateThemeMode(ThemeMode.light);
                  } else if (index == 1) {
                    _updateThemeMode(ThemeMode.dark);
                  } else {
                    _updateThemeMode(ThemeMode.system);
                  }
                });
              },
              children: const [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Light"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("Dark"),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("System"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
