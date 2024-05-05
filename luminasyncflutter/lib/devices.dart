import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:luminasyncflutter/switchButton.dart';

class DeviceManagerScreen extends StatefulWidget {
  final String userId;

  const DeviceManagerScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _DeviceManagerScreenState createState() => _DeviceManagerScreenState();
}

class _DeviceManagerScreenState extends State<DeviceManagerScreen> {
  late Future<List<dynamic>> _devicesFuture;
  bool masterSwitchState = false;

  @override
  void initState() {
    super.initState();
    _devicesFuture = ApiService().getUserDevices(widget.userId);
    _loadMasterSwitchState();
  }

  void _loadMasterSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool savedSwitchState = prefs.getBool('masterSwitchState') ?? true;
    setState(() {
      masterSwitchState = savedSwitchState;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'My Devices',
              style:
                  TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
            ),
            Switch(
              value: masterSwitchState,
              onChanged: (newValue) {
                setState(() {
                  masterSwitchState = newValue;
                  _turnAllDevices(newValue);
                  _saveMasterSwitchState();
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
                  masterSwitchState: masterSwitchState,
                  toggleMasterSwitch: _toggleMasterSwitch,
                );
              },
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  void _turnAllDevices(bool state) async {
    List<dynamic> devices = await _devicesFuture;
    for (var device in devices) {
      String deviceId = device['deviceid'] as String? ?? '';
      await ApiService().setPower(deviceId, state ? 'on' : 'off');
    }
  }

  void _toggleMasterSwitch() {
    setState(() {
      masterSwitchState = !masterSwitchState;
      _turnAllDevices(masterSwitchState);
      _saveMasterSwitchState();
    });
  }

  void _saveMasterSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('masterSwitchState', masterSwitchState);
  }
}
