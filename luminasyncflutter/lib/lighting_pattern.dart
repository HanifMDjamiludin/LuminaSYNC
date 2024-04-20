/*
    * This file contains the LightingPattern class which is used to represent an individual lighting pattern.
*/
class LightingPattern {
  final String title;
  final int color;

  LightingPattern({required this.title, required this.color});

  factory LightingPattern.fromJson(Map<String, dynamic> json) {
    final parsedColor = int.parse(json['color'].substring(2), radix: 16) + 0xFF000000; // Parse hex color and add alpha value
    return LightingPattern(
      title: json['title'],
      color: parsedColor,
    );
  }
}

