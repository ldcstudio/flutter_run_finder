import 'package:flutter/material.dart';
import 'package:flutter_run_finder/controllers/course_maps.dart';
import 'package:flutter_run_finder/controllers/segment_maps.dart';
import 'package:flutter_run_finder/screens/home_screen/widgets/garmin_download_button.dart';
import 'package:flutter_run_finder/screens/home_screen/widgets/segment_card_list.dart';
import 'package:flutter_run_finder/screens/map_screen/map.dart';
import 'package:flutter_run_finder/screens/home_screen/widgets/search_bar.dart'
    as run_finder;
import 'package:flutter_run_finder/screens/home_screen/widgets/run_details.dart';
import 'package:flutter_run_finder/screens/home_screen/widgets/map_action_buttons.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final courseMaps = context.watch<CourseMaps>();
    final segmentMaps = context.watch<SegmentMaps>();

    return Stack(
      children: [
        Map(),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            run_finder.SearchBar(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (segmentMaps.selectedSegments.isNotEmpty)
                    ? RunDetails()
                    : SizedBox.shrink(),
                MapActionButtons(),
              ],
            ),
          ],
        ),
        !segmentMaps.courseMapRequested
            ? Align(
                alignment: Alignment.bottomLeft,
                child: SegmentCardList(),
              )
            : SizedBox.shrink(),
        courseMaps.courseMapGenerated
            ? Align(
                alignment: Alignment.bottomCenter,
                child: GarminDownloadButton(),
              )
            : SizedBox.shrink()
      ],
    );
  }
}
