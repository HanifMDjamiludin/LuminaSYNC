import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:luminasyncflutter/device_details_page.dart';
import 'package:luminasyncflutter/device_discovery_page.dart';
import 'package:google_fonts/google_fonts.dart';

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
        title: Center(
          child: Text(
            'LuminaSYNC',
            style: GoogleFonts.orbitron(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Colors.black54,
        elevation: 5,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
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
                String deviceName =
                    device['devicename'] as String? ?? 'Unknown Device';
                String deviceLocation = device['devicelocation'] as String? ??
                    'No Location Specified';

                return ListTile(
                  title: Text(deviceName),
                  subtitle: Text('Location: $deviceLocation'),
                  trailing: Icon(
                    Icons.edit,
                    color: Colors.blue,
                  ),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DeviceDetailsPage(
                          device: snapshot.data![index],
                          userId: widget.userId,
                        ),
                      ),
                    );
                    if (result == 'update') {
                      setState(() {
                        _devicesFuture =
                            ApiService().getUserDevices(widget.userId);
                      });
                    }
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
