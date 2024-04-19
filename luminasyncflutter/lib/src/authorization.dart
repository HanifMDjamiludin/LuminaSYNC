import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import 'api_service.dart';
import 'dart:convert';

class SignInSignUpPage extends StatefulWidget {
  const SignInSignUpPage({Key? key}) : super(key: key);

  @override
  _SignInSignUpPageState createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final ApiService _apiService = ApiService();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  late TabController _tabController;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);

    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      if (account != null && _auth.currentUser != null) {
        _navigateToHomeScreen();
      }
    });
    _googleSignIn.signInSilently();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _signIn(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _auth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user =
          await _apiService.getUserByEmail(_emailController.text.trim());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          "user", jsonEncode(user)); // Encode user data to JSON

      _resetControllers();
      _navigateToHomeScreen();
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign-in: $e');
      }
      setState(() {
        _errorMessage = 'Incorrect email or password';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signUp(BuildContext context) async {
    try {
      setState(() {
        _isLoading = true;
      });

      await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      await _apiService.addUser(
          _usernameController.text.trim(), _emailController.text.trim());

      final user =
          await _apiService.getUserByEmail(_emailController.text.trim());
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(
          "user", jsonEncode(user)); // Encode user data to JSON

      _resetControllers();
      _navigateToHomeScreen();
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign-up: $e');
      }
      setState(() {
        _errorMessage = 'Error signing up. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await _googleSignIn.signOut();

      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
            await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        await _auth.signInWithCredential(credential);

        _resetControllers();
        _navigateToHomeScreen();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during Google Sign-In: $e');
      }
      setState(() {
        _errorMessage = 'Error signing in with Google. Please try again later.';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _resetControllers() {
    _emailController.clear();
    _passwordController.clear();
    _usernameController.clear();
  }

  void _navigateToHomeScreen() {
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => HomeScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          var tween = Tween(
            begin: begin,
            end: end,
          ).chain(CurveTween(curve: curve));
          var opacityAnimation = animation.drive(tween);

          return FadeTransition(
            opacity: opacityAnimation,
            child: child,
          );
        },
        transitionDuration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'LuminaSYNC',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
            )
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Sign In'),
              Tab(text: 'Register'),
            ],
            indicatorColor: Colors.white,
          ),
        ),
        body: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey[100]!,
                      const Color.fromARGB(255, 192, 192, 192)
                    ],
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextField(
                                    controller: _emailController,
                                    key: const Key('emailTextField'),
                                    decoration: const InputDecoration(
                                        labelText: 'Email'),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  TextField(
                                    controller: _passwordController,
                                    key: const Key('passwordTextField'),
                                    decoration: const InputDecoration(
                                        labelText: 'Password'),
                                    obscureText: true,
                                  ),
                                  const SizedBox(height: 24.0),
                                  ElevatedButton(
                                    onPressed: () => _signIn(context),
                                    child: const Text('Sign In'),
                                  ),
                                  const SizedBox(height: 20.0),
                                  ConstrainedBox(
                                    constraints:
                                        const BoxConstraints(maxHeight: 50.0),
                                    child: OutlinedButton(
                                      onPressed: () => _signInWithGoogle(),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const Text('Sign in with '),
                                          Image.asset(
                                            'assets/images/google_logo.png',
                                            height: 24.0,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (_isLoading)
                                    const CircularProgressIndicator(),
                                  if (_errorMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        _errorMessage!,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            SingleChildScrollView(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextField(
                                    controller: _usernameController,
                                    key: const Key('usernameTextField'),
                                    decoration: const InputDecoration(
                                        labelText: 'Username'),
                                  ),
                                  TextField(
                                    controller: _emailController,
                                    key: const Key('registerEmailTextField'),
                                    decoration: const InputDecoration(
                                        labelText: 'Email'),
                                    keyboardType: TextInputType.emailAddress,
                                  ),
                                  TextField(
                                    controller: _passwordController,
                                    key: const Key('registerPasswordTextField'),
                                    decoration: const InputDecoration(
                                        labelText: 'Password'),
                                    obscureText: true,
                                  ),
                                  const SizedBox(height: 20.0),
                                  ElevatedButton(
                                    onPressed: () => _signUp(context),
                                    child: const Text('Register'),
                                  ),
                                  const SizedBox(height: 20.0),
                                  if (_isLoading)
                                    const CircularProgressIndicator(),
                                  if (_errorMessage != null)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 8.0),
                                      child: Text(
                                        _errorMessage!,
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ));
  }
}

void main() {
  runApp(
    MaterialApp(
      home: SignInSignUpPage(),
    ),
  );
}
