import 'package:flutter/material.dart';
import 'package:flutter_run_finder/controllers/course_maps.dart';
import 'package:flutter_run_finder/controllers/segment_maps.dart';
import 'package:flutter_run_finder/utils/colors.dart';
import 'package:flutter_run_finder/utils/styles.dart';
import 'package:flutter_run_finder/utils/helper.dart';
import 'package:provider/provider.dart';

class RunDetails extends StatelessWidget {
  RunDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final courseMaps = context.watch<CourseMaps>();
    final segmentMaps = context.watch<SegmentMaps>();
    final distance = courseMaps.courseMapGenerated
        ? courseMaps.courseMap!.distance
        : segmentMaps.distance;

    return Container(
      width: 125.0,
      margin: EdgeInsets.only(left: 16.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Distance',
                style: kBodySmall.copyWith(color: kOnSurfaceVariant),
              ),
              Text(
                distanceToString(distance),
                style: kBodyMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
          SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Elevation',
                style: kBodySmall.copyWith(color: kOnSurfaceVariant),
              ),
              Text(
                distanceToString(segmentMaps.elevation),
                style: kBodyMedium.copyWith(color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
