import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jawara_mobile/modules/features/login/constants/login_api_constant.dart';
import 'package:jawara_mobile/modules/features/register/constants/register_api_constant.dart';

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

  static Future<Map<String, dynamic>> get(String path) async {
    final response = await http
        .get(
          Uri.parse('$baseUrl$path'),
          headers: await _headers(withAuth: true),
        )
        .timeout(_timeout);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    body['_statusCode'] = response.statusCode;
    return body;
  }

  static Future<Map<String, dynamic>> post(String path, Map<String, dynamic> data) async {
    final response = await http
        .post(
          Uri.parse('$baseUrl$path'),
          headers: await _headers(withAuth: true),
          body: jsonEncode(data),
        )
        .timeout(_timeout);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    body['_statusCode'] = response.statusCode;
    return body;
  }

  static Future<Map<String, dynamic>> put(String path, Map<String, dynamic> data) async {
    final response = await http
        .put(
          Uri.parse('$baseUrl$path'),
          headers: await _headers(withAuth: true),
          body: jsonEncode(data),
        )
        .timeout(_timeout);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    body['_statusCode'] = response.statusCode;
    return body;
  }

  static Future<Map<String, dynamic>> delete(String path) async {
    final response = await http
        .delete(
          Uri.parse('$baseUrl$path'),
          headers: await _headers(withAuth: true),
        )
        .timeout(_timeout);

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

  static Future<Map<String, dynamic>> getHouses() async {
    final response = await http
        .get(
          Uri.parse('$baseUrl${RegisterApiConstant.houses}'),
          headers: await _headers(),
        )
        .timeout(_timeout);

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    body['_statusCode'] = response.statusCode;
    return body;
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String nik,
    required String gender,
    required String phoneNumber,
    required File identityPhoto,
    required String password,
    required String passwordConfirmation,
    required String tempOccupancyStatus,
    int? tempHouseId,
    String? tempAddress,
  }) async {
    final uri = Uri.parse('$baseUrl${RegisterApiConstant.register}');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Accept'] = 'application/json';

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['nik'] = nik;
    request.fields['gender'] = gender;
    request.fields['phone_number'] = phoneNumber;
    request.fields['password'] = password;
    request.fields['password_confirmation'] = passwordConfirmation;
    request.fields['temp_occupancy_status'] = tempOccupancyStatus;

    request.fields['temp_house_id'] = tempHouseId?.toString() ?? '';
    request.fields['temp_address'] = (tempAddress != null && tempAddress.isNotEmpty) ? tempAddress : '';

    request.files.add(
      await http.MultipartFile.fromPath(
        'identity_photo',
        identityPhoto.path,
      ),
    );  

    final streamedResponse = await request.send().timeout(_timeout);
    final responseBody = await streamedResponse.stream.bytesToString();
    final body = jsonDecode(responseBody) as Map<String, dynamic>;
    body['_statusCode'] = streamedResponse.statusCode;
    return body;
  }
}
