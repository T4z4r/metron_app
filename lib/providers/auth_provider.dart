import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  final ApiService _apiService = ApiService();

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> register(String name, String phone, String password, String role) async {
    try {
      final response = await _apiService.post('/auth/register',
          {'name': name, 'phone': phone, 'password': password, 'role': role});
      final token = response['token'];
      await _apiService.setToken(token);
      _currentUser = User.fromJson(response['user']);
      notifyListeners();
    } catch (e) {
      print(e);
      throw Exception('Registration failed');
    }
  }

  Future<void> login(String phone, String password) async {
    try {
      final response = await _apiService
          .post('/auth/login', {'phone': phone, 'password': password});
      final token = response['token'];
      await _apiService.setToken(token);
      _currentUser = User.fromJson(response['user']);
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed');
    }
  }

  Future<void> sendOtp(String phone) async {
    try {
      await _apiService.post('/auth/send-otp', {'phone': phone});
    } catch (e) {
      throw Exception('Failed to send OTP');
    }
  }

  Future<void> verifyOtp(String phone, String code) async {
    try {
      final response = await _apiService
          .post('/auth/verify-otp', {'phone': phone, 'code': code});
      final token = response['token'];
      await _apiService.setToken(token);
      // Fetch user profile
      final userResponse = await _apiService.get('/me');
      _currentUser = User.fromJson(userResponse);
      notifyListeners();
    } catch (e) {
      throw Exception('OTP verification failed');
    }
  }

  Future<void> fetchProfile() async {
    try {
      final response = await _apiService.get('/me');
      _currentUser = User.fromJson(response);
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to fetch profile');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
    await _apiService.removeToken();
    notifyListeners();
  }
}
