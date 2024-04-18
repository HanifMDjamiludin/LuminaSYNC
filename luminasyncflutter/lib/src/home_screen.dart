import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luminasyncflutter/add_devices.dart';
import 'package:luminasyncflutter/creator.dart';
import 'package:luminasyncflutter/newCreator.dart';
import 'package:luminasyncflutter/switch.dart';
import 'package:luminasyncflutter/device_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

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
        title: Center(
          child: Text(
            'LuminaSYNC',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _handleLogout(context);
            },
          ),
        ],
      ),
      body: _getBody(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.device_hub),
            label: 'Devices',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pattern),
            label: 'Patterns',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pallet),
            label: 'Pattern Creator',
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        return Column(
          children: [
            SwitchAndButton(light: 1),
            SwitchAndButton(light: 2),
            SwitchAndButton(light: 3),
            SwitchAndButton(light: 4),
            SwitchAndButton(light: 5)
          ],
        );

      case 1:
        return NewCreator();
      //AddDeviceButton();
      case 2:
        return Row(
          children: [
            PatternCreator(),
            PatternCreator(),
            PatternCreator(),
            PatternCreator(),
            PatternCreator(),
            PatternCreator()
          ],
        );
      case 3:
        return _buildProfileTab();
      default:
        return Container();
    }
  }

  Widget _buildProfileTab() {
    final user = FirebaseAuth.instance.currentUser;
    final String displayName = user?.displayName ?? 'User';

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Welcome $displayName'),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              String? userDetails = prefs.getString('user');
              if (userDetails != null) {
                Map<String, dynamic> user = jsonDecode(userDetails);
                String userId = user['userid'].toString();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DeviceManagerPage(userId: userId)),
                );
              } else {
                // Handle error or prompt login
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        "User not logged in. Please log in to manage devices.")));
              }
            },
            child: Text('Manage Devices'),
          ),
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
