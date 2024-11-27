

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_meet/route/pageroute.dart';
import 'package:voice_meet/view/chat_screen/bot_screen.dart';

import '../view/chat_screen/user_screen.dart';
import '../view/profile_screen.dart';
import '../view/setting_screen.dart';
import '../view/splash_screen.dart';
import '../view/welcome_screen.dart';

class MyRoutes {
  /// Define the `generateRoute` method for dynamic routing.
 static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
    // Splash Screen
      case RoutePath.splashScreen:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
        );

    // Welcome Screen
      case RoutePath.welcome:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(),
        );

    // // Login Screen
    //   case RoutePath.login:
    //     return MaterialPageRoute(
    //       builder: (_) => const LoginScreen(),
    //     );

    // Chat Screen
      case RoutePath.chatWithUser:
        return MaterialPageRoute(
          builder: (_) => const ChatScreen(),
        );

        // Chat Screen
      case RoutePath.chatWithBot:
        return MaterialPageRoute(
          builder: (_) => const BotScreen(),
        );

    // Profile Screen
      case RoutePath.profile:
        return MaterialPageRoute(
          builder: (_) =>  UserProfileScreen(),
        );

    // Settings Screen
      case RoutePath.settingScreen:
        return MaterialPageRoute(
          builder: (_) => const SettingScreen(),
        );

    // // About Us Screen
    //   case RoutePath.aboutUs:
    //     return MaterialPageRoute(
    //       builder: (_) => const AboutUsScreen(),
    //     );

    // Default case (if no route is found)
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }


  static void navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const ChatScreen()),
        (route) => false);
  }


}
