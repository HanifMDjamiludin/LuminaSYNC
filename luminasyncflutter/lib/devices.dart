import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:luminasyncflutter/switchButton.dart';

class DeviceManagerScreen extends StatefulWidget {
  final String userId;

  const DeviceManagerScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _DeviceManagerScreenState createState() => _DeviceManagerScreenState();
}

class _DeviceManagerScreenState extends State<DeviceManagerScreen> {
  late Future<List<dynamic>> _devicesFuture;
  bool masterSwitchState = true; // Initial state of master switch

  @override
  void initState() {
    super.initState();
    _devicesFuture = ApiService().getUserDevices(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'MY DEVICES',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            Switch(
              value: masterSwitchState,
              onChanged: (newValue) {
                setState(() {
                  masterSwitchState = newValue;
                  _turnAllDevices(newValue);
                });
              },
            ),
          ],
        ),
        backgroundColor: Colors.black54,
        elevation: 10,
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

// Function to turn on/off all devices based on master switch state
  void _turnAllDevices(bool state) async {
    try {
      List<dynamic> devices = await ApiService().getUserDevices(widget.userId);
      for (var device in devices) {
        String deviceId = device['deviceid'] as String? ?? '';
        await ApiService().setPower(deviceId, state ? 'on' : 'off');
      }
    } catch (e) {
      print('Error turning all devices: $e');
    }
  }
}
