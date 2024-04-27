import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:flutter/material.dart';

class ApiService {
  final String _baseUrl = 'http://34.145.206.196:3000'; // Backend API URL

Future<String> checkHealth() async { // For testing the connection to the server
    try {
        final response = await http.get(Uri.parse('$_baseUrl/health'));
        if (response.statusCode == 200) {
            return response.body;
        } else {
            throw Exception('Failed to check server health');
        }
    } catch (e) {
        throw Exception('Failed to connect to the server');
    }
}

// Get a user by ID from the server
Future<dynamic> getUserById(String id) async {
    try {
        final response = await http.get(Uri.parse('$_baseUrl/users/$id'));
        if (response.statusCode == 200) {
            return json.decode(response.body);
        } else {
            throw Exception('Failed to get user by ID: ${response.statusCode}');
        }
    } catch (e) {
        throw Exception('Failed to connect to the server: $e');
    }
}

// Get user by email
Future<dynamic> getUserByEmail(String email) async {
    try {
        final response = await http.post(
            Uri.parse('$_baseUrl/user/email'),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'email': email,
            }),
        );
        if (response.statusCode == 200) {
            return json.decode(response.body);
        } else if (response.statusCode == 404) {
            throw Exception('User not found');
        } else {
            throw Exception('Failed to get user by email: ${response.statusCode}');
        }
    } catch (e) {
        throw Exception('Failed to connect to the server: $e');
    }
}
// Create a new user on the server
Future<dynamic> addUser(String username, String email) async {
    final response = await http.post(
        Uri.parse('$_baseUrl/users'),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
            'username': username,
            'email': email,
        }),
    );
    final userData = json.decode(response.body);
    print('Username: ${userData['username']}');
    print('Email: ${userData['email']}');
    return userData;
}

// Get a user's devices from the server
Future<List<dynamic>> getUserDevices(String id) async {
    try {
        final response = await http.get(
            Uri.parse('$_baseUrl/users/$id/devices'),
        );
        if (response.statusCode == 200) {
            return json.decode(response.body);
        } else if (response.statusCode == 401) {
            throw Exception('Unauthorized');
        } else {
            throw Exception('Failed to get user devices: ${response.statusCode}');
        }
    } catch (e) {
        throw Exception('Failed to connect to the server: $e');
    }
}

// Add a new device to a user's account on the server
Future<dynamic> addUserDevice(String id, Map<String, dynamic> deviceData) async {
    try {
        final response = await http.post(
            Uri.parse('$_baseUrl/users/$id/devices'),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(deviceData),
        );
        if (response.statusCode == 201) {
            return json.decode(response.body);
        } else {
            throw Exception('Failed to add user device: ${response.statusCode}');
        }
    } catch (e) {
        throw Exception('Failed to connect to the server: $e');
    }
}

// Method for setting color
Future<String> setColor(String deviceID, String color) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/devices/$deviceID/color'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'color': color}),
  );

  if (response.statusCode == 200 && response.body == "Message published") {
    return response.body;
  } else {
    throw Exception('Failed to set color');
  }
}

// Method for setting power
Future<String> setPower(String deviceID, String power) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/devices/$deviceID/power'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'power': power}),
  );

  if (response.statusCode == 200 && response.body == "Message published") {
    return response.body;
  } else {
    throw Exception('Failed to set power');
  }
}

// Method for setting brightness
Future<String> setBrightness(String deviceID, String brightness) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/devices/$deviceID/brightness'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'brightness': brightness}),
  );

  if (response.statusCode == 200 && response.body == "Message published") {
    return response.body;
  } else {
    throw Exception('Failed to set brightness');
  }
}

// Method for setting effect
Future<String> setEffect(String deviceID, String effect) async {
  final response = await http.post(
    Uri.parse('$_baseUrl/devices/$deviceID/effect'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({'effect': effect}),
  );

  if (response.statusCode == 200 && response.body == "Message published") {
    return response.body;
  } else {
    throw Exception('Failed to set effect');
  }
}

// Delete a device for a user
Future<dynamic> deleteDevice(String userId, String deviceId) async {
    try {
        final response = await http.delete(
            Uri.parse('$_baseUrl/users/$userId/devices/$deviceId'),
        );
        if (response.statusCode == 200) {
            return json.decode(response.body);
        } else if (response.statusCode == 401) {
            throw Exception('Unauthorized');
        } else if (response.statusCode == 404) {
            throw Exception('Device not found');
        } else {
            throw Exception('Failed to delete device: ${response.statusCode}');
        }
    } catch (e) {
        throw Exception('Failed to connect to the server: $e');
    }
}

// Modify the name of a device for a user
Future<dynamic> modifyDeviceName(String userId, String deviceId, String deviceName) async {
    try {
        final response = await http.put(
            Uri.parse('$_baseUrl/users/$userId/devices/$deviceId/name'),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'deviceName': deviceName,
            }),
        );
        if (response.statusCode == 200) {
            return json.decode(response.body);
        } else if (response.statusCode == 401) {
            throw Exception('Unauthorized');
        } else if (response.statusCode == 404) {
            throw Exception('Device not found');
        } else {
            throw Exception('Failed to modify device name: ${response.statusCode}');
        }
    } catch (e) {
        throw Exception('Failed to connect to the server: $e');
    }
}

// Modify the location of a device for a user
Future<dynamic> modifyDeviceLocation(String userId, String deviceId, String deviceLocation) async {
    try {
        final response = await http.put(
            Uri.parse('$_baseUrl/users/$userId/devices/$deviceId/location'),
            headers: <String, String>{
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: jsonEncode(<String, String>{
                'deviceLocation': deviceLocation,
            }),
        );
        if (response.statusCode == 200) {
            return json.decode(response.body);
        } else if (response.statusCode == 401) {
            throw Exception('Unauthorized');
        } else if (response.statusCode == 404) {
            throw Exception('Device not found');
        } else {
            throw Exception('Failed to modify device location: ${response.statusCode}');
        }
    } catch (e) {
        throw Exception('Failed to connect to the server: $e');
    }
}

Future<Map<String, dynamic>> createPattern(String userId, String patternName, List<Color> position1, List<Color> position2, Color iconColor) async {

    // Convert the Color objects to their hex string representation
    List<String> position1Hex = position1.map((color) => color.value.toRadixString(16).padLeft(8, '0')).toList();
    List<String> position2Hex = position2.map((color) => color.value.toRadixString(16).padLeft(8, '0')).toList();
    String iconColorHex = iconColor.value.toRadixString(16).padLeft(8, '0');

    final response = await http.post(
        Uri.parse('$_baseUrl/users/$userId/patterns'),
        headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
            'patternName': patternName,
            'position1': position1Hex,
            'position2': position2Hex,
            'patternType': 'User',
            'iconColor': iconColorHex,
        }),
    );

    if (response.statusCode == 201) {
        return jsonDecode(response.body);
    } else {
        throw Exception('Failed to create pattern: ${response.statusCode}');
    }
}

// Get all patterns for a user
Future<List<dynamic>> getPatterns(String userId) async {
    final response = await http.get(
        Uri.parse('$_baseUrl/users/$userId/patterns'),
    );

    if (response.statusCode == 200) {
        return jsonDecode(response.body);
    } else {
        throw Exception('Failed to retrieve patterns: ${response.statusCode}');
    }
}

//Stop the effect on a device
Future<String> stopEffect(String deviceID) async {
  return setColor(deviceID, "000000");
}

// Identify a device by making its lights blink white for 5 seconds
Future<String> identifyDevice(String deviceID) async {
  const String white = "FFFFFF";  // White color in hex
  const String off = "000000";    // Turn off (black)
  const Duration blinkDuration = Duration(seconds: 1);  // Each blink will last 1 second
  const int numBlinks = 5;  // Total number of state changes for 5 seconds of blinking

  print('Identifying device $deviceID');

    try {
        // Turn off the device first
        await setColor(deviceID, off);
        await Future.delayed(Duration(seconds: 1));  // Wait 1 second before starting the blinking
    
        // Blink the lights white for 5 seconds
        for (int i = 0; i < numBlinks; i++) {
        await setColor(deviceID, white);
        await Future.delayed(blinkDuration);
        await setColor(deviceID, off);
        await Future.delayed(blinkDuration);
        }
    
        return 'Device identified';
    } catch (e) {
        throw Exception('Failed to identify device: $e');
    }
}

}