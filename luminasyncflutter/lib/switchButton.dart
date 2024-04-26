import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SwitchAndButton extends StatefulWidget {
  final String name;
  final String location;
  final String deviceId;
  final bool initialSwitchState;

  SwitchAndButton({
    required this.name,
    required this.location,
    required this.deviceId,
    required this.initialSwitchState,
  });

  @override
  _SwitchAndButtonState createState() => _SwitchAndButtonState();
}

class _SwitchAndButtonState extends State<SwitchAndButton> {
  bool _switchValue = false;
  Color _chosenColor = Colors.blue;
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

  void _onButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color'),
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
                    });
                  },
                  initialPicker: Picker.paletteHue,
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _saveChosenColor(
                        _chosenColor); // This Saves the chosen color
                    _updateLEDColor(_chosenColor); // Update LED color
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
    );
  }
}
