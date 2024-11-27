import 'package:flutter/material.dart';
import 'package:voice_meet/route/pageroute.dart';
import 'package:voice_meet/route/route_generater.dart';
 
import 'package:voice_meet/theme/app_theme.dart';
import '../component/myText.dart';
 
// Welcome Screen with Bot and User Buttons
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.appColors.background,
      appBar: AppBar(
        backgroundColor: context.theme.appColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Choose your best option to connect with?',
                style: TextStyle(fontSize: 24),
              ),
              const SizedBox(height: 30),
              // Full width Bot Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: context.theme.appColors.onPrimary,
                    backgroundColor: context.theme.appColors.primary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const BotScreen()),
                    );
                  },
                  child: MyText(
                    label: 'Bot',
                    fontSize: 18,
                    alignment: true, // Center the text
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Full width User Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: context.theme.appColors.onPrimary,
                    backgroundColor: context.theme.appColors.primary,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const UserScreen()),
                    );
                  },
                  child: MyText(
                    label: 'User',
                    fontSize: 18,
                    alignment: true, // Center the text
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      // Floating Action Button (FAB) to navigate to Settings
      floatingActionButton: FloatingActionButton(
        onPressed: () {
       Navigator.pushNamed(context, RoutePath.settingScreen);
        },
        backgroundColor: context.theme.appColors.primary,
        child: Icon(
          Icons.settings,
          color: context.theme.appColors.onPrimary,
        ),
      ),
    );
  }
}
 
// Bot Screen
class BotScreen extends StatelessWidget {
  const BotScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.appColors.background,
      appBar: AppBar(
        title: MyText(
          label: 'Bot Screen',
          fontSize: 20,

          alignment: true,
        ),
        backgroundColor: context.theme.appColors.primary,
      ),
      body: Center(
        child: MyText(
          label: 'This is the Bot Screen',
          fontSize: 18,

          alignment: true,
        ),
      ),
    );
  }
}

// User Screen
class UserScreen extends StatelessWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.appColors.background,
      appBar: AppBar(
        title: MyText(
          label: 'User Screen',
          fontSize: 20,

          alignment: true,
        ),
        backgroundColor: context.theme.appColors.primary,
      ),
      body: Center(
        child: Text(
           'This is the User Screen',
        ),
      ),
    );
  }
}
