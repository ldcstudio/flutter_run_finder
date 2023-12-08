import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_run_finder/controllers/segments.dart';
import 'package:flutter_run_finder/screens/home_screen/widgets/segment_card_list.dart';
import 'package:flutter_run_finder/utils/colors.dart';
import 'package:flutter_run_finder/utils/polyline_helper.dart';
import 'package:flutter_run_finder/utils/styles.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class FlutterMapMarkerLayer extends StatelessWidget {
  final scrollableItemController = ScrollableList.itemController;

  FlutterMapMarkerLayer({super.key});

  Widget segmentMarker(Segments segments, int index) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(4.0),
        backgroundColor: kPrimaryColor,
      ),
      onPressed: () {
        final selectedSegmentIndex = index - 1;
        if (!segments.segments[selectedSegmentIndex].isSelected) {
          scrollableItemController.scrollTo(
            index: selectedSegmentIndex,
            duration: Duration(milliseconds: 500),
          );
        }
        segments.toggleSegment = selectedSegmentIndex;
      },
      child: Text(
        (index).toString(),
        style: kTitleMedium.copyWith(color: Colors.black),
      ),
    );
  }

  List<Marker> segmentMarkers(Segments segments) {
    return segments.segments.map((segment) {
      final bool isSegmentSelected = segment.isSelected;
      final List<LatLng> polylinePoints = decodePolyline(segment.polyline);
      final LatLng centerPolylinePoint = getCenterPolylinePoint(polylinePoints);

      return Marker(
          width: 32.0,
          height: 32.0,
          point: centerPolylinePoint,
          child: isSegmentSelected
              ? Opacity(
                  opacity: 1.0,
                  child: segmentMarker(segments, segment.index),
                )
              : Opacity(
                  opacity: 0.9,
                  child: segmentMarker(segments, segment.index),
                ));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final segments = context.watch<Segments>();

    return MarkerLayer(
      markers: segmentMarkers(segments),
    );
  }
}
