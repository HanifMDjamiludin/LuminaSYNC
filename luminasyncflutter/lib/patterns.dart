import 'package:flutter/material.dart';
import 'dart:io';

class PresetPatterns extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Patterns'),
      ),
      body: Center(
        child: GridView.count(
          primary: false,
          padding: const EdgeInsets.all(20),
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          crossAxisCount: 2,
          children: <Widget>[
    Container(
      padding: const EdgeInsets.all(8),
      color: Colors.red[100],
      child: GestureDetector(onTap: () => print("Pattern selected"),),
    ),
    Container(
      padding: const EdgeInsets.all(8),
      color: Colors.red[200],
      child: GestureDetector(onTap: () => print("Pattern selected"),),

    ),
    Container(
      padding: const EdgeInsets.all(8),
      color: Colors.red[300],
      child: GestureDetector(onTap: () => print("Pattern selected"),),
    ),
    Container(
      padding: const EdgeInsets.all(8),
      color: Colors.red[400],
      child: GestureDetector(onTap: () => print("Pattern selected"),),

    ),
    Container(
      padding: const EdgeInsets.all(8),
      color: Colors.teal[500],
      child: GestureDetector(onTap: () => print("Pattern selected"),),

    ),
    Container(
      padding: const EdgeInsets.all(8),
      color: Colors.teal[600],
      child: GestureDetector(onTap: () => print("Pattern selected"),),

    ),
  ],
        ),
      ),
    );
  }
}
