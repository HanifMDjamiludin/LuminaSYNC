import 'package:flutter/material.dart';
import 'package:luminasyncflutter/src/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmitPatternPage extends StatefulWidget {
  final List<Color> leftColors;
  final List<Color> rightColors;

  SubmitPatternPage({Key? key, required this.leftColors, required this.rightColors}) : super(key: key);

  @override
  _SubmitPatternPageState createState() => _SubmitPatternPageState();
}

class _SubmitPatternPageState extends State<SubmitPatternPage> {
  String _username = '';
  final _patternNameController = TextEditingController();

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
      body: Padding(
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
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _submitPattern,
              child: Text('Save Pattern'),
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
    try {
      final apiService = ApiService();
      String result = await apiService.createPattern(
        _username,
        _patternNameController.text,
        widget.leftColors,
        widget.rightColors,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error submitting pattern: $e')),
      );
    }
  }
}
