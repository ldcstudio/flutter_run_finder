import 'package:dio/dio.dart';
import 'package:flutter_run_finder/models/segment.dart';
import 'package:flutter_run_finder/models/segment_map.dart';
import 'package:flutter_run_finder/services/network.dart';
import 'package:flutter_run_finder/services/oauth.dart';
import 'package:flutter_run_finder/utils/constants.dart';

class StravaAPI {
  Future<List<Segment>> exploreSegments({
    required lwrBounds,
    required uppBounds,
  }) async {
    List<Segment> segments = [];

    final params = {
      "bounds":
          "${lwrBounds.latitude}, ${lwrBounds.longitude}, ${uppBounds.latitude}, ${uppBounds.longitude}",
      "activity_type": "running",
    };

    final headers = {
      "Authorization": "Bearer ${StravaOAuthTokens.accessToken}"
    };

    try {
      final segmentData = await Network(
        baseUrl: APIEndpoints.stravaBaseUrl,
        endpoint: APIEndpoints.exploreSegmentsEndPoint,
        queryParameters: params,
        headers: headers,
      ).getJsonResponse();

      segments = SegmentMap.fromJson(segmentData).segments;
    } on DioException catch (error) {
      if (error.response!.statusMessage == 'Unauthorized') {
        await OAuth().authenticateStravaUser();
        final segmentData = await Network(
          baseUrl: APIEndpoints.stravaBaseUrl,
          endpoint: APIEndpoints.exploreSegmentsEndPoint,
          queryParameters: params,
          headers: {"Authorization": "Bearer ${StravaOAuthTokens.accessToken}"},
        ).getJsonResponse();

        segments = SegmentMap.fromJson(segmentData).segments;
      } else {
        throw Exception('Segments could not be fetched');
      }
    }

    return segments;
  }
}
