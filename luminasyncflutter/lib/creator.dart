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
  int containerCount = 8;
  final ApiService _apiService = ApiService();
  List<Offset> circlePositions = [];
  List<int> deviceNumbers = []; // List to hold device numbers
  List<Color> _chosenColors = [];
  Future? loadColorsFuture;

  @override
  void initState() {
    super.initState();
    // _chosenColors = List.generate(containerCount, (index) => Colors.blue);
    // loadColors();
    loadColorsFuture = loadColors(); // Store the Future
  }

  void _onButtonPressed(int index) {
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
                  color: _chosenColors[index],
                  onChanged: (value) {
                    setState(() {
                      _chosenColors[index] = value;
                    });
                    saveColors();
                  },
                  initialPicker: Picker.paletteHue,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context). pop();
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

  //Add a row of containers
  void _addContainers() {
    setState(() {
      containerCount += 2; // Increase the container count by 2
      _chosenColors.addAll(List.generate(2, (_) => Colors.blue)); // Initialize colors for new containers
    });
    saveColors();
  }

  //Remove a row of containers
  void _removeRow() {
    setState(() {
      if (containerCount > 2) {
        containerCount -= 2;
        _chosenColors.removeRange(containerCount, _chosenColors.length); // Remove colors for removed containers
      }
    });
    saveColors();
  }

  //Reset the Pattern
  void _resetContainers() {
  setState(() {
    containerCount = 8;
    _chosenColors = List<Color>.generate(8, (index) => Colors.blue);
  });
  saveColors();
  }

  // Convert Color to String
  String colorToString(Color color) {
    return color.value.toRadixString(16);
  }

  // Convert String to Color
  Color stringToColor(String colorString) {
    return Color(int.parse(colorString, radix: 16));
  }

  // Save colors to SharedPreferences
  Future<void> saveColors() async {
    final prefs = await SharedPreferences.getInstance();
    final colorStrings = _chosenColors.map(colorToString).toList();
    await prefs.setStringList('chosenColors', colorStrings);
  }

  // Load colors from SharedPreferences
  Future<void> loadColors() async {
    final prefs = await SharedPreferences.getInstance();
    final colorStrings = prefs.getStringList('chosenColors');

    if (colorStrings == null || colorStrings.isEmpty) {
      _chosenColors = List.generate(containerCount, (index) => Colors.blue);
    } else {
      _chosenColors = colorStrings.map(stringToColor).toList();
    }

    setState(() {}); // Notify the framework that the internal state of this object has changed.
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadColorsFuture, // Pass the stored Future
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (loadColorsFuture == null || snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator()); // Show a loading spinner while waiting
        } else {
          return Scaffold(
            appBar: AppBar(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Pattern Creator'),
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: _resetContainers,
                      ),
                      IconButton(
                        icon: Icon(Icons.add),
                        onPressed: _addContainers,
                      ),
                      IconButton(
                        icon: Icon(Icons.remove),
                        onPressed: _removeRow,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: GridView.count(
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 40, // Decreased cross axis spacing
                      mainAxisSpacing: 20, // Decreased main axis spacing
                      crossAxisCount: 2,
                      children: List.generate(containerCount, (index) {
                        return Container(
                          padding: const EdgeInsets.all(8),
                          color: _chosenColors[index], // Use individual color for each container
                          child: GestureDetector(
                            onTap: () => _onButtonPressed(index), // Pass index to the onTap function
                            child: Text(
                              'Container ${index + 1}', // Display the container index
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}