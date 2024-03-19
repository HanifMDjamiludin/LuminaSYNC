import 'package:flutter/material.dart';
import 'dart:io';

class PatternGrid extends StatelessWidget {
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
            GestureDetector(
                onTap: () => print('aaaaaaaaaaaaaaaaaahh'),
                child: Image.asset('assets/images/strobeLight.jpeg', fit: BoxFit.fill)),
            GestureDetector(
                onTap: () => print('aaaaaaaaaaaaaaaaaahh'),
                child: Image.asset('assets/images/rainbow.jpeg', fit: BoxFit.fill,)),
            GestureDetector(
                onTap: () => print('aaaaaaaaaaaaaaaaaahh'),
                child: Image.asset('assets/images/bubbles.jpeg', fit: BoxFit.fill)),
            GestureDetector(
                onTap: () => print('aaaaaaaaaaaaaaaaaahh'),
                child: Image.asset('assets/images/ColorBlue.jpeg', fit: BoxFit.fill,)),
                GestureDetector(
                onTap: () => print('aaaaaaaaaaaaaaaaaahh'),
                child: Image.asset('assets/images/red.jpeg', fit: BoxFit.fill)),
            GestureDetector(
                onTap: () => print('aaaaaaaaaaaaaaaaaahh'),
                child: Image.asset('assets/images/ColorGreen.jpeg', fit: BoxFit.fill,)),
          ],
        ),
      ),
    );
  }
}
