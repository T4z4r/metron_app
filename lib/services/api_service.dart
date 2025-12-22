import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  static const String baseUrl =
      'https://metron.sudsudgroup.com/api'; // Laravel backend URL
  final _storage = FlutterSecureStorage();

  Future<String?> getToken() async {
    return await _storage.read(key: 'token');
  }

  Future<void> setToken(String token) async {
    await _storage.write(key: 'token', value: token);
  }

  Future<void> removeToken() async {
    await _storage.delete(key: 'token');
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    final token = await getToken();
    final headers =
        token != null ? {'Authorization': 'Bearer $token'} : <String, String>{};
    final response =
        await http.get(Uri.parse('$baseUrl$endpoint'), headers: headers);
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> post(
      String endpoint, Map<String, dynamic> data) async {
    final token = await getToken();
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to post data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> put(
      String endpoint, Map<String, dynamic> data) async {
    final token = await getToken();
    final headers = {'Content-Type': 'application/json'};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
      body: json.encode(data),
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to update data: ${response.statusCode}');
    }
  }

  Future<Map<String, dynamic>> delete(String endpoint) async {
    final token = await getToken();
    final headers = <String, String>{};
    if (token != null) headers['Authorization'] = 'Bearer $token';
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: headers,
    );
    if (response.statusCode == 200 || response.statusCode == 204) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to delete data: ${response.statusCode}');
    }
  }

  // File upload method for photos
  Future<Map<String, dynamic>> uploadFiles(
      String endpoint, List<http.MultipartFile> files) async {
    final token = await getToken();
    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl$endpoint'));
    if (token != null) {
      request.headers['Authorization'] = 'Bearer $token';
    }

    for (var file in files) {
      request.files.add(file);
    }

    final response = await request.send();
    final responseData = await response.stream.bytesToString();

    if (response.statusCode == 200 || response.statusCode == 201) {
      return json.decode(responseData);
    } else {
      throw Exception('Failed to upload files: ${response.statusCode}');
    }
  }

  // Helper method to create multipart file
  static Future<http.MultipartFile> fileFromPath(
      String fieldName, String filePath) async {
    return await http.MultipartFile.fromPath(fieldName, filePath);
  }

  // Helper method to create multipart file from bytes
  static Future<http.MultipartFile> fileFromBytes(
      String fieldName, List<int> bytes, String filename) async {
    return http.MultipartFile.fromBytes(fieldName, bytes, filename: filename);
  }
}
