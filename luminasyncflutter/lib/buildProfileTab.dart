import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:luminasyncflutter/device_manager.dart';

class ProfileTab extends StatefulWidget {
  @override
  _ProfileTabState createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String displayName = 'User'; // Default display name

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
        displayName = user?.displayName ?? 'User'; // Fallback to default display name
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome $displayName',
            style: TextStyle(
              fontSize: 24.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(
            child: Center(
              child: ElevatedButton(
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
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                        "No device associated with the user",
                        style: TextStyle(fontSize: 16.0),
                      ),
                    ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(
                    vertical: 12.0,
                    horizontal: 24.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text(
                  'Manage Devices',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
