import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';

class Network {
  final String baseUrl;
  final String endpoint;
  final Map<String, dynamic> queryParameters;
  Map<String, String>? headers;

  Network({
    required this.baseUrl,
    required this.endpoint,
    required this.queryParameters,
    this.headers,
  });

  Future<Map<String, dynamic>> getJsonResponse() async {
    final Dio dio = Dio();
    dio.options.baseUrl = 'https://$baseUrl';
    dio.options.queryParameters = queryParameters;
    dio.options.headers = headers;
    dio.options.responseType = ResponseType.json;
    dio.interceptors
      ..add(CacheInterceptor())
      ..add(LogInterceptor(requestHeader: false, responseHeader: false));

    final response = await dio.get('/$endpoint');
    return response.data;
  }

  Future<Map<String, dynamic>> postJsonRequest() async {
    final Dio dio = Dio();
    dio.options.baseUrl = 'https://$baseUrl';
    dio.options.queryParameters = queryParameters;
    dio.options.headers = headers;
    dio.options.responseType = ResponseType.json;
    dio.interceptors
      ..add(CacheInterceptor())
      ..add(LogInterceptor(requestHeader: false, responseHeader: false));

    final response = await dio.post('/$endpoint');
    return response.data;
  }

  Future<String?> oAuthAuthenticate(String callbackUrlScheme) async {
    final url = Uri.https(
      baseUrl,
      endpoint,
      queryParameters,
    );

    try {
      final response = await FlutterWebAuth2.authenticate(
        url: url.toString(),
        callbackUrlScheme: callbackUrlScheme,
      );
      final oAuthCode = Uri.parse(response).queryParameters['code'];
      return oAuthCode;
    } catch (_) {
      throw Exception('Failed to authenticate user');
    }
  }
}

class CacheInterceptor extends Interceptor {
  final _cache = <Uri, Response>{};

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final response = _cache[options.uri];
    if (options.extra['refresh'] == true) {
      debugPrint('${options.uri}: force refresh, ignore cache! \n');
      return handler.next(options);
    } else if (response != null) {
      debugPrint('cache hit: ${options.uri} \n');
      return handler.resolve(response);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 200) {
      _cache[response.requestOptions.uri] = response;
    } else if (response.statusCode == 400) {
      throw Exception('Unauthorized');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    debugPrint('onError: $err');
    super.onError(err, handler);
  }
}
