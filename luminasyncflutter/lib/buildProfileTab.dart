import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:luminasyncflutter/device_manager.dart';

class ProfileTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _buildProfileTab(context);
  }

  Widget _buildProfileTab(BuildContext context) {
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
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text(
                        "User not logged in. Please log in to manage devices.")));
              }
            },
            child: const Text('Manage Devices'),
          ),
        ],
      ),
    );
  }
}
