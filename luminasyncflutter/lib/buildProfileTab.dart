import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:luminasyncflutter/device_manager.dart';
import 'package:luminasyncflutter/pattern_manager.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String displayName = 'LuminaSYNC User'; // Default display name

  @override
  void initState() {
    super.initState();
    loadDisplayName();
  }

  Future<void> loadDisplayName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString('username');
    if (username != null && username.isNotEmpty) {
      setState(() {
        displayName = username;
      });
    } else {
      final user = FirebaseAuth.instance.currentUser;
      setState(() {
        displayName = user?.displayName ?? 'User';
      });
    }
  }

  void _handleLogout(BuildContext context) async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.clear();
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'User Area',
          style: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
        ),
        backgroundColor: Colors.black54,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8.0),
            Text(
              'Welcome $displayName',
              style: TextStyle(
                color: const Color.fromARGB(255, 229, 212, 160),
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    String? userDetails = prefs.getString('user');
                    if (userDetails != null) {
                      Map<String, dynamic> user = jsonDecode(userDetails);
                      String userId = user['userid'].toString();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                DeviceManagerPage(userId: userId)),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text(
                          "No device associated with the user",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ));
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: const Text(
                    'Device Manager',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    SharedPreferences.getInstance().then((prefs) {
                      String? userDetails = prefs.getString('user');
                      if (userDetails != null) {
                        Map<String, dynamic> user = jsonDecode(userDetails);
                        String userId = user['userid'].toString();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PatternManagerPage(userId: userId)),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text("No user details available for pattern management"),
                        ));
                      }
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Text(
                    'Pattern Manager',
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
                SizedBox(height: 8.0),
                ElevatedButton(
                  onPressed: () {
                    _handleLogout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0.0),
                      side: const BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
