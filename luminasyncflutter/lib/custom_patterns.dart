import 'package:flutter/material.dart';
import '/src/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomPatterns extends StatefulWidget {
  @override
  _CustomPatternsState createState() => _CustomPatternsState();
}

class _CustomPatternsState extends State<CustomPatterns> {
  final ApiService _apiService = ApiService();
  Future<List<dynamic>>? _patterns;
  List<Map<String, String>> _devices = []; // List of device maps

  @override
  void initState() {
    super.initState();
    _loadPatterns();
    _loadDevices();
  }

  Future<void> _loadPatterns() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userId = prefs.getString('userId');
    if (userId != null) {
      setState(() {
        _patterns = _apiService.getPatterns(userId);
      });
    } else {
      print("No user ID found in SharedPreferences"); // Log an error message
    }
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
    return FutureBuilder<List<dynamic>>(
      future: _patterns,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1,
              ),
              itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                    var pattern = snapshot.data![index];
                    String colorString = '0xFF' + pattern['patterndata']['iconColor'].substring(2); // Ensure the string starts with '0xFF'
                    return GestureDetector(
                        onTap: () {
                            _devices.forEach((device) {
                            _apiService.setPattern(device['deviceid']!, pattern['patterndata']);
                            });
                        },
                        child: Card(
                            child: Container(
                            alignment: Alignment.center,
                            child: Text(pattern['patternname']),
                            decoration: BoxDecoration(
                                color: Color(int.parse(colorString)),
                                borderRadius: BorderRadius.circular(10),
                                ),
                            ),
                        ),
                    );
                },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
