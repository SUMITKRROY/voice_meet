import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:voice_meet/provider/auth/auth_bloc.dart';

import 'package:voice_meet/route/pageroute.dart';
import 'package:voice_meet/route/route_generater.dart';
import 'package:voice_meet/theme/app_theme.dart';
import 'package:voice_meet/theme/app_typography.dart';

import 'firebase_options.dart';

const String appId = '94d325cbd36c4f2eb33f312ad439fbb9'; // Replace with your Agora App ID
const String token = "7156923f72e24dfc93b62fb83947ab3d"; // Add a token if security is enabled
const String channelName = 'test_channel';


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
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
        BlocProvider(
          create: (context) => AuthBloc(), // Initialize AuthBloc
        ),
      ],
      child: ChangeNotifierProvider(
        // 1. Provide AppTheme above the MaterialApp, so it will be available on all pages.
        create: (_) => AppTheme(),
        builder: (context, _) => MaterialApp(
          initialRoute: RoutePath.splashScreen,
          onGenerateRoute: MyRoutes.generateRoute,
          debugShowCheckedModeBanner: false,
          title: 'Stranger talk',
          // 2. Provide light theme.
          theme: AppTheme.light,
          // 3. Provide dark theme.
          darkTheme: AppTheme.dark,
          // 4. Watch AppTheme changes (ThemeMode).
          themeMode: context.watch<AppTheme>().themeMode,
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
        ),
      ),
    );
  }
}


