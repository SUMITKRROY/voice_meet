import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:voice_meet/route/pageroute.dart';
import 'package:voice_meet/theme/app_theme.dart';
import '../component/myText.dart';
import '../provider/auth/auth_bloc.dart';
import '../provider/auth/auth_event.dart';
import '../provider/auth/auth_state.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //FirebaseMessaging.instance.setAutoInitEnabled(true);

    // Listen to authentication state changes
    firebaseAuth.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  // Function to get current user or sign in with Google if not already signed in
  Future<User?> _getUser() async {
    if (_currentUser != null) return _currentUser;

    try {
      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuthentication = await googleSignInAccount?.authentication;

      if (googleSignInAccount == null || googleSignInAuthentication == null) return null;

      final credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final authResult = await firebaseAuth.signInWithCredential(credential);
      final user = authResult.user;

      setState(() {
        _currentUser = user;
      });

      return user;
    } catch (e, s) {
      debugPrint('Error during login: $e');
      debugPrint('Stack trace: $s');
      return null;
    }
  }

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
                    Navigator.pushNamed(context, RoutePath.chatWithBot);
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
                  onPressed: () async {
                    setState(() => _isLoading = true);
                    User? user = await _getUser();
                    setState(() => _isLoading = false);
if (user != null){
  Navigator.pushNamed(context, RoutePath.chatWithUser);
}
                    else if (user == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sign-In failed. Please try again.')),
                      );
                    }
                  },
                  child: MyText(
                    label: 'User',
                    fontSize: 18,
                    alignment: true, // Center the text
                  ),
                ),
              ),
              // Bloc Listener for authentication state changes

            ],
          ),
        ),
      ),
      // Floating Action Button (FAB) to navigate to Settings
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, RoutePath.profile);
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
