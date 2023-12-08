import 'package:flutter/material.dart';
import 'package:flutter_run_finder/controllers/segment_maps.dart';
import 'package:flutter_run_finder/screens/home_screen/widgets/segment_card.dart';
import 'package:provider/provider.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ScrollableList {
  static final itemController = ItemScrollController();
}

class SegmentCardList extends StatelessWidget {
  final scrollableItemController = ScrollableList.itemController;

  SegmentCardList({super.key});

  @override
  Widget build(BuildContext context) {
    final segmentMaps = context.watch<SegmentMaps>();

    return SizedBox(
      height: 116,
      child: ScrollablePositionedList.builder(
          itemCount: segmentMaps.segmentMap.segments.length,
          itemScrollController: scrollableItemController,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            final curSegment = segmentMaps.segmentMap.segments[index];
            return SegmentCard(curSegment);
          }),
    );
  }
}
