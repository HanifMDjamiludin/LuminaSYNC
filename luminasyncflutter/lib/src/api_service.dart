import 'dart:convert';
import 'package:http/http.dart' as http;

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

// Publish a command to a device on the user's account
  Future<String> publishCommand(String deviceID, String command) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/publish/$deviceID'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'command': command}),
    );
    return response.body;
  }
}
