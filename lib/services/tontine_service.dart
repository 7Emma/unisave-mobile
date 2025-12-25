import 'dart:convert';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class TontineService {
  static const String baseUrl = 'http://10.0.2.2:4000/api'; // Android Emulator - Port 4000

  // Créer une tontine
  Future<bool> createTontine({
    required String name,
    required String description,
    required double monthlyAmount,
    required int lockDuration,
  }) async {
    try {
      final token = await AuthService().getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/tontines'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'description': description,
          'monthlyAmount': monthlyAmount,
          'lockDuration': lockDuration,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Erreur création tontine: $e');
      return false;
    }
  }

  // Récupérer les tontines de l'utilisateur
  Future<List<dynamic>> getUserTontines() async {
    try {
      final token = await AuthService().getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/tontines/my'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      return [];
    } catch (e) {
      print('Erreur récupération tontines: $e');
      return [];
    }
  }

  // Rejoindre une tontine
  Future<bool> joinTontine({
    required String tontineId,
    required double amountCommitted,
  }) async {
    try {
      final token = await AuthService().getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/tontines/$tontineId/join'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amountCommitted': amountCommitted,
        }),
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Erreur ajout à tontine: $e');
      return false;
    }
  }

  // Effectuer un dépôt
  Future<bool> deposit({
    required String tontineId,
    required double amount,
    String? description,
  }) async {
    try {
      final token = await AuthService().getToken();
      final response = await http.post(
        Uri.parse('$baseUrl/transactions/$tontineId/deposit'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'amount': amount,
          'description': description,
        }),
      );

      return response.statusCode == 201;
    } catch (e) {
      print('Erreur dépôt: $e');
      return false;
    }
  }
}
