import 'package:http/http.dart' as http;
import 'api_service.dart';

class PaymentService {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> initiatePayment(double amount, String provider) async {
    try {
      final response = await _apiService.post('/payments/initiate', {
        'amount': amount,
        'provider': provider,
      });
      return response;
    } catch (e) {
      throw Exception('Failed to initiate payment: $e');
    }
  }

  Future<bool> processPayment(double amount, String paymentMethod) async {
    // This is now handled by the API
    try {
      await initiatePayment(amount, paymentMethod);
      return true;
    } catch (e) {
      return false;
    }
  }

  // Add more methods as needed
}