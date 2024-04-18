import 'package:flutter/material.dart';

class DeviceDiscoveryPage extends StatefulWidget {
  @override
  _DeviceDiscoveryPageState createState() => _DeviceDiscoveryPageState();
}

class _DeviceDiscoveryPageState extends State<DeviceDiscoveryPage> {
  List<String> deviceIds = ['4291ca36-c9c3-5fd7-abb8-d74469c7a2f7']; // Dummy device IDs

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Discovery"),
      ),
      body: ListView.builder(
        itemCount: deviceIds.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(deviceIds[index]),
          );
        },
      ),
    );
  }
}
