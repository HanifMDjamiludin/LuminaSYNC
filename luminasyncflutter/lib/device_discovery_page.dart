import 'package:flutter/material.dart';
import 'package:flutter_nsd/flutter_nsd.dart';
import 'add_device_page.dart';

class ServiceInfoWithId {
  final NsdServiceInfo serviceInfo;
  final String id;

  ServiceInfoWithId({required this.serviceInfo, required this.id});
}

class DeviceDiscoveryPage extends StatefulWidget {
  @override
  _DeviceDiscoveryPageState createState() => _DeviceDiscoveryPageState();
}

class _DeviceDiscoveryPageState extends State<DeviceDiscoveryPage> {
  final FlutterNsd _flutterNsd = FlutterNsd();
  List<ServiceInfoWithId> _services = [];
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

  String decodeTxtRecord(List<int> bytes) {
    return String.fromCharCodes(bytes);
  }

  void initNsd() async {
    _flutterNsd.stream.listen((nsdServiceInfo) {
      final decodedTxt = nsdServiceInfo.txt?.map((key, value) => MapEntry(key, decodeTxtRecord(value))) ?? {};
      String id = decodedTxt['id'] ?? 'default_id';

      if (decodedTxt.containsKey('id')) {
        final serviceInfoWithId = ServiceInfoWithId(serviceInfo: nsdServiceInfo, id: id);
        
        setState(() {
          _services.add(serviceInfoWithId);
        });
      }

      print('Discovered service name: ${nsdServiceInfo.name}');
      print('Discovered service hostname/IP: ${nsdServiceInfo.hostname}');
      print('Discovered service port: ${nsdServiceInfo.port}');
      print('Discovered service TXT record: $decodedTxt');
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
          final serviceWithId = _services[index];
          return ListTile(
            title: Text(serviceWithId.serviceInfo.name ?? 'Unknown Service'),
            subtitle: Text('${serviceWithId.serviceInfo.hostname ?? 'No Hostname'}:${serviceWithId.serviceInfo.port}'),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddDevicePage(serviceWithId: serviceWithId),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
