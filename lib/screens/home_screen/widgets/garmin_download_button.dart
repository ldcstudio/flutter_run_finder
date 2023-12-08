import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_run_finder/controllers/course_maps.dart';
import 'package:flutter_run_finder/utils/colors.dart';
import 'package:flutter_run_finder/utils/styles.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:gpx/gpx.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class GarminDownloadButton extends StatefulWidget {
  const GarminDownloadButton({super.key});

  @override
  State<GarminDownloadButton> createState() => _GarminDownloadButtonState();
}

class _GarminDownloadButtonState extends State<GarminDownloadButton> {
  final TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      final String text = controller.text;
      controller.value = controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> convertWptsToGpx(
      {required List<LatLng> waypoints, required String filename}) async {
    final directory = await getExternalStorageDirectory();
    final file = File('${directory!.path}/$filename');
    final gpxFile = Gpx();
    gpxFile.creator = "au.com.ldcstudio.run.finder";
    gpxFile.rtes = [
      Rte(
          rtepts: waypoints
              .map((waypoint) => Wpt(
                    lat: waypoint.latitude,
                    lon: waypoint.longitude,
                  ))
              .toList())
    ];
    String gpxString = GpxWriter().asString(gpxFile, pretty: true);
    file.writeAsString(gpxString);
    await OpenFilex.open(file.path);
  }

  @override
  Widget build(BuildContext context) {
    final courseMaps = context.watch<CourseMaps>();

    Future<void> showMyDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              'Course Map Title',
              style: kTitleLarge.copyWith(color: kBackgroundColor),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  TextFormField(
                    controller: controller,
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(8.0),
          backgroundColor: kPrimaryColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        onPressed: () async {
          await showMyDialog().whenComplete(() => convertWptsToGpx(
                waypoints: courseMaps.courseMap!.waypoints,
                filename: controller.text,
              ));
        },
        child: SizedBox.fromSize(
          size: Size(double.infinity, 32.0),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.download_rounded,
                  size: 24.0,
                  color: kBackgroundColor,
                ),
                SizedBox(height: 32.0),
                Text(
                  'Garmin Export',
                  style: kTitleLarge.copyWith(color: kBackgroundColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
