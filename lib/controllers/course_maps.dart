import 'package:flutter/foundation.dart';
import 'package:flutter_run_finder/models/course_map.dart';
import 'package:flutter_run_finder/models/direction.dart';
import 'package:flutter_run_finder/services/directions_api.dart';
import 'package:flutter_run_finder/utils/polyline_helper.dart';
import 'package:latlong2/latlong.dart';

class CourseMaps extends ChangeNotifier {
  CourseMap? _courseMap;
  bool _courseMapGenerated = false;

  CourseMap? get courseMap => _courseMap;

  bool get courseMapGenerated => _courseMapGenerated;

  double distance(List<DirectionLegs> legs) {
    double distance = 0;
    for (DirectionLegs leg in legs) {
      distance += leg.distance;
    }
    return distance;
  }

  Future<void> getCourseMap(
    List<String> segmentPolylines,
    LatLng centerPoint,
    List<LatLng> waypoints,
    double elevation,
  ) async {
    final Direction directions =
        await DirectionsAPI().getRouteBetweenCoordinates(
      waypoints: getPolylineCoords(segmentPolylines, waypoints),
      origin: centerPoint,
      destination: centerPoint,
    );
    final selectedRoute = directions.routes[0];
    final courseMap = CourseMap(
      polyline: selectedRoute.points,
      distance: distance(selectedRoute.legs),
      elevation: elevation,
    );
    setCourseMap = courseMap;
  }

  set setCourseMap(CourseMap? courseMap) {
    _courseMap = courseMap;
    setCourseMapGenerated = true;
    notifyListeners();
  }

  set setCourseMapGenerated(bool status) {
    _courseMapGenerated = status;
    notifyListeners();
  }
}
