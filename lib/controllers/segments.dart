import 'package:flutter/cupertino.dart';
import 'package:flutter_run_finder/models/segment.dart';
import 'package:flutter_run_finder/models/latlngbounds.dart';
import 'package:flutter_run_finder/services/strava_api.dart';

enum Difficulty { easy, medium, tough, extreme }

class Segments extends ChangeNotifier {
  List<Segment> segments = [];
  int segmentIndex = 1;

  int get numSegments => segments.length;

  Difficulty? evaluateDifficulty(Segment segment) {
    final distance = segment.distance;
    final elevation = segment.elevation;
    final ratio = 1000 / (distance / elevation);

    if (ratio <= 10) {
      return Difficulty.easy;
    } else if (ratio > 10 && ratio <= 25) {
      return Difficulty.medium;
    } else if (ratio > 25 && ratio <= 50) {
      return Difficulty.tough;
    } else if (ratio > 50) {
      return Difficulty.extreme;
    } else {
      return null;
    }
  }

  Future<void> getStravaSegments(LatLngBounds? latLngBounds) async {
    if (latLngBounds != null) {
      final stravaSegments = await StravaAPI().exploreSegments(
        lwrBounds: latLngBounds.southWest,
        uppBounds: latLngBounds.northEast,
      );
      for (Segment segment in stravaSegments) {
        segment.index = segmentIndex;
        addSegment = segment;
      }
    }
  }

  set addSegment(Segment segment) {
    if (!segments.any((e) => e.name == segment.name)) {
      segments.add(segment);
      segmentIndex++;
      notifyListeners();
    }
  }

  set deleteSegment(Segment segment) {
    segments.remove(segment);
  }

  set toggleSegment(int index) {
    segments[index].toggleSegment();
    notifyListeners();
  }
}
