import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_run_finder/controllers/course_maps.dart';
import 'package:flutter_run_finder/utils/colors.dart';
import 'package:provider/provider.dart';

class CourseMapPolylineLayer extends StatelessWidget {
  const CourseMapPolylineLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final courseMaps = context.watch<CourseMaps>();
    return PolylineLayer(polylines: [
      Polyline(
        strokeWidth: 2.0,
        color: kPrimaryColor,
        points: courseMaps.courseMap!.waypoints,
      )
    ]);
  }
}
