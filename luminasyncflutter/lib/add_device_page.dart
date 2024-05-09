import 'package:flutter/material.dart';
import 'package:flutter_nsd/flutter_nsd.dart';
import 'src/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'device_discovery_page.dart';

class AddDevicePage extends StatefulWidget {
  final ServiceInfoWithId serviceWithId;

  AddDevicePage({Key? key, required this.serviceWithId}) : super(key: key);

  @override
  _AddDevicePageState createState() => _AddDevicePageState();
}

class _AddDevicePageState extends State<AddDevicePage> {
  String _username = ''; 
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  bool _isSubmitting = false;

  ApiService _apiService = ApiService();
  
  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('userId') ?? '';
    });
  }

  Future<void> _addDevice() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      var response = await _apiService.addUserDevice(
        _username,
        widget.serviceWithId.id,
        _nameController.text,
        _locationController.text,
      );

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Device added successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding device: $e')));
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Device'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Device Name'),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Device Location'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _addDevice,
              child: Text(_isSubmitting ? 'Adding...' : 'Add Device'),
            ),
          ],
        ),
      ),
    );
  }
}
