import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:luminasyncflutter/device_details_page.dart';
import 'package:luminasyncflutter/device_discovery_page.dart';
import 'package:luminasyncflutter/switch.dart';

class DeviceManagerScreen extends StatefulWidget {
  final String userId;

  const DeviceManagerScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _DeviceManagerScreenState createState() => _DeviceManagerScreenState();
}

class _DeviceManagerScreenState extends State<DeviceManagerScreen> {
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
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  //   builder: (context) => DeviceDiscoveryPage(userId: widget.userId), //Add this back later
                  builder: (context) => DeviceDiscoveryPage(),
                ),
              );
            },
          ),
        ],
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
                String deviceName = device['devicename'] as String? ??
                    'Unknown Device'; //Handle null device name
                String deviceLocation = device['devicelocation'] as String? ??
                    'No Location Specified'; //Handle null device location

                return SwitchAndButton(
                    name: deviceName, location: deviceLocation);
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
