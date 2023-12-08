import 'package:flutter/material.dart';
import 'package:flutter_run_finder/controllers/course_maps.dart';
import 'package:flutter_run_finder/controllers/segment_maps.dart';
import 'package:flutter_run_finder/controllers/segments.dart';
import 'package:flutter_run_finder/screens/map_screen/widgets/course_map_polyline_layer.dart';
import 'package:flutter_run_finder/screens/map_screen/widgets/flutter_map_marker_layer.dart';
import 'package:flutter_run_finder/screens/map_screen/widgets/flutter_map_polyline_layer.dart';
import 'package:flutter_run_finder/screens/map_screen/widgets/waypoint_marker_layer.dart';
import 'package:flutter_run_finder/services/oauth.dart';
import 'package:flutter_run_finder/utils/colors.dart';
import 'package:flutter_run_finder/utils/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_run_finder/services/user_location.dart';
import 'package:flutter_run_finder/env/env.dart';
import 'package:provider/provider.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

const mapZoom = 15.0;

class Map extends StatefulWidget {
  const Map({super.key});

  @override
  State<Map> createState() => _MapState();
}

class _MapState extends State<Map> {
  late Future<Position> position;
  final MapController mapController = MapController();
  final String monochromeMap =
      '${APIEndpoints.mapboxBaseUrl}${APIEndpoints.monochromeStylePath}access_token=${Env.mapAPIKey}';

  @override
  void initState() {
    super.initState();
    OAuth().authenticateStravaUserFromSP();
    position = userLocation();
  }

  Marker centerPointMarker(LatLng centerPoint) {
    return Marker(
      point: centerPoint,
      width: 32.0,
      height: 32.0,
      child: Icon(
        Icons.my_location,
        color: Colors.blue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final courseMaps = context.watch<CourseMaps>();
    final segmentMaps = context.watch<SegmentMaps>();
    final segments = context.watch<Segments>();

    void updateSegmentMapVisibleBounds() {
      final visibleBounds = mapController.camera.visibleBounds;
      segmentMaps.updateVisibleBounds(
        visibleBounds.southWest,
        visibleBounds.northEast,
      );
    }

    return FutureBuilder(
        future: position,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final LatLng centerPoint = LatLng(
              snapshot.requireData.latitude,
              snapshot.requireData.longitude,
            );

            if (segmentMaps.segments.isEmpty) {
              segmentMaps.getGeocodeData(centerPoint);
            }

            if (segmentMaps.segmentMap.segments.isEmpty ||
                segmentMaps.additionalSegmentsRequested) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                updateSegmentMapVisibleBounds();
                segments.getStravaSegments(segmentMaps.visibleBounds);
                if (segmentMaps.additionalSegmentsRequested) {
                  segmentMaps.toggleAdditionalSegmentsRequested();
                }
              });
            }

            if (segmentMaps.centerSegmentMap) {
              WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
                mapController.move(centerPoint, mapZoom);
                segmentMaps.toggleCenterSegmentMap();
              });
            }

            if (segmentMaps.courseMapRequested &&
                !courseMaps.courseMapGenerated) {
              courseMaps.getCourseMap(
                segmentMaps.segmentPolylines,
                centerPoint,
                segmentMaps.segmentMap.waypoints,
                segmentMaps.elevation,
              );
            }

            return FlutterMap(
              mapController: mapController,
              options: MapOptions(
                  initialCenter: centerPoint,
                  initialZoom: mapZoom,
                  interactionOptions: InteractionOptions(
                    flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                  ),
                  onTap: (_, waypoint) {
                    if (segmentMaps.additionalPointsRequested &&
                        !courseMaps.courseMapGenerated) {
                      segmentMaps.addWaypoint = waypoint;
                    }
                  }),
              children: [
                TileLayer(
                  urlTemplate: monochromeMap,
                ),
                MarkerLayer(markers: [centerPointMarker(centerPoint)]),
                (segmentMaps.hasAdditionalWaypoints &&
                        !courseMaps.courseMapGenerated)
                    ? WaypointMarkerLayer()
                    : SizedBox.shrink(),
                (segmentMaps.segmentMap.segments.isNotEmpty &&
                        !courseMaps.courseMapGenerated)
                    ? FlutterMapPolylineLayer()
                    : SizedBox.shrink(),
                (segmentMaps.segmentMap.segments.isNotEmpty &&
                        !courseMaps.courseMapGenerated)
                    ? FlutterMapMarkerLayer()
                    : SizedBox.shrink(),
                (courseMaps.courseMap != null && courseMaps.courseMapGenerated)
                    ? CourseMapPolylineLayer()
                    : SizedBox.shrink(),
                (segmentMaps.courseMapRequested &&
                        !courseMaps.courseMapGenerated)
                    ? Center(
                        child: CircularProgressIndicator(
                          color: kTertiaryColor,
                          strokeWidth: 8.0,
                          strokeCap: StrokeCap.round,
                        ),
                      )
                    : SizedBox.shrink(),
              ],
            );
          } else {
            return Center(
              child: CircularProgressIndicator(
                color: kTertiaryColor,
                strokeWidth: 8.0,
                strokeCap: StrokeCap.round,
              ),
            );
          }
        });
  }
}
