import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_run_finder/controllers/segment_maps.dart';
import 'package:flutter_run_finder/utils/colors.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final segmentMaps = context.watch<SegmentMaps>();
    final segmentMapArea = segmentMaps.segmentMap.area;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      height: 48.0,
      decoration: const BoxDecoration(
        color: kOnSurfaceColor,
        borderRadius: BorderRadius.all(
          Radius.circular(24.0),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_outlined),
          const SizedBox(width: 8.0),
          Expanded(
            child: segmentMapArea != null ? Text(segmentMapArea) : Text(''),
          ),
        ],
      ),
    );
  }
}
