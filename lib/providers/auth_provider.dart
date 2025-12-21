import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  final ApiService _apiService = ApiService();

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> login(String email, String password) async {
    try {
      final response = await _apiService.post('/login', {'email': email, 'password': password});
      _currentUser = User.fromJson(response);
      notifyListeners();
    } catch (e) {
      throw Exception('Login failed');
    }
  }

  Future<void> register(String name, String email, String password, String role) async {
    try {
      final response = await _apiService.post('/register', {
        'name': name,
        'email': email,
        'password': password,
        'role': role
      });
      _currentUser = User.fromJson(response);
      notifyListeners();
    } catch (e) {
      throw Exception('Registration failed');
    }
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}