import 'dart:math';

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
          title: Text('Pattern Creator'),
        ),
        body: Center(child: PatternCreator()),
      ),
    );
  }
}
//hanif comment
class PatternCreator extends StatefulWidget {
  @override
  _PatternCreatorState createState() => _PatternCreatorState();
}

class _PatternCreatorState extends State<PatternCreator> {
  bool _switchValue = false;

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
              color: Colors.blue,
              onChanged: (value) {
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
    return SizedBox(
      height: 25, // Set a fixed height for the container
      child: Container(
        decoration: BoxDecoration(
          color: _switchValue ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _switchValue ? _onButtonPressed : null,
              //TEMPORARY: Need to change this text to a container (not working)
              child: Text(
                '    ',
                style: TextStyle(color: Colors.white),
              ),
            ),
            Transform.scale(
                scale: 0.5,
                child: Switch(
                  value: _switchValue,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                  },
                ))
          ],
        ),
      ),
    );
  }
}
