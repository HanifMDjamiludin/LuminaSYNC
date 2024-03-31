import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: Scaffold(
      appBar: AppBar(title: Text('Add Device Button')),
      body: AddDeviceButton(),
    ),
  ));
}

class AddDeviceButton extends StatefulWidget {
  @override
  _AddDeviceButtonState createState() => _AddDeviceButtonState();
}

class _AddDeviceButtonState extends State<AddDeviceButton> {
  List<Offset> circlePositions = [];
  List<int> deviceNumbers = []; // List to hold device numbers

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                // Add a new circle position to the list
                final RenderBox renderBox =
                    context.findRenderObject() as RenderBox;
                final newPosition = renderBox.globalToLocal(Offset.zero);
                circlePositions.add(newPosition);

                // Add a new device number for the new circle
                deviceNumbers.add(deviceNumbers.isEmpty ? 1 : deviceNumbers.last + 1);
              });
            },
            child: Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '+',
                  style: TextStyle(fontSize: 100, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 20),
          // Render a red circle with text for each position in the list
          for (var i = 0; i < circlePositions.length; i++)
            Container(
              width: 160,
              height: 160,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red,
              ),
              margin: EdgeInsets.all(8),
              child: Center(
                child: Text(
                  'Device ${deviceNumbers[i]}', // Text showing device number
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
