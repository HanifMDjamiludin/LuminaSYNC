import 'package:flutter/material.dart';

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
    // Do something when the button is pressed
    print('Button clicked');
    // Navigator.push(
    //   context
    //   ,MaterialPageRoute(builder: (context) => PatternGrid()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50, // Set a fixed height for the container
      child: Container(
        decoration: BoxDecoration(
          color: _switchValue ? Colors.blue : Colors.grey,
          borderRadius: BorderRadius.circular(5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: _switchValue ? _onButtonPressed : null,
              child: Container(
                padding: EdgeInsets.all(5),
                // Add your button widget or content here
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
