import 'dart:math';

import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class PatternCreator extends StatefulWidget {
  @override
  _PatternCreatorState createState() => _PatternCreatorState();
}

class _PatternCreatorState extends State<PatternCreator> {
  Color _chosenColor = Colors.blue;
  final ApiService _apiService = ApiService();

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
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _saveChosenColor(
                        _chosenColor); // This Saves the chosen color
                    // _updateLEDColor(_chosenColor); // Update LED color
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

    void _saveChosenColor(Color color) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setInt('${widget.deviceId}_chosenColor', color.value);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
      crossAxisAlignment:
          CrossAxisAlignment.start, // Adjust alignment if needed
      children: <Widget>[
        Expanded(
          child: GridView.count(
            padding: const EdgeInsets.all(20),
            crossAxisSpacing: 40, // Decreased cross axis spacing
            mainAxisSpacing: 20, // Decreased main axis spacing
            crossAxisCount: 2,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(8),
                color: _chosenColor,
                child: GestureDetector(
                  onTap: _onButtonPressed,
                  //TEMPORARY: Need to change this text to a container (not working)
                  child: Text(
                    '  ONE  ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: _chosenColor,
                child: GestureDetector(
                  onTap: _onButtonPressed,
                  //TEMPORARY: Need to change this text to a container (not working)
                  child: Text(
                    '    ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
             Container(
                padding: const EdgeInsets.all(8),
                color: _chosenColor,
                child: GestureDetector(
                  onTap: _onButtonPressed,
                  //TEMPORARY: Need to change this text to a container (not working)
                  child: Text(
                    '  THREE  ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: _chosenColor,
                child: GestureDetector(
                  onTap: _onButtonPressed,
                  //TEMPORARY: Need to change this text to a container (not working)
                  child: Text(
                    '    ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: _chosenColor,
                child: GestureDetector(
                  onTap: _onButtonPressed,
                  //TEMPORARY: Need to change this text to a container (not working)
                  child: Text(
                    '    ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: _chosenColor,
                child: GestureDetector(
                  onTap: _onButtonPressed,
                  //TEMPORARY: Need to change this text to a container (not working)
                  child: Text(
                    '    ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: _chosenColor,
                child: GestureDetector(
                  onTap: _onButtonPressed,
                  //TEMPORARY: Need to change this text to a container (not working)
                  child: Text(
                    '    ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                color: _chosenColor,
                child: GestureDetector(
                  onTap: _onButtonPressed,
                  //TEMPORARY: Need to change this text to a container (not working)
                  child: Text(
                    '    ',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )
    );
  }
}
