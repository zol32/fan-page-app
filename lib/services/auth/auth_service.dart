import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:firebase_auth/firebase_auth.dart' as FirebaseUser show User;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myfanpage/services/auth/cloud_service.dart';
import 'package:myfanpage/services/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../../firebase_options.dart';

class AuthService {
  Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CloudService _cloudService = CloudService();

  FirebaseUser.User? get currentUser => _auth.currentUser;

  Future<dynamic> registerWithEmailAndPassword(
    String email,
    String password,
    String displayName,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e);
    }
  }

  Future<dynamic> logInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      dynamic uid = userCredential.user;
      return uid;
    } on FirebaseAuthException {
      throw FirebaseAuthException;
    } catch (e) {
      print(e.toString());
    }
  }

  Future logOut() async {
    final googleUser = GoogleSignInProvider().user;
    final googleSignIn = GoogleSignIn();
    try {
      if (googleUser != null) {
        log('Log out 1');
        await googleSignIn.disconnect();
        log('Log out 2');
        return await FirebaseAuth.instance.signOut();
      }
      log('Log out 3');
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
