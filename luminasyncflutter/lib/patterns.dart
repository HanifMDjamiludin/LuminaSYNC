import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'lighting_pattern.dart';
import '/src/api_service.dart';

// Function to load lighting patterns from a JSON file
Future<List<LightingPattern>> loadPatterns() async {
  final String response = await rootBundle.loadString('assets/patterns.json');
  final data = await json.decode(response) as List;
  return data.map((item) => LightingPattern.fromJson(item)).toList();
}

// Widget to display available lighting patterns
class PresetPatterns extends StatefulWidget {
  @override
  _PresetPatternsState createState() => _PresetPatternsState();
}

class _PresetPatternsState extends State<PresetPatterns> {
  final ApiService _apiService = ApiService();
  String? _selectedDeviceId;
  List<Map<String, String>> _devices = []; // List of device maps

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
          if (_devices.isNotEmpty) {
            _selectedDeviceId = _devices.first['deviceid'];
          }
        });
      } catch (e) {
        print('Failed to load devices: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Patterns'),
        actions: [
          DropdownButton<String>(
            value: _selectedDeviceId,
            items: _devices.map((Map<String, String> device) {
              return DropdownMenuItem<String>(
                value: device['deviceid'],
                child: Text(device['devicename']!),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedDeviceId = newValue;
              });
              print(
                  "Device selected: ${_devices.firstWhere((device) => device['deviceid'] == newValue)['devicename']}");
            },
          ),
        ],
      ),
      body: FutureBuilder<List<LightingPattern>>(
        future: loadPatterns(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                padding: const EdgeInsets.all(20),
                children: snapshot.data!.map((pattern) {
                  return Material(
                    color: Color(pattern.color),
                    child: InkWell(
                      onTap: () {
                        if (_selectedDeviceId != null) {
                          _apiService.setEffect(
                              _selectedDeviceId!, pattern.title);
                          print(
                              "Pattern selected: ${pattern.title} for device: ${_devices.firstWhere((device) => device['deviceid'] == _selectedDeviceId)['devicename']}");
                          print(
                              "Setting effect for device: $_selectedDeviceId");
                        }
                      },
                      child: Container(
                        width: 100,
                        height: 100,
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Colors.black, // Add border color
                            width: 2, // Add border width
                          ),
                        ),
                        child: Stack(
                          children: [
                            // Semi-transparent background
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            // Text
                            Center(
                              child: Text(
                                pattern.title,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error loading patterns: ${snapshot.error}'));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
