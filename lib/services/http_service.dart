import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:online_stores_app/injection_container.dart';
import 'package:online_stores_app/utils/constants.dart';

class HttpService {
  final String baseUrl = ApiRoutes.baseUrl;
  final FlutterSecureStorage secureStorage = sl<FlutterSecureStorage>();

  HttpService();

  Future<Map<String, String>> _buildHeaders([
    Map<String, String>? headers,
  ]) async {
    final token = await secureStorage.read(key: 'accessToken');

    final authHeader =
        token != null
            ? {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            }
            : {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            };

    return {...?headers, ...authHeader};
  }

  Future<dynamic> get(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? parameters,
  }) async {
    // convert parameters to query string
    if (parameters != null) {
      final queryString = parameters.entries
          .map((e) => '${e.key}=${e.value}')
          .join('&');
      endpoint += '?$queryString';
    }

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _buildHeaders(headers),
    );
    return _handleResponse(response);
  }

  Future<dynamic> post(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    headers = {...?headers};

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: await _buildHeaders(headers),
      body: jsonEncode(body),
    );

    return _handleResponse(response);
  }

  Future<dynamic> put(
    String endpoint, {
    Map<String, String>? headers,
    dynamic body,
  }) async {
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {'Content-Type': 'application/json', ...?headers},
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  Future<dynamic> delete(
    String endpoint, {
    Map<String, String>? headers,
  }) async {
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final body = response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return body;
    } else {
      throw HttpException(
        statusCode: statusCode,
        message: body?['message'] ?? 'Unknown error',
      );
    }
  }
}

class HttpException implements Exception {
  final int statusCode;
  final String message;

  HttpException({required this.statusCode, required this.message});

  @override
  String toString() => 'HttpException ($statusCode): $message';
}
