import 'package:latlong2/latlong.dart';

/// Google Directions API
/// https://developers.google.com/maps/documentation/directions/get-directions#ExampleRequests

class Direction {
  final String status;
  final List<DirectionRoutes> routes;
  final String? errorMessage;

  Direction({
    required this.status,
    required this.routes,
    this.errorMessage = '',
  });

  factory Direction.fromJson(Map<String, dynamic> json) {
    final List<dynamic> routes = json["routes"] as List;
    final List<DirectionRoutes> directionRoutes =
        routes.map((route) => DirectionRoutes.fromJson(route)).toList();

    return Direction(
      status: json["status"],
      routes: directionRoutes,
      errorMessage: json["error_message"],
    );
  }
}

class DirectionRoutes {
  final DirectionBounds bounds;
  final List<DirectionLegs> legs;
  final String points;

  DirectionRoutes({
    required this.bounds,
    required this.legs,
    required this.points,
  });

  factory DirectionRoutes.fromJson(Map<String, dynamic> json) {
    final DirectionBounds directionBounds =
        DirectionBounds.fromJson(json["bounds"]);
    final List<dynamic> legs = json["legs"] as List;
    final List<DirectionLegs> directionLegs =
        legs.map((jsonLeg) => DirectionLegs.fromJson(jsonLeg)).toList();

    return DirectionRoutes(
      bounds: directionBounds,
      legs: directionLegs,
      points: json["overview_polyline"]["points"],
    );
  }
}

class DirectionBounds {
  final LatLng northEast;
  final LatLng southWest;

  DirectionBounds({required this.northEast, required this.southWest});

  factory DirectionBounds.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> northEastBounds = json["northeast"];
    final Map<String, dynamic> southWestBounds = json["southwest"];

    return DirectionBounds(
      northEast: LatLng(
        northEastBounds["lat"],
        northEastBounds["lng"],
      ),
      southWest: LatLng(
        southWestBounds["lat"],
        southWestBounds["lng"],
      ),
    );
  }
}

class DirectionLegs {
  final List<DirectionSteps> steps;
  final LatLng startLocation;
  final LatLng endLocation;
  final String startAddress;
  final String endAddress;
  final num distance;
  final num duration;

  DirectionLegs({
    required this.steps,
    required this.startLocation,
    required this.endLocation,
    required this.startAddress,
    required this.endAddress,
    required this.distance,
    required this.duration,
  });

  factory DirectionLegs.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> legStartLocation = json["start_location"];
    final Map<String, dynamic> legEndLocation = json["end_location"];
    final List<dynamic> steps = json["steps"] as List;
    final List<DirectionSteps> directionSteps =
        steps.map((step) => DirectionSteps.fromJson(step)).toList();

    return DirectionLegs(
      steps: directionSteps,
      startLocation: LatLng(
        legStartLocation["lat"],
        legStartLocation["lng"],
      ),
      endLocation: LatLng(
        legEndLocation["lat"],
        legEndLocation["lng"],
      ),
      startAddress: json["start_address"],
      endAddress: json["end_address"],
      distance: json["distance"]["value"],
      duration: json["duration"]["value"],
    );
  }
}

class DirectionSteps {
  final LatLng startLocation;
  final LatLng endLocation;
  final num distance;
  final num duration;
  final String polyLine;

  DirectionSteps({
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.duration,
    required this.polyLine,
  });

  factory DirectionSteps.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> stepStartLocation = json["start_location"];
    final Map<String, dynamic> stepEndLocation = json["end_location"];

    return DirectionSteps(
      startLocation: LatLng(
        stepStartLocation["lat"],
        stepStartLocation["lng"],
      ),
      endLocation: LatLng(
        stepEndLocation["lat"],
        stepEndLocation["lng"],
      ),
      distance: json["distance"]["value"],
      duration: json["duration"]["value"],
      polyLine: json["polyline"]["points"],
    );
  }
}
