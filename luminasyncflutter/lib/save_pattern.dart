import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_hsvcolor_picker/flutter_hsvcolor_picker.dart';

class SubmitPatternPage extends StatefulWidget {
  final List<Color> leftColors;
  final List<Color> rightColors;

  SubmitPatternPage(
      {Key? key, required this.leftColors, required this.rightColors})
      : super(key: key);

  @override
  _SubmitPatternPageState createState() => _SubmitPatternPageState();
}

class _SubmitPatternPageState extends State<SubmitPatternPage> {
  String _username = '';
  final _patternNameController = TextEditingController();
  Color _iconColor = Colors.blue; // Default color
  final _patternIntervalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  void _loadUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('userId') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Pattern"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: _patternNameController,
              decoration: InputDecoration(
                labelText: 'Pattern Name',
                border: OutlineInputBorder(),
              ),
            ),
            TextField(
              controller: _patternIntervalController,
              keyboardType:
                  TextInputType.number, // Set keyboard type to numerical
              decoration: InputDecoration(
                labelText: 'Pattern Interval (ms)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            Text("Select Icon Color:"),
            ColorPicker(
              color: _iconColor,
              onChanged: (value) => setState(() => _iconColor = value),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPattern,
              child: const Text(
                "Save Pattern",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitPattern() async {
    if (_patternNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a pattern name')),
      );
      return;
    }
    if (_patternIntervalController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a pattern interval')),
      );
      return;
    }
    try {
      final apiService = ApiService();
      Map<String, dynamic> result = await apiService.createPattern(
        _username,
        _patternNameController.text,
        widget.leftColors,
        widget.rightColors,
        _iconColor,
        int.parse(_patternIntervalController.text),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar(content: Text('Pattern Saved: ${result['message']}')),
        SnackBar(content: Text('Pattern Saved')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting pattern: $e')),
      );
    }
  }
}
