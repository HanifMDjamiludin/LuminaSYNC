import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';

class DeviceDetailsPage extends StatefulWidget {
  final Map<String, dynamic> device;
  final String userId;

  const DeviceDetailsPage(
      {Key? key, required this.device, required this.userId})
      : super(key: key);

  @override
  _DeviceDetailsPageState createState() => _DeviceDetailsPageState();
}

class _DeviceDetailsPageState extends State<DeviceDetailsPage> {
  late TextEditingController _nameController;
  late TextEditingController _locationController;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.device['devicename']);
    _locationController =
        TextEditingController(text: widget.device['devicelocation']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _updateDeviceName() async {
    try {
      await _apiService.modifyDeviceName(
          widget.userId, widget.device['deviceid'], _nameController.text);
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _updateDeviceLocation() async {
    try {
      await _apiService.modifyDeviceLocation(
          widget.userId, widget.device['deviceid'], _locationController.text);
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _deleteDevice() async {
    try {
      await _apiService.deleteDevice(widget.userId, widget.device['deviceid']);
      Navigator.pop(context,
          'update'); // Return 'update' as a result to indicate a refresh is needed
    } catch (e) {
      _showError(e.toString());
    }
  }

  Future<void> _updateDevice() async {
    try {
      await _apiService.modifyDeviceName(
          widget.userId, widget.device['deviceid'], _nameController.text);
      await _apiService.modifyDeviceLocation(
          widget.userId, widget.device['deviceid'], _locationController.text);
      Navigator.pop(context, 'update'); // Indicate that an update has occurred
    } catch (e) {
      _showError(e.toString());
    }
  }

//Make lights blink white for 5 seconds
  void _identifyDevice() async {
    try {
      String deviceID = widget.device['deviceid'];
      String result = await _apiService.identifyDevice(deviceID);
      _showError(result);
    } catch (e) {
      _showError(e.toString());
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Device Details'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: _deleteDevice,
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Device Name'),
              onSubmitted: (_) => _updateDeviceName(),
            ),
            TextField(
              controller: _locationController,
              decoration: InputDecoration(labelText: 'Device Location'),
              onSubmitted: (_) => _updateDeviceLocation(),
            ),
            ElevatedButton(
              onPressed: _updateDevice,
              child: Text('Update Device Info'),
            ),
            ElevatedButton(
              onPressed: _identifyDevice,
              child: Text('Identify Device'),
            ),
          ],
        ),
      ),
    );
  }
}
