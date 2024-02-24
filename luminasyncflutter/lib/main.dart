import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:luminasyncflutter/firebase_options.dart';
import 'src/authorization.dart';
import 'src/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Auth Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SignInSignUpPage(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
