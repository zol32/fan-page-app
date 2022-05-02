import 'package:firebase_core/firebase_core.dart';
import 'package:myfanpage/firebase_options.dart';
import 'package:myfanpage/pages/fan_page.dart';
import 'package:myfanpage/pages/login_page.dart';
import 'package:myfanpage/pages/post/create_post_page.dart';
import 'package:myfanpage/pages/register_page.dart';
import 'package:flutter/material.dart';
import 'package:myfanpage/services/auth/auth_service.dart';
import 'constants/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fan Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
      routes: {
        loginRoute: (context) => const LoginPage(),
        registerRoute: (context) => const RegisterPage(),
        fanpageRoute: (context) => const FanPage(),
        createPostRoute: (context) => const CreatePostPage(),
      },
    ),
  );
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            final user = AuthService().currentUser;
            if (user != null) {
              return const FanPage();
            } else {
              return const LoginPage();
            }
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
