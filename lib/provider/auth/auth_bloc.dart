// auth_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthBloc() : super(AuthInitial()) {
    on<AuthSignIn>((event, emit) async {
      await _handleSignIn(emit);
    });
  }

  Future<void> _handleSignIn(Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading()); // Emit loading state
      final googleSignInAccount = await _googleSignIn.signIn();
      final googleSignInAuthentication = await googleSignInAccount?.authentication;

      if (googleSignInAccount == null || googleSignInAuthentication == null) {
        emit(AuthFailure("Google Sign-In failed"));
        return;
      }

      final credential = GoogleAuthProvider.credential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken,
      );

      final authResult = await _firebaseAuth.signInWithCredential(credential);
      final user = authResult.user;

      if (user != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', user.uid);

        emit(AuthSuccess(user)); // Emit success state
      } else {
        emit(AuthFailure("Authentication failed"));
      }
    } catch (e) {
      emit(AuthFailure("An error occurred: $e"));
    }
  }
}
