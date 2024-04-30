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
      title: 'Main',
      theme: ThemeData(
        brightness: Brightness.dark,
        backgroundColor: Colors.black54,
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
      routes: {
        '/home': (context) => const HomeScreen(),
        '/signInSignUp': (context) => const SignInSignUpPage(),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 500),
    );

    Future.delayed(Duration(seconds: 4), () {
      _animationController.forward();
    });

    navigateToNextScreen();
  }

  void navigateToNextScreen() async {
    await Future.delayed(Duration(milliseconds: 2200));
    Navigator.pushReplacementNamed(context, '/signInSignUp');
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Opacity(
            opacity: 1.0 - _animationController.value,
            child: Center(
              child: Image.asset(
                'assets/images/splash_image.png',
                fit: BoxFit.contain,
              ),
            ),
          );
        },
      ),
    );
  }
}
