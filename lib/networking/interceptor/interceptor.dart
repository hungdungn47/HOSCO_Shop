import 'dart:convert';

import 'package:http/http.dart' as http;
// import 'package:travel_guide_app/utils/helper_functions.dart';

import '../config.dart';

class HttpClientWithInterceptor extends http.BaseClient {
  final http.Client _inner;

  HttpClientWithInterceptor(this._inner);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    // print('Request: ${request.url}');
    // print('Request headers: ${request.headers}');
    // print('Request headers: ${request.method}');
    String requestEndpoint = request.url.path.toString();
    if(requestEndpoint != '/api/v1/authenticate' && requestEndpoint != '/api/v1/register') {
      request.headers['Authorization'] = Config.accessToken;
    }
    final response = await _inner.send(request);

    if(response.statusCode == 401) {
      // HelperFunctions.showMessage('The login session has expired', 2);
      await Future.delayed(const Duration(seconds: 3));
      // HelperFunctions.navigateToLoginPage();
    }

    return response;
  }
}
