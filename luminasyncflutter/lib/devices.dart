import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:luminasyncflutter/switchButton.dart';

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
        title: Text("MY DEVICES"),
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
                String deviceName =
                    device['devicename'] as String? ?? 'Unknown Device';
                String deviceLocation = device['devicelocation'] as String? ??
                    'No Location Specified';
                String deviceId = device['deviceid'] as String? ?? '';
                bool initialSwitchState =
                    device['switchState'] as bool? ?? false;

                return SwitchAndButton(
                  name: deviceName,
                  location: deviceLocation,
                  deviceId: deviceId,
                  initialSwitchState: initialSwitchState,
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
