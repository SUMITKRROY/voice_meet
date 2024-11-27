import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:voice_meet/route/pageroute.dart';
import 'package:voice_meet/route/route_generater.dart';
import 'package:voice_meet/theme/app_theme.dart';
import 'package:voice_meet/theme/app_typography.dart';

import 'firebase_options.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // 1. Provide AppTheme above the MaterialApp, so it will be available on all pages.
      create: (_) => AppTheme(),
      builder: (context, _) => MaterialApp(
        initialRoute: RoutePath.splashScreen,
        onGenerateRoute: MyRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        // 2. Provide light theme.
        theme: AppTheme.light,
        // 3. Provide dark theme.
        darkTheme: AppTheme.dark,
        // 4. Watch AppTheme changes (ThemeMode).
        themeMode: context.watch<AppTheme>().themeMode,
        // home: const MyHomePage(title: 'Flutter Demo Home Page'),
      ),
    );
  }
}


