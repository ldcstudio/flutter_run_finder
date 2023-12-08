import 'package:latlong2/latlong.dart';

LatLng getCenterPolylinePoint(List<LatLng> polylinePoints) {
  final int centerPoint = (polylinePoints.length / 2).round();
  return polylinePoints.elementAt(centerPoint);
}

List<LatLng> getPolylineCoords(
  List<String> polylines,
  List<LatLng> additionalWaypoints,
) {
  const int maxNumWaypoints = 20;
  List<LatLng> polylineCoords = [];
  List<LatLng> subsetPolylineCoords = [];

  for (String points in polylines) {
    polylineCoords.addAll(decodePolyline(points));
  }

  final numWayPoints = polylineCoords.length + additionalWaypoints.length;
  final stepSize = (numWayPoints / maxNumWaypoints).ceil();

  for (int i = 0; i < polylineCoords.length; i += stepSize) {
    subsetPolylineCoords.add(polylineCoords[i]);
  }

  if (additionalWaypoints.isNotEmpty) {
    subsetPolylineCoords.addAll(additionalWaypoints);
  }

  return subsetPolylineCoords;
}

List<LatLng> decodePolyline(String encodedPolyline) {
  final int encodedPolylineLength = encodedPolyline.length;
  int index = 0, lat = 0, lng = 0;
  List<LatLng> polylinePoints = [];

  while (index < encodedPolylineLength) {
    int curBit = 0, shiftBit = 0, result = 0;

    // Decode polyline latitude
    do {
      curBit = encodedPolyline.codeUnitAt(index++) - 63;
      result |= (curBit & 0x1f) << shiftBit;
      shiftBit += 5;
    } while (curBit >= 0x20);

    int dlat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lat += dlat;

    // Decode polyline longitude
    shiftBit = 0;
    result = 0;

    do {
      curBit = encodedPolyline.codeUnitAt(index++) - 63;
      result |= (curBit & 0x1f) << shiftBit;
      shiftBit += 5;
    } while (curBit >= 0x20);

    int dlng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
    lng += dlng;

    // Populate polyline points array
    LatLng point = LatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble());
    polylinePoints.add(point);
  }
  return polylinePoints;
}
