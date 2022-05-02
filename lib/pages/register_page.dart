import 'package:flutter/material.dart';
import 'package:myfanpage/constants/routes.dart';
import 'package:myfanpage/services/auth/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:myfanpage/services/auth/cloud_service.dart';
import 'dart:developer' show log;

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _auth = AuthService();
  final CloudService _cloudService = CloudService();

  late final TextEditingController _displayName;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    _displayName = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _firstName.dispose();
    _lastName.dispose();
    _displayName.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _firstName,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Enter your first name here',
            ),
          ),
          TextField(
            controller: _lastName,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Enter your last name here',
            ),
          ),
          TextField(
            controller: _displayName,
            enableSuggestions: false,
            autocorrect: false,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: 'Enter your display name here',
            ),
          ),
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
              final displayName = _displayName.text;
              final firstName = _firstName.text;
              final lastName = _lastName.text;
              final password = _password.text;
              UserCredential user = await _auth.registerWithEmailAndPassword(
                email,
                password,
                displayName,
              );
              log("User Registered");
              log(user.toString());
              log("User Registered");
              dynamic addedUser = await _cloudService.addUser(
                user,
                displayName,
                firstName,
                lastName,
              );
              log("User Saved");
              if (addedUser != null) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  loginRoute,
                  (route) => false,
                );
              }
            },
            child: const Text('Register'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (route) => false,
              );
            },
            child: const Text('Already registered? Login here!'),
          )
        ],
      ),
    );
  }
}
