import 'package:flutter/material.dart';
import 'package:flutter_run_finder/controllers/course_maps.dart';
import 'package:flutter_run_finder/controllers/segment_maps.dart';
import 'package:flutter_run_finder/utils/colors.dart';
import 'package:provider/provider.dart';

class MapActionButtons extends StatelessWidget {
  const MapActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    final courseMaps = context.watch<CourseMaps>();
    final segmentMaps = context.watch<SegmentMaps>();

    return Column(
      children: [
        ElevatedCircleButton(
            icon: Icons.filter_center_focus,
            onTap: () => {segmentMaps.toggleCenterSegmentMap()}),
        SizedBox(height: 12.0),
        ElevatedCircleButton(
          icon: Icons.control_point,
          selected: segmentMaps.additionalPointsRequested,
          color: Colors.orangeAccent,
          onTap: () => segmentMaps.toggleAdditionalPointsRequested(),
          onLongPress: () {
            segmentMaps.clearWaypoints();
          },
        ),
        SizedBox(height: 12.0),
        ElevatedCircleButton(
          icon: Icons.search,
          onTap: () => {segmentMaps.toggleAdditionalSegmentsRequested()},
        ),
        SizedBox(height: 12.0),
        segmentMaps.selectedSegments.isNotEmpty
            ? ElevatedCircleButton(
                icon:
                    segmentMaps.courseMapRequested ? Icons.close : Icons.check,
                selected: true,
                color: segmentMaps.courseMapRequested
                    ? kTertiaryColor
                    : Colors.greenAccent,
                onTap: () {
                  if (segmentMaps.courseMapRequested) {
                    courseMaps.setCourseMapGenerated = false;
                  }
                  segmentMaps.toggleCourseMapRequested();
                },
              )
            : SizedBox.shrink(),
      ],
    );
  }
}

class ElevatedCircleButton extends StatelessWidget {
  final IconData icon;
  final Function() onTap;
  final bool selected;
  final Function()? onLongPress;
  final Color color;

  const ElevatedCircleButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.selected = false,
    this.onLongPress,
    this.color = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(8.0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        backgroundColor: selected ? color : Colors.white,
      ),
      onPressed: onTap,
      onLongPress: onLongPress ?? () {},
      child: Icon(
        icon,
        size: 24.0,
        color: Colors.black,
      ),
    );
  }
}
