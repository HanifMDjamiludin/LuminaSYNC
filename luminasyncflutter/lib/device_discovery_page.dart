// import 'package:flutter/material.dart';

// class DeviceDiscoveryPage extends StatefulWidget {
//   @override
//   _DeviceDiscoveryPageState createState() => _DeviceDiscoveryPageState();
// }

// class _DeviceDiscoveryPageState extends State<DeviceDiscoveryPage> {
//   List<String> deviceIds = ['4291ca36-c9c3-5fd7-abb8-d74469c7a2f7']; // Dummy device IDs

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Device Discovery"),
//       ),
//       body: ListView.builder(
//         itemCount: deviceIds.length,
//         itemBuilder: (context, index) {
//           return ListTile(
//             title: Text(deviceIds[index]),
//           );
//         },
//       ),
//     );
//   }
// }

/*
This page will crash the flutter app when running on emulator, because the emulator does not support NSD. Keeping the placeholder page commented above for reference.
*/
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

  @override
  void initState() {
    super.initState();
    initNsd();
  }

  @override
  void dispose() {
    _flutterNsd.stopDiscovery();
    super.dispose();
  }

  void initNsd() async {
    _flutterNsd.stream.listen(
      (nsdServiceInfo) {
        setState(() {
          _services.add(nsdServiceInfo);
        });
        print('Discovered service name: ${nsdServiceInfo.name}');
        print('Discovered service hostname/IP: ${nsdServiceInfo.hostname}');
        print('Discovered service port: ${nsdServiceInfo.port}');
      },
      onError: (e) {
        if (e is NsdError) {
          print('NSD Error: ${e.errorCode}');
        }
      }
    );

    await _flutterNsd.discoverServices('_hyperiond-json._tcp.local.');
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
            subtitle: Text('${service.hostname ?? 'No Hostname'}:${service.port}'),
            onTap: () {
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
