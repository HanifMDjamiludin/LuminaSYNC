import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/src/api_service.dart';

class PatternManagerPage extends StatefulWidget {
  final String userId;

  const PatternManagerPage({Key? key, required this.userId}) : super(key: key);

  @override
  _PatternManagerPageState createState() => _PatternManagerPageState();
}

class _PatternManagerPageState extends State<PatternManagerPage> {
  late Future<List<dynamic>> _patterns;

  @override
  void initState() {
    super.initState();
    _loadPatterns();
  }

  Future<void> _loadPatterns() async {
    setState(() {
      _patterns = ApiService().getPatterns(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pattern Manager'),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _patterns,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  var pattern = snapshot.data![index];
                  return ListTile(
                    title: Text(pattern['patternname']),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => confirmDelete(pattern['patternid'].toString()),
                    ),
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  void confirmDelete(String patternId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this pattern?'),
          actions: <Widget>[
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                try {
                  await ApiService().deletePattern(widget.userId, patternId);
                  _loadPatterns(); // Reload patterns
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete pattern: $e'))
                  );
                }
              },
            ),
            TextButton(
              child: Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}
