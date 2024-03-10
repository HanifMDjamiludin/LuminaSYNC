import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luminasyncflutter/switch.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Lights'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _handleLogout(context);
            },
          ),
        ],
      ),
      body: _getBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pattern),
            label: 'Patterns',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return _buildHomeTab();
      case 1:
        return Column(children: [SwitchAndButton(), SwitchAndButton(), SwitchAndButton(), SwitchAndButton(), SwitchAndButton()],);
      case 2:
        return _buildProfileTab();
      default:
        return Container();
    }
  }

  Widget _buildHomeTab() {
    return Center(
      child: Text('Main Page'),
    );
  }

  Widget _buildSettingsTab() {
    return Center(child: SwitchAndButton());
  }

  Widget _buildProfileTab() {
    // Replace these placeholders with actual user information
    final String username = 'JohnDoe';
    final String userId = '1234';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome $username'),
          const SizedBox(height: 16.0),
          Text('User ID: $userId'),
        ],
      ),
    );
  }
}

void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}
