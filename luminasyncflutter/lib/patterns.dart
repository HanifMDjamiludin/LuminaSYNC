import 'package:flutter/material.dart';
import 'preset_patterns.dart';
import '/src/api_service.dart';

class PatternTabs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Adjust the number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: Text("Lighting Patterns"),
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.lightbulb_outline), text: "Preset Patterns"),
              Tab(icon: Icon(Icons.palette), text: "Custom Patterns"), // Placeholder for custom patterns tab
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PresetPatterns(),
            Center(child: Text("Custom Patterns Page Will Go Here")), // Placeholder
          ],
        ),
      ),
    );
  }
}