import 'dart:convert';

import 'package:http/http.dart' as http;
import './index.dart';

typedef JSON = Map<String, dynamic>;

class HttpClient {
  static String baseUrl = Config.baseUrl;

  static final client = HttpClientWithInterceptor(http.Client());

  static const Duration timeoutDuration = Duration(seconds: 5);

  static Future<JSON?> get(
      {required String endPoint, JSON? queryParams}) async {
    try {
      final url = Uri.http(baseUrl, endPoint, queryParams);
      var response = await client.get(url).timeout(timeoutDuration);

      print(response.statusCode);
      if (response.statusCode != 204 && response.statusCode != 200) {
        return null;
      }
      await handleJwt(response);
      final JSON parsed = json.decode(utf8.decode(response.bodyBytes));
      return parsed;
    } catch (e) {
      throw Exception("Request failed or timed out: $e");
    }
  }

  static Future<List<dynamic>> getList(
      {required String endPoint, JSON? queryParams}) async {
    final url = Uri.http(baseUrl, endPoint, queryParams);
    var response = await client.get(url);
    if (response.statusCode != 204 && response.statusCode != 200) {
      return [];
    }
    await handleJwt(response);
    final List<dynamic> parsed = json.decode(response.body);
    return parsed;
  }

  static Future<JSON?> post(
      {required String endPoint,
      JSON? queryParams,
      Object? body,
      String contentType = 'application/json'}) async {
    final url = Uri.http(baseUrl, endPoint, queryParams);
    print(body);
    var response = await client.post(
      url,
      headers: {
        'Content-Type': contentType,
      },
      body: json.encode(body),
    );
    print(response);
    if (response.statusCode != 204 && response.statusCode != 200 && response.statusCode != 201) {
      throw new Exception(json.decode(response.body)['error']);
    }

    final JSON parsed = json.decode(response.body);
    return parsed;
  }

  static Future<void> handleJwt(http.Response response) async {
    var jsonResponse = json.decode(response.body);
    if (jsonResponse["code"] == 401) {
      // HelperFunctions.showMessage('The login session has expired', 2);
      await Future.delayed(const Duration(seconds: 3));
      // HelperFunctions.navigateToLoginPage();
    }
  }

  static Future<List<dynamic>> postList(
      {required String endPoint, JSON? queryParams, Object? body}) async {
    final url = Uri.http(baseUrl, endPoint, queryParams);
    var response = await client.post(url, body: body);
    if (response.statusCode != 204 && response.statusCode != 200) {
      return [];
    }

    final List<dynamic> parsed = json.decode(response.body);
    return parsed;
  }

  static Future<JSON?> delete(
      {required String endPoint, JSON? queryParams, Object? body}) async {
    final url = Uri.https(baseUrl, endPoint, queryParams);
    var response = await client.delete(url, body: body);
    if (response.statusCode != 204 && response.statusCode != 200) {
      return null;
    }

    final JSON parsed = json.decode(response.body);
    return parsed;
  }

  static Future<JSON?> put(
      {required String endPoint,
      JSON? queryParams,
      Object? body,
      String contentType = 'application/json'}) async {
    final url = Uri.http(baseUrl, endPoint, queryParams);
    print(body);
    var response = await client.put(
      url,
      headers: {
        'Content-Type': contentType,
      },
      body: json.encode(body),
    );
    print(response);
    // if (response.statusCode != 204 && response.statusCode != 200) {
    //   return null;
    // }

    final JSON parsed = json.decode(response.body);
    return parsed;
  }

  static Future<List<dynamic>> putList(
      {required String endPoint, JSON? queryParams, Object? body}) async {
    final url = Uri.http(baseUrl, endPoint, queryParams);
    var response = await client.put(url, body: body);
    if (response.statusCode != 204 && response.statusCode != 200) {
      return [];
    }

    final List<dynamic> parsed = json.decode(response.body);
    return parsed;
  }

  static Future<JSON?> patch(
      {required String endPoint, JSON? queryParams, Object? body}) async {
    final url = Uri.http(baseUrl, endPoint, queryParams);
    var response = await client.patch(url, body: body);
    if (response.statusCode != 204 && response.statusCode != 200) {
      return null;
    }

    final JSON parsed = json.decode(response.body);
    return parsed;
  }

  static Future<List<dynamic>> patchList(
      {required String endPoint, JSON? queryParams, Object? body}) async {
    final url = Uri.http(baseUrl, endPoint, queryParams);
    var response = await client.patch(url, body: body);
    if (response.statusCode != 204 && response.statusCode != 200) {
      return [];
    }

    final List<dynamic> parsed = json.decode(response.body);
    return parsed;
  }
}
