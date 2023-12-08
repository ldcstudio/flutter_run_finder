import 'package:flutter_run_finder/models/direction.dart';
import 'package:flutter_run_finder/services/network.dart';
import 'package:flutter_run_finder/utils/constants.dart';
import 'package:flutter_run_finder/env/env.dart';
import 'package:latlong2/latlong.dart';

class DirectionsAPI {
  Future<Direction> getRouteBetweenCoordinates({
    LatLng? origin,
    LatLng? destination,
    String travelMode = 'walking',
    List<String>? polylineWayPoints,
    List<LatLng>? waypoints,
    bool hasPolylineWaypoints = false,
    bool avoidHighways = true,
    bool avoidTolls = true,
    bool avoidFerries = true,
    bool optimizeWaypoints = true,
  }) async {
    final params = {
      "origin": "${origin!.latitude},${origin.longitude}",
      "destination": "${destination!.latitude},${destination.longitude}",
      "mode": travelMode,
      "avoidHighways": "$avoidHighways",
      "avoidFerries": "$avoidFerries",
      "avoidTolls": "$avoidTolls",
      "key": Env.googleAPIKey,
    };

    if (hasPolylineWaypoints) {
      List<String> wayPointsArray = [];
      polylineWayPoints?.forEach((polyline) => wayPointsArray.add(polyline));
      String wayPointsString = "enc:${wayPointsArray.join(':|enc:')}:";
      if (optimizeWaypoints) {
        wayPointsString = 'optimize:true|$wayPointsString';
      }
      params.addAll({"waypoints": wayPointsString});
    } else {
      String wayPointString = "";
      for (int i = 0; i < waypoints!.length; i++) {
        wayPointString += "${waypoints[i].latitude},${waypoints[i].longitude}";
        if (i < waypoints.length - 1) wayPointString += "|";
      }
      params.addAll({"waypoints": wayPointString});
    }

    final Map<String, dynamic> directionData = await Network(
      baseUrl: APIEndpoints.googleBaseUrl,
      endpoint: APIEndpoints.directionPath,
      queryParameters: params,
    ).getJsonResponse();

    return Direction.fromJson(directionData);
  }
}
