import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:myfanpage/constants/routes.dart';
import 'package:myfanpage/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as FirebaseUser show User;
import 'package:myfanpage/services/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService _auth = AuthService();

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _email,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Enter your email here',
            ),
          ),
          TextField(
            controller: _password,
            obscureText: true,
            enableSuggestions: false,
            autocorrect: false,
            decoration: const InputDecoration(
              hintText: 'Enter your password here',
            ),
          ),
          TextButton(
            onPressed: () async {
              final email = _email.text;
              final password = _password.text;
              FirebaseUser.User? user = await _auth.logInWithEmailAndPassword(
                email,
                password,
              );
              if (user != null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  fanpageRoute,
                  (route) => false,
                );
              }
            },
            child: const Text('Login'),
          ),
          const SizedBox(height: 25),
          ElevatedButton(
            child: const Text('Sign In with Google'),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
              Navigator.of(context).pushNamedAndRemoveUntil(
                fanpageRoute,
                (route) => false,
              );
            },
          ),
          const SizedBox(height: 25),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                registerRoute,
                (route) => false,
              );
            },
            child: const Text('Not registered yet? Register here!'),
          )
        ],
      ),
    );
  }
}
