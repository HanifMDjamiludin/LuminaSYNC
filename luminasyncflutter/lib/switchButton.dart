import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchAndButton extends StatefulWidget {
  final String name;
  final String location;
  final String deviceId;
  final bool initialSwitchState;
  final bool masterSwitchState;
  final VoidCallback toggleMasterSwitch;

  SwitchAndButton({
    required this.name,
    required this.location,
    required this.deviceId,
    required this.initialSwitchState,
    required this.masterSwitchState,
    required this.toggleMasterSwitch,
  });

  @override
  _SwitchAndButtonState createState() => _SwitchAndButtonState();
}

class _SwitchAndButtonState extends State<SwitchAndButton> {
  bool _switchValue = false;
  Color _chosenColor = Colors.blue;
  double _brightnessLevel = 64;
  String _percentage = "50";
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadSwitchState();
    _loadChosenColor();
  }

  void _loadSwitchState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _switchValue = prefs.getBool('${widget.deviceId}_switchState') ??
          widget.initialSwitchState;
    });
  }

  void _loadChosenColor() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _chosenColor = Color(
          prefs.getInt('${widget.deviceId}_chosenColor') ?? Colors.blue.value);
    });
  }

  void _updateColor(double brightness) {
    setState(() {
      _brightnessLevel = brightness;
      _percentage = (_brightnessLevel / 128).toStringAsFixed(0) + "%";
      _apiService.setBrightness(widget.deviceId, _brightnessLevel.toString());
    });
  }

  void _onButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a Color'),
          content: Container(
            width: double.maxFinite,
            height: 600,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ColorPicker(
                  color: _chosenColor,
                  onChanged: (value) {
                    setState(() {
                      _chosenColor = value;
                      _updateLEDColor(_chosenColor);
                    });
                  },
                  initialPicker: Picker.paletteHue,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _saveChosenColor(_chosenColor);
                    Navigator.of(context).pop();
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _setDevicePower(String power) async {
    try {
      await _apiService.setPower(widget.deviceId, power);
    } catch (e) {
      print('Error setting device power: $e');
    }
  }

  void _saveSwitchState(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('${widget.deviceId}_switchState', value);
  }

  void _saveChosenColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt('${widget.deviceId}_chosenColor', color.value);
  }

  Future<void> _updateLEDColor(Color color) async {
    try {
      String hexColor = '#${color.value.toRadixString(16).substring(2)}';
      await _apiService.setColor(widget.deviceId, hexColor);
    } catch (e) {
      print('Error updating LED color: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          color: widget.masterSwitchState ? _chosenColor : Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                GestureDetector(
                  onTap: widget.masterSwitchState ? _onButtonPressed : null,
                  child: Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: Text(
                      '${widget.name} in ${widget.location} is ${widget.masterSwitchState ? (_switchValue ? 'on' : 'off') : 'off'}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Switch(
                  value: _switchValue && widget.masterSwitchState,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                      if (value) {
                        if (!widget.masterSwitchState) {
                          widget.toggleMasterSwitch();
                        }
                        _setDevicePower('on');
                        _updateLEDColor(_chosenColor);
                      } else {
                        _setDevicePower('off');
                      }
                      _saveSwitchState(value);
                    });
                  },
                )
              ],
            ),
            Slider(
              value: _brightnessLevel,
              onChanged: _updateColor,
              min: 0,
              max: 128,
              divisions: 128,
              label: _percentage,
            )
          ],
        ));
  }
}
