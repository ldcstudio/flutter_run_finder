import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
final class Env {
  @EnviedField(varName: 'MAP_API_KEY', obfuscate: true)
  static String mapAPIKey = _Env.mapAPIKey;
  @EnviedField(varName: 'STRAVA_CLIENT_ID', obfuscate: true)
  static String stravaClientID = _Env.stravaClientID;
  @EnviedField(varName: 'STRAVA_SECRET_KEY', obfuscate: true)
  static String stravaClientSecretKey = _Env.stravaClientSecretKey;
  @EnviedField(varName: 'GOOGLE_API_KEY', obfuscate: true)
  static String googleAPIKey = _Env.googleAPIKey;
}
