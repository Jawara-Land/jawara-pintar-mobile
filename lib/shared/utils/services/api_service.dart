import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jawara_mobile/modules/features/login/constants/login_api_constant.dart';

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:8000';

  static const storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  static const Duration _timeout = Duration(seconds: 30);

  static Future<Map<String, String>> _headers({bool withAuth = false}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (withAuth) {
      final token = await storage.read(key: _tokenKey);
      if (token != null) {
        headers['Authorization'] = 'Bearer $token';
      }
    }

    return headers;
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
    String? deviceName,
  }) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl${LoginApiConstant.login}'),
          headers: await _headers(),
          body: jsonEncode({
            'email': email,
            'password': password,
            'device_name': deviceName ?? 'Flutter App',
          }),
        )
        .timeout(_timeout);

    final body = jsonDecode(response.body) as Map<String, dynamic>;

    body['_statusCode'] = response.statusCode;

    if (response.statusCode == 200 && body['success'] == true) {
      final token = body['data']?['token'];
      if (token != null) {
        await storage.write(key: _tokenKey, value: token);
      }
    }

    return body;
  }

  static Future<Map<String, dynamic>> getUser() async {
    final response = await http
        .get(
          Uri.parse('$baseUrl${LoginApiConstant.user}'),
          headers: await _headers(withAuth: true),
        )
        .timeout(_timeout);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    body['_statusCode'] = response.statusCode;
    return body;
  }

  static Future<Map<String, dynamic>> logout() async {
    final response = await http
        .post(
          Uri.parse('$baseUrl${LoginApiConstant.logout}'),
          headers: await _headers(withAuth: true),
        )
        .timeout(_timeout);

    await storage.delete(key: _tokenKey);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    body['_statusCode'] = response.statusCode;
    return body;
  }

  static Future<Map<String, dynamic>> logoutAll() async {
    final response = await http
        .post(
          Uri.parse('$baseUrl${LoginApiConstant.logoutAll}'),
          headers: await _headers(withAuth: true),
        )
        .timeout(_timeout);

    await storage.delete(key: _tokenKey);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    body['_statusCode'] = response.statusCode;
    return body;
  }

  static Future<bool> isLoggedIn() async {
    final token = await storage.read(key: _tokenKey);
    return token != null;
  }

  static Future<void> clearToken() async {
    await storage.delete(key: _tokenKey);
  }

  static Future<String?> getToken() async {
    return await storage.read(key: _tokenKey);
  }
}
