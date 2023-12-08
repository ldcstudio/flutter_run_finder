import 'package:flutter/material.dart';
import 'package:flutter_run_finder/controllers/course_maps.dart';
import 'package:flutter_run_finder/controllers/segment_maps.dart';
import 'package:flutter_run_finder/controllers/segments.dart';
import 'package:flutter_run_finder/screens/home_screen/home_screen.dart';
import 'package:flutter_run_finder/models/segment_map.dart';
import 'package:provider/provider.dart';

Future main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CourseMaps()),
        ChangeNotifierProvider(create: (_) => Segments()),
        ChangeNotifierProxyProvider<Segments, SegmentMaps>(
          create: (context) => SegmentMaps(SegmentMap([]))
            ..setSegmentMap = context.read<Segments>().segments,
          update: (_, segments, segmentMaps) =>
              segmentMaps!..setSegmentMap = segments.segments,
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Run Finder',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: Material(
          child: SafeArea(
            child: HomeScreen(),
          ),
        ),
      ),
    );
  }
}
