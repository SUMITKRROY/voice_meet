import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
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

  // Function to log out user
  Future<void> _signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    setState(() {
      _currentUser = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
        actions: [
          if (_currentUser != null)
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: _signOut,
            ),
        ],
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : _currentUser != null
            ? _buildUserProfile()
            : _buildSignInButton(),
      ),
    );
  }

  // Widget to display user profile information
  Widget _buildUserProfile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_currentUser?.photoURL != null)
          CircleAvatar(
            backgroundImage: NetworkImage(_currentUser!.photoURL!),
            radius: 50,
          ),
        SizedBox(height: 16),
        Text(
          _currentUser?.displayName ?? 'No Name',
          style: TextStyle(fontSize: 24),
        ),
        SizedBox(height: 8),
        Text(
          _currentUser?.email ?? 'No Email',
          style: TextStyle(fontSize: 16),
        ),
      ],
    );
  }

  // Sign-In button widget
  Widget _buildSignInButton() {
    return ElevatedButton(
      onPressed: () async {
        setState(() => _isLoading = true);
        User? user = await _getUser();
        setState(() => _isLoading = false);

        if (user == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Sign-In failed. Please try again.')),
          );
        }
      },
      child: Text('Sign In with Google'),
    );
  }
}
