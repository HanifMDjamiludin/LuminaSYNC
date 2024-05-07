import 'package:flutter/material.dart';
import 'preset_patterns.dart';
import '/src/api_service.dart';
import 'custom_patterns.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PatternTabs extends StatefulWidget {
  @override
  _PatternTabsState createState() => _PatternTabsState();
}

class _PatternTabsState extends State<PatternTabs> {
  List<Map<String, String>> _devices = []; // List of device maps
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      try {
        var devices = await _apiService.getUserDevices(userId);
        setState(() {
          _devices = devices
              .map((device) => {
                    'deviceid': device['deviceid'] as String,
                    'devicename': device['devicename'] as String
                  })
              .toList();
        });
      } catch (e) {
        print('Failed to load devices: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Adjust the number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lighting Patterns"),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.stop),
              onPressed: () async {
                _devices.forEach((device) {
                  _apiService.stopPattern(device['deviceid']!);
                });                
              },
            ),
          ],
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.lightbulb_outline), text: "Preset Patterns"),
              Tab(icon: Icon(Icons.palette), text: "Custom Patterns"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PresetPatterns(),
            CustomPatterns(),
          ],
        ),
      ),
    );
  }
}
