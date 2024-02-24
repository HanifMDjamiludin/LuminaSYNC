import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home_screen.dart';

class SignInSignUpPage extends StatefulWidget {
  const SignInSignUpPage({Key? key}) : super(key: key);

  @override
  _SignInSignUpPageState createState() => _SignInSignUpPageState();
}

class _SignInSignUpPageState extends State<SignInSignUpPage>
    with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController =
      TextEditingController(); // Phone number controller

  late TabController _tabController;
  bool _isLoading = false;

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
    _phoneController.dispose();
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

      _resetControllers();
      _navigateToHomeScreen();
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign-in: $e');
      }
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

      _resetControllers();
      _navigateToHomeScreen();
    } catch (e) {
      if (kDebugMode) {
        print('Error during sign-up: $e');
      }
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
    } finally {
      _isLoading = false;
    }
  }

  void _resetControllers() {
    _emailController.clear();
    _passwordController.clear();
    _usernameController.clear();
    _phoneController.clear();
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
        title: const Text('LuminaSYNC'),
        backgroundColor: Colors.cyan[200],
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'assets/images/logo.png',
              width: 50.0,
              height: 50.0,
            ),
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
        color: Colors.cyan[50],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            color: Colors.white,
            elevation: 0,
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
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              TextField(
                                controller: _passwordController,
                                key: const Key('passwordTextField'),
                                decoration: const InputDecoration(
                                    labelText: 'Password'),
                                obscureText: true,
                              ),
                              SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: () => _signIn(context),
                                child: const Text('Sign In'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.cyan),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              ConstrainedBox(
                                constraints: BoxConstraints(maxHeight: 50.0),
                                child: OutlinedButton(
                                  onPressed: () => _signInWithGoogle(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        'assets/images/google_logo.png',
                                        height: 24.0,
                                      ),
                                      SizedBox(width: 8.0),
                                      Text('Sign In with Google'),
                                    ],
                                  ),
                                ),
                              ),
                              if (_isLoading) CircularProgressIndicator(),
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
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              TextField(
                                controller: _phoneController,
                                key: const Key('phoneTextField'),
                                decoration: const InputDecoration(
                                    labelText: 'Phone Number'),
                                keyboardType: TextInputType.phone,
                              ),
                              TextField(
                                controller: _passwordController,
                                key: const Key('registerPasswordTextField'),
                                decoration: const InputDecoration(
                                    labelText: 'Password'),
                                obscureText: true,
                              ),
                              SizedBox(height: 20.0),
                              ElevatedButton(
                                onPressed: () => _signUp(context),
                                child: const Text('Register'),
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.cyan),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20.0),
                              if (_isLoading) CircularProgressIndicator(),
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
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: SignInSignUpPage(),
    ),
  );
}
