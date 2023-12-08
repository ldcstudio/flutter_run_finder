import 'package:flutter/material.dart';
import 'package:flutter_run_finder/models/latlngbounds.dart';
import 'package:flutter_run_finder/models/segment.dart';
import 'package:flutter_run_finder/models/segment_map.dart';
import 'package:flutter_run_finder/services/geocode_api.dart';
import 'package:latlong2/latlong.dart';

class SegmentMaps extends ChangeNotifier {
  final SegmentMap segmentMap;
  bool centerSegmentMap = false;
  bool courseMapRequested = false;
  bool additionalSegmentsRequested = false;
  bool additionalPointsRequested = false;
  LatLngBounds? visibleBounds;

  SegmentMaps(this.segmentMap);

  bool get hasAdditionalWaypoints =>
      segmentMap.waypoints.isNotEmpty ? true : false;

  List<Segment> get segments => segmentMap.segments;

  List<Segment> get selectedSegments {
    List<Segment> selectedSegments = [];
    for (Segment segment in segmentMap.segments) {
      if (segment.isSelected) selectedSegments.add(segment);
    }
    return selectedSegments;
  }

  List<String> get segmentPolylines {
    List<String> polylines = [];
    for (Segment segment in selectedSegments) {
      polylines.add(segment.polyline);
    }
    return polylines;
  }

  double get distance {
    List<Segment> selectedSegments = this.selectedSegments;
    double totalDistance = 0;
    for (var segment in selectedSegments) {
      totalDistance += segment.distance;
    }
    return totalDistance;
  }

  double get elevation {
    List<Segment> selectedSegments = this.selectedSegments;
    double totalElevation = 0;
    for (var segment in selectedSegments) {
      totalElevation += segment.elevation;
    }
    return totalElevation;
  }

  Future<void> getGeocodeData(LatLng centerPoint) async {
    final geocode = await GeocodeAPI().getGeocodeDetail(location: centerPoint);
    setArea = geocode.results[0].name;
  }

  set setSegmentMap(List<Segment> segments) {
    segmentMap.segments = segments;
    notifyListeners();
  }

  set setArea(String name) {
    segmentMap.area = name;
  }

  set addWaypoint(LatLng waypoint) {
    if (segmentMap.waypoints.length < 5) {
      segmentMap.waypoints.add(waypoint);
      notifyListeners();
    }
  }

  void updateVisibleBounds(LatLng southWestPoint, LatLng northEastPoint) {
    visibleBounds = LatLngBounds(southWestPoint, northEastPoint);
  }

  void clearWaypoints() {
    segmentMap.waypoints.clear();
    notifyListeners();
  }

  void toggleCenterSegmentMap() {
    centerSegmentMap = !centerSegmentMap;
    notifyListeners();
  }

  void toggleCourseMapRequested() {
    courseMapRequested = !courseMapRequested;
    notifyListeners();
  }

  void toggleAdditionalSegmentsRequested() {
    additionalSegmentsRequested = !additionalSegmentsRequested;
    notifyListeners();
  }

  void toggleAdditionalPointsRequested() {
    additionalPointsRequested = !additionalPointsRequested;
    notifyListeners();
  }
}
