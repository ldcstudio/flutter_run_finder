import 'package:flutter_run_finder/models/segment.dart';
import 'package:latlong2/latlong.dart';

class SegmentMap {
  String? area;
  List<Segment> segments;
  List<LatLng> waypoints = [];

  SegmentMap(this.segments);

  factory SegmentMap.fromJson(Map<String, dynamic> json) {
    final List<dynamic> segmentData = json["segments"] as List;
    final List<Segment> segments =
        segmentData.map((segment) => Segment.fromJson(segment)).toList();
    return SegmentMap(segments);
  }
}
