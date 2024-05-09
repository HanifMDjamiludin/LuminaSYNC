import 'package:flutter/material.dart';
import 'package:flutter_nsd/flutter_nsd.dart';
import 'add_device_page.dart';

class DeviceDiscoveryPage extends StatefulWidget {
  @override
  _DeviceDiscoveryPageState createState() => _DeviceDiscoveryPageState();
}

class _DeviceDiscoveryPageState extends State<DeviceDiscoveryPage> {
  final FlutterNsd _flutterNsd = FlutterNsd();
  List<NsdServiceInfo> _services = [];
  bool _isDiscovering = false;

  @override
  void initState() {
    super.initState();
    initNsd();
  }

  @override
  void dispose() {
    if (_isDiscovering) {
      _stopDiscovery();
    }
    super.dispose();
  }

  void initNsd() async {
    _flutterNsd.stream.listen((nsdServiceInfo) {
      setState(() {
        _services.add(nsdServiceInfo);
      });
      print('Discovered service name: ${nsdServiceInfo.name}');
      print('Discovered service hostname/IP: ${nsdServiceInfo.hostname}');
      print('Discovered service port: ${nsdServiceInfo.port}');
    }, onError: (e) {
      print('NSD Stream Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error during service discovery: $e')));
    });

    try {
      await _flutterNsd.discoverServices('_hyperiond-json._tcp.');
      setState(() {
        _isDiscovering = true;
      });
    } catch (e) {
      print('Failed to start discovery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to start discovery: $e')));
    }
  }

  void _stopDiscovery() {
    _flutterNsd.stopDiscovery().then((_) {
      print('Discovery stopped successfully.');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Discovery stopped successfully')));
    }).catchError((e) {
      print('Error stopping discovery: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error stopping discovery: $e')));
    }).whenComplete(() {
      setState(() {
        _isDiscovering = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Discovery"),
      ),
      body: ListView.builder(
        itemCount: _services.length,
        itemBuilder: (context, index) {
          final service = _services[index];
          return ListTile(
            title: Text(service.name ?? 'Unknown Service'),
            subtitle:
                Text('${service.hostname ?? 'No Hostname'}:${service.port}'),
            onTap: () {
              // Assuming AddDevicePage manages device connection setup and configuration
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddDevicePage(serviceInfo: service),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
