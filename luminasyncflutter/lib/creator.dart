import 'dart:math';

import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import "package:luminasyncflutter/save_pattern.dart";

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text('PATTERN CREATOR'),
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
  List<Color> _leftColumnColors = []; // List to hold colors for the left column
  List<Color> _rightColumnColors =
      []; // List to hold colors for the right column

  @override
  void initState() {
    super.initState();
    loadColorsFuture = loadColors(); // Store the Future
    _leftColumnColors = List.generate(containerCount ~/ 2, (_) => Colors.blue);
    _rightColumnColors = List.generate(containerCount ~/ 2, (_) => Colors.blue);
  }

  void _onButtonPressed(int index) {
    bool isLeftColumn = index % 2 == 0;
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
                  color: isLeftColumn
                      ? _leftColumnColors[index ~/ 2]
                      : _rightColumnColors[index ~/ 2],
                  onChanged: (value) {
                    setState(() {
                      if (isLeftColumn) {
                        _leftColumnColors[index ~/ 2] = value;
                      } else {
                        _rightColumnColors[index ~/ 2] = value;
                      }
                    });
                    saveColors();
                  },
                  initialPicker: Picker.hsv,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
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
      // _chosenColors.addAll(List.generate(2, (_) => Colors.blue)); // Initialize colors for new containers
      _leftColumnColors
          .add(Colors.blue); // Add a new default color to the left column
      _rightColumnColors
          .add(Colors.blue); // Add a new default color to the right column
    });
    saveColors();
  }

  //Remove a row of containers
  void _removeRow() {
    setState(() {
      if (containerCount > 2) {
        containerCount -= 2;
        // _chosenColors.removeRange(containerCount, _chosenColors.length); // Remove colors for removed containers
        _leftColumnColors
            .removeLast(); // Remove the last color from the left column
        _rightColumnColors
            .removeLast(); // Remove the last color from the right column
      }
    });
    saveColors();
  }

  // Reset the pattern
  void _resetContainers() {
    setState(() {
      containerCount =
          8; // Ensures the total count remains even and can be evenly split
      _leftColumnColors =
          List<Color>.generate(containerCount ~/ 2, (index) => Colors.blue);
      _rightColumnColors =
          List<Color>.generate(containerCount ~/ 2, (index) => Colors.blue);
    });
    saveColors(); // Save the reset colors to SharedPreferences
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
    final leftColorStrings = _leftColumnColors.map(colorToString).toList();
    final rightColorStrings = _rightColumnColors.map(colorToString).toList();
    await prefs.setStringList('leftColumnColors', leftColorStrings);
    await prefs.setStringList('rightColumnColors', rightColorStrings);
    await prefs.setInt(
        'containerCount', containerCount); // Save the container count
  }

  // Load colors from SharedPreferences
  Future<void> loadColors() async {
    final prefs = await SharedPreferences.getInstance();
    final leftColorStrings =
        prefs.getStringList('leftColumnColors'); // Retrieve left column colors
    final rightColorStrings = prefs
        .getStringList('rightColumnColors'); // Retrieve right column colors
    containerCount =
        prefs.getInt('containerCount') ?? 8; // Default to 8 if not set

    _leftColumnColors = leftColorStrings != null
        ? leftColorStrings.map(stringToColor).toList()
        : // Check if leftColorStrings is null
        List.generate(containerCount ~/ 2,
            (_) => Colors.blue); // Initialize colors if null
    _rightColumnColors = rightColorStrings != null
        ? rightColorStrings.map(stringToColor).toList()
        : // Check if rightColorStrings is null
        List.generate(containerCount ~/ 2,
            (_) => Colors.blue); // Initialize colors if null

    setState(
        () {}); // Notify the framework that the internal state of this object has changed.
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadColorsFuture, // Pass the stored Future
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (loadColorsFuture == null ||
            snapshot.connectionState == ConnectionState.waiting) {
          return Center(
              child:
                  CircularProgressIndicator()); // Show a loading spinner while waiting
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
            body: Column(
              children: <Widget>[
                Expanded(
                  child: GridView.count(
                    padding: const EdgeInsets.all(20),
                    crossAxisSpacing: 40, // Decreased cross axis spacing
                    mainAxisSpacing: 20, // Decreased main axis spacing
                    crossAxisCount: 2,
                    children: List.generate(containerCount, (index) {
                      bool isLeftColumn = index % 2 == 0;
                      return Container(
                        padding: const EdgeInsets.all(8),
                        color: isLeftColumn
                            ? _leftColumnColors[index ~/ 2]
                            : _rightColumnColors[index ~/
                                2], // Use individual color for each container
                        child: GestureDetector(
                          onTap: () => _onButtonPressed(
                              index), // Pass index to the onTap function
                          child: Text(
                            'Container ${index + 1}', // Display the container index
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        print('Left Column Colors: $_leftColumnColors');
                        print('Right Column Colors: $_rightColumnColors');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => SubmitPatternPage(
                                leftColors: _leftColumnColors,
                                rightColors: _rightColumnColors),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: const BorderSide(color: Colors.white),
                        ),
                      ),
                      child: const Text(
                        "Save Pattern",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
