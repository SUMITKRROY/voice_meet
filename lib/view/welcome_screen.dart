import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:voice_meet/route/pageroute.dart';
import 'package:voice_meet/route/route_generater.dart';
 
import 'package:voice_meet/theme/app_theme.dart';
import '../component/myText.dart';
 
// Welcome Screen with Bot and User Buttons
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {




  // Function for Google Sign-In
  Future<User?> _signInWithGoogle(BuildContext context) async {
    try {
      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return null;
      }

      // Obtain the authentication details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Once signed in, return the UserCredential
      UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error during Google sign-in: $e");
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
                    label: 'Voice chat',
                    fontSize: 18,
                    alignment: true, // Center the text
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Full width User Button
              // Full width User Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: context.theme.appColors.onPrimary,
                    backgroundColor: context.theme.appColors.primary,
                  ),
                  onPressed: () async {
                    // Sign in with Google and navigate on success
                    User? user = await _signInWithGoogle(context);
                    if (user != null) {
                      // Navigate to the chat with user screen
                      Navigator.pushNamed(context, RoutePath.chatWithUser);
                    } else {
                      // Handle the case when login failed
                      print("Login failed");
                    }
                  },
                  child: MyText(
                    label: 'User chat',
                    fontSize: 18,
                    alignment: true, // Center the text
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: context.theme.appColors.onPrimary,
                    backgroundColor: context.theme.appColors.primary,
                  ),
                  onPressed: ()  {
                    Navigator.pushNamed(context, RoutePath.speechToTextWidget);
                  },
                  child: MyText(
                    label: 'STT screen',
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
 

