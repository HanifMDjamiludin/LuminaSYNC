import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:luminasyncflutter/src/api_service.dart';

class SwitchAndButton extends StatefulWidget {
  final String name;
  final String location;
  final String deviceId; // Add deviceId parameter

  SwitchAndButton({
    required this.name,
    required this.location,
    required this.deviceId, // Include deviceId in constructor
  });

  @override
  _SwitchAndButtonState createState() => _SwitchAndButtonState();
}

class _SwitchAndButtonState extends State<SwitchAndButton> {
  bool _switchValue = false;
  Color _chosenColor = Colors.blue;
  final ApiService _apiService = ApiService(); // Instance of ApiService

  void _onButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color'),
          content: Container(
            width: double.maxFinite,
            height: 600,
            child: ColorPicker(
              onChanged: (value) {
                setState(() {
                  print(value.value.toRadixString(16));
                  _chosenColor = value;
                });
                // Handle color change
              },
              initialPicker: Picker.paletteHue,
            ),
          ),
        );
      },
    );
  }

  // Method to set device power
  Future<void> _setDevicePower(String power) async {
    try {
      await _apiService.setPower(widget.deviceId, power);
    } catch (e) {
      // Handle error
      print('Error setting device power: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: _switchValue ? _chosenColor : Colors.grey,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          GestureDetector(
            onTap: _switchValue ? _onButtonPressed : null,
            child: Container(
              padding: EdgeInsets.all(50),
              child: Text(
                '${widget.name} in ${widget.location} is ${_switchValue ? 'on' : 'off'}',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Switch(
            value: _switchValue,
            onChanged: (value) {
              setState(() {
                _switchValue = value;
                if (value) {
                  print('Current device ID: ${widget.deviceId}');
                  _setDevicePower('on');
                } else {
                  _setDevicePower('off');
                }
              });
            },
          )
        ],
      ),
    );
  }
}
