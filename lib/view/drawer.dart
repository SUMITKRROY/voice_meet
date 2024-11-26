
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../route/route_generater.dart';


class DrawerWidget extends StatefulWidget {
  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  final GoogleSignIn googleSignIn = GoogleSignIn();

  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  User? _currentUser;

  bool _isLoading = false;
  @override
  void initState() {
    super.initState();

    // Listen to authentication state changes
    firebaseAuth.authStateChanges().listen((user) {
      setState(() {
        _currentUser = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          // Drawer Header with User's Info
          UserAccountsDrawerHeader(
            accountName: Text(
              _currentUser?.displayName ?? 'No Name',
              style: TextStyle(fontSize: 18),
            ),
            accountEmail: Text(
              _currentUser?.email ?? 'No Email',
              style: TextStyle(fontSize: 16),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundImage: _currentUser?.photoURL != null
                  ? NetworkImage(_currentUser!.photoURL!)
                  : AssetImage('assets/images/user.png') as ImageProvider,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          // Drawer items
          ListTile(
            title: Text('Profile'),
            onTap: () {
              // Navigate to Profile screen (or show profile details)
            },
          ),
          ListTile(
            title: Text('Settings'),
            onTap: () {
              // Navigate to Settings screen (or show settings)
            },
          ),
          ListTile(
            title: Text('Sign Out'),
            onTap: () {
              _signOut();
              Navigator.of(context).pop(); // Close the drawer
            },
          ),
        ],
      ),
    );
  }

  // Function to log out user
  Future<void> _signOut() async {
    await googleSignIn.signOut();
    await firebaseAuth.signOut();
    setState(() {
      _currentUser = null;
    });
  }
}