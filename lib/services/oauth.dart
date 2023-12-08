import 'package:flutter_run_finder/services/network.dart';
import 'package:flutter_run_finder/utils/constants.dart';
import 'package:flutter_run_finder/env/env.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StravaOAuthTokens {
  static String? accessToken = '';
  static String? refreshToken = '';
}

class StravaOAuthToken {
  final String accessToken;
  final String refreshToken;

  StravaOAuthToken(this.accessToken, this.refreshToken);

  factory StravaOAuthToken.fromJson(Map<String, dynamic> json) {
    return StravaOAuthToken(json['access_token'], json['refresh_token']);
  }
}

class OAuth {
  Future<void> authenticateStravaUser() async {
    final prefs = await SharedPreferences.getInstance();

    final String? oAuthCode = await getStravaOAuthCode();
    if (oAuthCode != null) {
      await getStravaOAuthToken(oAuthCode).then((oAuthToken) {
        prefs.setString('accessToken', oAuthToken.accessToken);
        prefs.setString('refreshToken', oAuthToken.refreshToken);
        StravaOAuthTokens.accessToken = oAuthToken.accessToken;
        StravaOAuthTokens.refreshToken = oAuthToken.refreshToken;
      });
    }
  }

  Future<void> authenticateStravaUserFromSP() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey('accessToken') && prefs.containsKey('refreshToken')) {
      StravaOAuthTokens.accessToken = '${prefs.getString('accessToken')}';
      StravaOAuthTokens.refreshToken = prefs.getString('refreshToken');
    } else {
      authenticateStravaUser();
    }
  }

  Future<void> refreshStravaUserToken() async {
    await stravaOAuthRefreshToken(StravaOAuthTokens.refreshToken)
        .then((oAuthToken) {
      StravaOAuthTokens.accessToken = oAuthToken.accessToken;
      StravaOAuthTokens.refreshToken = oAuthToken.refreshToken;
    });
  }

  Future<String?> getStravaOAuthCode() async {
    final params = {
      'client_id': Env.stravaClientID,
      'redirect_uri': '${APIEndpoints.callbackUrlScheme}://callback',
      'response_type': 'code',
      'scope': 'read_all',
    };

    final stravaOAuthCodeData = await Network(
      baseUrl: APIEndpoints.stravaBaseUrl,
      endpoint: APIEndpoints.oAuthCodeEndPoint,
      queryParameters: params,
    ).oAuthAuthenticate(APIEndpoints.callbackUrlScheme);

    return stravaOAuthCodeData;
  }

  Future<StravaOAuthToken> getStravaOAuthToken(String oAuthCode) async {
    final params = {
      'client_id': Env.stravaClientID,
      'client_secret': Env.stravaClientSecretKey,
      'code': oAuthCode,
      'grant_type': 'authorization_code',
    };

    final stravaOAuthTokenData = await Network(
      baseUrl: APIEndpoints.stravaBaseUrl,
      endpoint: APIEndpoints.oAuthTokenEndPoint,
      queryParameters: params,
    ).postJsonRequest();

    return StravaOAuthToken.fromJson(stravaOAuthTokenData);
  }

  Future<StravaOAuthToken> stravaOAuthRefreshToken(
      String? oAuthRefreshToken) async {
    final params = {
      'client_id': Env.stravaClientID,
      'client_secret': Env.stravaClientSecretKey,
      'grant_type': 'refresh_token',
      'refresh_token': oAuthRefreshToken,
    };

    final stravaOAuthRefreshData = await Network(
      baseUrl: APIEndpoints.stravaBaseUrl,
      endpoint: APIEndpoints.oAuthRefreshTokenEndPoint,
      queryParameters: params,
    ).postJsonRequest();

    return StravaOAuthToken.fromJson(stravaOAuthRefreshData);
  }
}
