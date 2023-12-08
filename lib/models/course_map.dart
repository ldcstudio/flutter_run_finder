import 'package:flutter_run_finder/utils/polyline_helper.dart';
import 'package:latlong2/latlong.dart';

class CourseMap {
  final String polyline;
  final double distance;
  final double elevation;
  List<LatLng> waypoints = [];

  CourseMap({
    required this.polyline,
    required this.distance,
    required this.elevation,
  }) {
    waypoints = decodePolyline(polyline);
  }
}
