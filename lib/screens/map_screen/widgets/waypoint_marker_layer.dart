import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_run_finder/controllers/segment_maps.dart';
import 'package:flutter_run_finder/models/segment_map.dart';
import 'package:provider/provider.dart';

class WaypointMarkerLayer extends StatelessWidget {
  const WaypointMarkerLayer({super.key});

  List<Marker> waypointMarkers(SegmentMap? segmentMap) {
    return segmentMap!.waypoints.map((waypoint) {
      return Marker(
          width: 32.0,
          height: 32.0,
          point: waypoint,
          child: Icon(
            Icons.location_on_sharp,
            color: Colors.orangeAccent,
          ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final segmentMaps = context.watch<SegmentMaps>();

    return MarkerLayer(markers: waypointMarkers(segmentMaps.segmentMap));
  }
}
