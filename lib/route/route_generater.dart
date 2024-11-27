

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:voice_meet/route/pageroute.dart';

import '../view/chat_with_user_screen.dart';
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
      case RoutePath.chatScreen:
        return MaterialPageRoute(
          builder: (_) => const ChatScreen(),
        );

    // Profile Screen
      case RoutePath.profile:
        return MaterialPageRoute(
          builder: (_) => const ProfileScreen(),
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
