import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class DeviceManagerPage extends StatefulWidget {
  final String userId;

  const DeviceManagerPage({Key? key, required this.userId}) : super(key: key);

  @override
  _DeviceManagerPageState createState() => _DeviceManagerPageState();
}

class _DeviceManagerPageState extends State<DeviceManagerPage> {
  late Future<List<dynamic>> _devicesFuture;

  @override
  void initState() {
    super.initState();
    _devicesFuture = ApiService().getUserDevices(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Device Manager"),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _devicesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Text("Error: ${snapshot.error}");
            }
            return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
                var device = snapshot.data![index];
                String deviceName = device['devicename'] as String? ?? 'Unknown Device'; //Handle null device name
                String deviceLocation = device['devicelocation'] as String? ?? 'No Location Specified'; //Handle null device location

                return ListTile(
                title: Text(deviceName),
                subtitle: Text('Location: $deviceLocation'),
                trailing: Icon(Icons.edit),
                onTap: () {
                    // Handle device tap here
                },
                );
            },
            );

          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
