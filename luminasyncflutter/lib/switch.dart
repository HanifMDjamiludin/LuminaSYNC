// import 'package:flutter/material.dart';

// void main() => runApp(const SwitchApp());

// class SwitchApp extends StatelessWidget {
//   const SwitchApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData(useMaterial3: true),
//       home: Scaffold(
//         appBar: AppBar(title: const Text('Switch Sample')),
//         body: const Center(
//           child: SwitchExample(),
//         ),
//       ),
//     );
//   }
// }

// class SwitchExample extends StatefulWidget {
//   const SwitchExample({super.key});

//   @override
//   State<SwitchExample> createState() => _SwitchExampleState();
// }

// class _SwitchExampleState extends State<SwitchExample> {
//   bool light = true;

//   @override
//   Widget build(BuildContext context) {
//     return Switch(
//       // This bool value toggles the switch.
//       value: light,
//       activeColor: Colors.red,
//       onChanged: (bool value) {
//         // This is called when the user toggles the switch.
//         setState(() {
//           light = value;
//         });
//       },
//     );
//   }
// }

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
          title: Text('Switch and Button'),
        ),
        body: SwitchAndButton(),
      ),
    );
  }
}

class SwitchAndButton extends StatefulWidget {
  @override
  _SwitchAndButtonState createState() => _SwitchAndButtonState();
}

class _SwitchAndButtonState extends State<SwitchAndButton> {
  bool _switchValue = false;

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
        Switch(
          value: _switchValue,
          onChanged: (value) {
            setState(() {
              _switchValue = value;
            });
          },
        ),
        GestureDetector(
          onTap: _switchValue ? _onButtonPressed : null,
          child: Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Click Me',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    )
    );
  }

  void _onButtonPressed() {
    // Do something when the button is pressed
    print('Button clicked');
  }
}
