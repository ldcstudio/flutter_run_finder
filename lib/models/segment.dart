class Segment {
  final String name;
  final double distance;
  final double elevation;
  final String polyline;
  int index = 0;
  bool _isSelected = false;

  Segment({
    required this.name,
    required this.distance,
    required this.elevation,
    required this.polyline,
  });

  factory Segment.fromJson(Map<String, dynamic> json) {
    return Segment(
      name: json["name"],
      distance: json["distance"] as double,
      elevation: json["elev_difference"] as double,
      polyline: json["points"],
    );
  }

  bool get isSelected => _isSelected;

  void toggleSegment() => _isSelected = !_isSelected;
}
