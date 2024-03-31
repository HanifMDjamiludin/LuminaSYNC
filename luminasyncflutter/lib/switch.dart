import 'package:flutter/material.dart';
import 'package:luminasyncflutter/patternGrid.dart';
import 'package:luminasyncflutter/newCreator.dart';

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
          light: 0,
        ),
      ),
    );
  }
}

class SwitchAndButton extends StatefulWidget {
  final int light;
  SwitchAndButton({required this.light});

  @override
  _SwitchAndButtonState createState() => _SwitchAndButtonState();
}

class _SwitchAndButtonState extends State<SwitchAndButton> {
  bool _switchValue = false;

  void _onButtonPressed() {
    // Do something when the button is pressed
    print('Button clicked');
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => NewCreator()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
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
                padding: EdgeInsets.all(50),
                child: Text(
                  'Light ${widget.light} is $_switchValue',
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
