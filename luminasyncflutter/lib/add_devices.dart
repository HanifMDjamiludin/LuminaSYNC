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
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  '+',
                  style: TextStyle(fontSize: 50, color: Colors.white),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          // Render a red circle with text for each position in the list
          for (var i = 0; i < circlePositions.length; i++)
            GridView.count(
              shrinkWrap: true,
              primary: false,
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
    Container(
      padding: const EdgeInsets.all(8),
      color: Colors.teal[100],
    ),]

            ),
        ],
      ),
    );
  }
}
