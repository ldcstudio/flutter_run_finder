import 'package:flutter_run_finder/models/geocode.dart';
import 'package:flutter_run_finder/services/network.dart';
import 'package:flutter_run_finder/utils/constants.dart';
import 'package:flutter_run_finder/env/env.dart';
import 'package:latlong2/latlong.dart';

class GeocodeAPI {
  Future<Geocode> getGeocodeDetail({LatLng? location}) async {
    final params = {
      "latlng": "${location!.latitude},${location.longitude}",
      "result_type": "postal_code",
      "key": Env.googleAPIKey,
    };

    final geocodeData = await Network(
            baseUrl: APIEndpoints.googleBaseUrl,
            endpoint: APIEndpoints.geocodePath,
            queryParameters: params)
        .getJsonResponse();

    return Geocode.fromJson(geocodeData);
  }
}
