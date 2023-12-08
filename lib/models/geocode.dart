import 'package:latlong2/latlong.dart';

/// Google Geocode API
/// https://developers.google.com/maps/documentation/geocoding/requests-reverse-geocoding

class Geocode {
  final String status;
  final List<GeocodeResults> results;
  final String? errorMessage;

  Geocode({
    required this.status,
    required this.results,
    this.errorMessage = '',
  });

  factory Geocode.fromJson(Map<String, dynamic> json) {
    final List<dynamic> results = json["results"] as List;
    final List<GeocodeResults> geocodeResults =
        results.map((result) => GeocodeResults.fromJson(result)).toList();

    return Geocode(
      status: json["status"],
      results: geocodeResults,
      errorMessage: json["error_message"],
    );
  }
}

class GeocodeResults {
  final String name;
  final LatLng uppBounds;
  final LatLng lwrBounds;

  GeocodeResults({
    required this.name,
    required this.uppBounds,
    required this.lwrBounds,
  });

  factory GeocodeResults.fromJson(Map<String, dynamic> json) {
    final geocodeBounds = json["geometry"]["viewport"];

    return GeocodeResults(
      name: json["formatted_address"],
      uppBounds: LatLng(
        geocodeBounds["northeast"]["lat"],
        geocodeBounds["northeast"]["lng"],
      ),
      lwrBounds: LatLng(
        geocodeBounds["southwest"]["lat"],
        geocodeBounds["southwest"]["lng"],
      ),
    );
  }
}
