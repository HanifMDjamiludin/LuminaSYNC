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
    return Row(
  crossAxisAlignment: CrossAxisAlignment.start, // Adjust alignment if needed
  children: <Widget>[
    Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20, // Decreased cross axis spacing
        mainAxisSpacing: 20, // Decreased main axis spacing
        crossAxisCount: 1,
        children: <Widget>[
           Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[100],
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
          color: Colors.teal[100],
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
          color: Colors.teal[100],
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
          color: Colors.teal[100],
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
    Expanded(
      child: GridView.count(
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 20, // Decreased cross axis spacing
        mainAxisSpacing: 20, // Decreased main axis spacing
        crossAxisCount: 1,
        children: <Widget>[
                 Container(
          padding: const EdgeInsets.all(8),
          color: Colors.teal[100],
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
          color: Colors.teal[100],
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
          color: Colors.teal[100],
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
          color: Colors.teal[100],
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
);


    }

    // GridView.count(
    //   primary: false,
    //   padding: const EdgeInsets.all(20),
    //   crossAxisSpacing: 40,
    //   mainAxisSpacing: 10,
    //   crossAxisCount: 2,
    //   children: <Widget>[
    //     Container(
    //       padding: const EdgeInsets.all(8),
    //       color: Colors.teal[100],
    //       child: GestureDetector(
    //           onTap: _switchValue ? _onButtonPressed : null,
    //           //TEMPORARY: Need to change this text to a container (not working)
    //           child: Text(
    //             '    ',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //     ),
    //     Container(
    //       padding: const EdgeInsets.all(8),
    //       color: Colors.teal[100],
    //       child: GestureDetector(
    //           onTap: _switchValue ? _onButtonPressed : null,
    //           //TEMPORARY: Need to change this text to a container (not working)
    //           child: Text(
    //             '    ',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //     ),
    //     Container(
    //       padding: const EdgeInsets.all(8),
    //       color: Colors.teal[100],
    //       child: GestureDetector(
    //           onTap: _switchValue ? _onButtonPressed : null,
    //           //TEMPORARY: Need to change this text to a container (not working)
    //           child: Text(
    //             '    ',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //     ),
    //     Container(
    //       padding: const EdgeInsets.all(8),
    //       color: Colors.teal[100],
    //       child: GestureDetector(
    //           onTap: _switchValue ? _onButtonPressed : null,
    //           //TEMPORARY: Need to change this text to a container (not working)
    //           child: Text(
    //             '    ',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //     ),
    //     Container(
    //       padding: const EdgeInsets.all(8),
    //       color: Colors.teal[100],
    //       child: GestureDetector(
    //           onTap: _switchValue ? _onButtonPressed : null,
    //           //TEMPORARY: Need to change this text to a container (not working)
    //           child: Text(
    //             '    ',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //     ),
    //     Container(
    //       padding: const EdgeInsets.all(8),
    //       color: Colors.teal[100],
    //       child: GestureDetector(
    //           onTap: _switchValue ? _onButtonPressed : null,
    //           //TEMPORARY: Need to change this text to a container (not working)
    //           child: Text(
    //             '    ',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //     ),
    //     Container(
    //       padding: const EdgeInsets.all(8),
    //       color: Colors.teal[100],
    //       child: GestureDetector(
    //           onTap: _switchValue ? _onButtonPressed : null,
    //           //TEMPORARY: Need to change this text to a container (not working)
    //           child: Text(
    //             '    ',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //     ),
    //     Container(
    //       padding: const EdgeInsets.all(8),
    //       color: Colors.teal[100],
    //       child: GestureDetector(
    //           onTap: _switchValue ? _onButtonPressed : null,
    //           //TEMPORARY: Need to change this text to a container (not working)
    //           child: Text(
    //             '    ',
    //             style: TextStyle(color: Colors.white),
    //           ),
    //         ),
    //     ), 
    //   ],
    // );
  }

