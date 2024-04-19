import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:luminasyncflutter/switch.dart';

class DeviceManagerScreen extends StatefulWidget {
  final String userId;

  const DeviceManagerScreen({Key? key, required this.userId}) : super(key: key);

  @override
  _DeviceManagerScreenState createState() => _DeviceManagerScreenState();
}

class _DeviceManagerScreenState extends State<DeviceManagerScreen> {
  late Future<List<dynamic>> _devicesFuture;
  List<Color> _deviceColors = [];

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
            _deviceColors =
                List<Color>.filled(snapshot.data!.length, Colors.white);
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                var device = snapshot.data![index];
                String deviceName =
                    device['devicename'] as String? ?? 'Unknown Device';
                String deviceLocation = device['devicelocation'] as String? ??
                    'No Location Specified';

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

  void _showColorPicker(BuildContext context, int index) {
    Color currentColor = _deviceColors[index]; // Initial color
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                setState(() {
                  currentColor = color;
                });
              },
              pickerAreaHeightPercent: 0.6,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                setState(() {
                  _deviceColors[index] = currentColor; // Update color
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
