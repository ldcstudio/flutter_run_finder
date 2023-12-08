import 'package:flutter/material.dart';
import 'package:flutter_run_finder/controllers/segments.dart';
import 'package:flutter_run_finder/utils/helper.dart';
import 'package:flutter_run_finder/models/segment.dart';
import 'package:flutter_run_finder/utils/colors.dart';
import 'package:flutter_run_finder/utils/styles.dart';
import 'package:provider/provider.dart';

class SegmentCard extends StatelessWidget {
  final Segment segment;

  const SegmentCard(this.segment, {super.key});

  @override
  Widget build(BuildContext context) {
    const double cardWidth = 273;
    const double cardHeight = 100;
    final segments = context.read<Segments>();

    return GestureDetector(
      onTap: () {
        segments.toggleSegment = segment.index - 1;
      },
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: cardWidth,
            height: cardHeight,
            margin: EdgeInsets.only(left: 16.0, bottom: 32.0),
            padding:
                EdgeInsets.only(left: 12.0, top: 8.0, right: 8.0, bottom: 8.0),
            decoration: BoxDecoration(
              color: segment.isSelected ? kPrimaryColor : Colors.white,
              borderRadius: BorderRadius.circular(16.0),
              boxShadow: [
                BoxShadow(offset: Offset(-1, 1), blurRadius: 2.0),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox.fromSize(
                      size: Size(163.0, 48.0),
                      child: Text(
                        segment.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: kTitleMedium,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('Distance', style: kLabelSmall),
                        SizedBox(width: 4.0),
                        Text('${distanceToString(segment.distance)}m'),
                      ],
                    )
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Badge(
                      icon: Icons.directions_run,
                      isSelected: segment.isSelected,
                      name: segments
                          .evaluateDifficulty(segment)!
                          .name
                          .toString()
                          .capitalize(),
                    ),
                  ],
                )
              ],
            ),
          ),
          segment.isSelected
              ? Positioned(
                  left: 273.0 / 2,
                  top: 84.0 - 16.0,
                  child: Container(
                    width: 32.0,
                    height: 32.0,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        color: kOnPrimaryColor,
                        boxShadow: [
                          BoxShadow(offset: Offset(-1, 1), blurRadius: 1.0)
                        ]),
                    child: Text(
                      segment.index.toString(),
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}

class Badge extends StatelessWidget {
  final String name;
  final IconData icon;
  final bool isSelected;

  const Badge({
    required this.name,
    required this.icon,
    this.isSelected = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: isSelected ? kOnPrimaryColor : kPrimaryColor,
        borderRadius: BorderRadius.circular(26.0),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16.0,
            color: isSelected ? Colors.white : Colors.black,
          ),
          SizedBox(width: 6.0),
          Text(
            name,
            style: kBodySmall.copyWith(
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}
