import 'package:flutter/material.dart';
import 'package:luminasyncflutter/creator.dart';
import 'package:luminasyncflutter/patterns.dart';
import 'package:luminasyncflutter/devices.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luminasyncflutter/buildProfileTab.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userDetails = prefs.getString('user');
    if (userDetails != null) {
      Map<String, dynamic> user = jsonDecode(userDetails);
      String userId = user['userid'].toString();
      String username = user['username'].toString();
      //save the user id to shared preferences
      await prefs.setString('userId', userId);
      await prefs.setString('username', username);
      setState(() {
        _userId = userId;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'LuminaSYNC',
            style: GoogleFonts.orbitron(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [],
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

  Widget _getBody(int index) {
    switch (index) {
      case 0:
        if (_userId != null) {
          return DeviceManagerScreen(userId: _userId!);
        } else {
          print("null");
          return Container();
        }

      case 1:
        // return PresetPatterns();
        return PatternTabs();
      case 2:
        return PatternCreator();
      case 3:
        return ProfileTab();
      default:
        return Container();
    }
  }
}

void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(),
    ),
  );
}
