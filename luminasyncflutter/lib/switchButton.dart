import 'package:flutter/material.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Switch and Button'),
        ),
        body: SwitchAndButton(
          name: '',
          location: '',
          updateChosenColor: (Color color) {},
        ),
      ),
    );
  }
}

class SwitchAndButton extends StatefulWidget {
  final String name;
  final String location;
  final void Function(Color) updateChosenColor;
  SwitchAndButton(
      {required this.name,
      required this.location,
      required this.updateChosenColor});

  @override
  _SwitchAndButtonState createState() => _SwitchAndButtonState();
}

class _SwitchAndButtonState extends State<SwitchAndButton> {
  bool _switchValue = false;
  Color _chosenColor = Colors.blue;

  void _onButtonPressed() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pick a Color'),
          content: Container(
            width: double.maxFinite, // Set width to fill available space
            height: 600, // Set height according to your preference
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
                });
              },
            )
          ],
        ));
  }
}
