import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_run_finder/controllers/segment_maps.dart';
import 'package:flutter_run_finder/models/segment_map.dart';
import 'package:flutter_run_finder/utils/colors.dart';
import 'package:flutter_run_finder/utils/polyline_helper.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class FlutterMapPolylineLayer extends StatelessWidget {
  const FlutterMapPolylineLayer({super.key});

  List<Polyline> segmentPolylines(SegmentMap? segmentMap) {
    return segmentMap!.segments.map((segment) {
      final bool isSegmentSelected = segment.isSelected;
      final List<LatLng> polylinePoints = decodePolyline(segment.polyline);

      return Polyline(
        points: polylinePoints,
        isDotted: isSegmentSelected ? false : true,
        color: kPrimaryColor,
        strokeWidth: isSegmentSelected ? 4.0 : 1.0,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final segmentMaps = context.watch<SegmentMaps>();

    return PolylineLayer(polylines: segmentPolylines(segmentMaps.segmentMap));
  }
}
