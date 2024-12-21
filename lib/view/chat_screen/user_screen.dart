import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:voice_meet/view/widget/drawer.dart';

import '../chat_message.dart';
import '../widget/text_composer.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final googleSignIn = GoogleSignIn();
  final firebaseAuth = FirebaseAuth.instance;
  final firestoreCollection = FirebaseFirestore.instance.collection('messages');
  final fcmToken = FirebaseMessaging.instance.getToken();

  User? _currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    FirebaseMessaging.instance.setAutoInitEnabled(true);
    if (mounted) {
      firebaseAuth.authStateChanges().listen((user) {
        if (user != null) {
          setState(() => _currentUser = user);
        } else {
          setState(() => _currentUser = null);
        }
      });
    }
  }

  Future<User?> _getUser() async {
    if (_currentUser != null) return _currentUser;

    try {
      final googleSignInAccount = await googleSignIn.signIn();
      final googleSignInAuthentication =
      await googleSignInAccount?.authentication;

      if (googleSignInAccount == null) return null;
      if (googleSignInAuthentication == null) return null;

      final credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final authResult = await firebaseAuth.signInWithCredential(credential);
      final user = authResult.user;
      return user;
    } catch (e, s) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text('Login failed: $e'),
        ),
      );

      return null;
    }
  }

  Future<void> _sendMessage({
    File? imgFile,
    String? text,
  }) async {
    final user = await _getUser();
    if (user == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'error message ',
            ),
          ),
        );
      }
    }

    if (user != null) {
      var data = <String, dynamic>{
        'uid': user.uid,
        'senderName': user.displayName,
        'senderPhotoUrl': user.photoURL,
        'time': Timestamp.now(),
      };

      final task = FirebaseStorage.instance.ref().child(
        user.uid + DateTime.now().millisecondsSinceEpoch.toString(),
      );

      if (imgFile != null) {
        setState(() => _isLoading = true);
        final taskWithImage = task.putFile(imgFile);
        var taskSnapshot = await taskWithImage.whenComplete(() {});
        String url = await taskSnapshot.ref.getDownloadURL();
        data['imgUrl'] = url;
      } else {
        data['text'] = text;
      }
      setState(() => _isLoading = false);
      firestoreCollection.add(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          _currentUser != null
              ? ' ${_currentUser?.displayName ?? "i don't know."}'
              : 'Chat App',
        ),

      ),
      drawer: DrawerWidget(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: firestoreCollection.orderBy('time').snapshots(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  default:
                    var documents = snapshot.data?.docs.reversed.toList() ??
                        <QueryDocumentSnapshot>[];
                    return ListView.builder(
                      itemCount: documents.length,
                      reverse: true,
                      itemBuilder: (context, index) {
                        final document = documents[index];
                        return ChatMessage(
                          data: document.data() as Map<String, dynamic>,
                          isMine: document['uid'] == _currentUser?.uid,
                        );
                      },
                    );
                }
              },
            ),
          ),
          _isLoading ? const LinearProgressIndicator() : const SizedBox(),
          TextComposer(
            sendMessage: _sendMessage,
          ),
        ],
      ),
    );
  }

}
