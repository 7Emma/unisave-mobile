import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  // Remplacer localhost par l'IP machine (ex: 192.168.x.x ou 10.0.2.2 pour émulateur Android)
  static const String baseUrl = 'http://10.0.2.2:4000/api'; // Android Emulator - Port 4000
  // Pour iOS/device physique, utiliser: 'http://192.168.x.x:4000/api'
  static const storage = FlutterSecureStorage();
  static const String _tokenKey = 'auth_token';

  // Test de connexion
  static Future<bool> testConnection() async {
    try {
      print('\n🔍 TEST DE CONNEXION');
      print('URL: $baseUrl');
      final testUrl = '$baseUrl/health';
      print('Tentative: GET $testUrl');
      
      final response = await http.get(
        Uri.parse(testUrl),
      ).timeout(const Duration(seconds: 5));
      
      print('✓ Réponse: ${response.statusCode}');
      print('Body: ${response.body}');
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Erreur connexion: $e');
      return false;
    }
  }

  // Inscription
  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    String? phone,
  }) async {
    try {
      final url = '$baseUrl/auth/register';
      print('\n📡 === REGISTER REQUEST ===');
      print('URL: $url');
      print('Email: $email');
      print('FullName: $fullName');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'fullName': fullName,
          'phone': phone,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('⏱️ TIMEOUT - Le serveur n\'a pas répondu après 10 secondes');
          throw Exception('Timeout');
        },
      );

      print('\n📡 === REGISTER RESPONSE ===');
      print('Status: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        await storage.write(key: _tokenKey, value: data['token']);
        print('✓ Token sauvegardé: ${data['token'].substring(0, 20)}...');
        return true;
      } else {
        print('❌ Status: ${response.statusCode}');
        try {
          final error = jsonDecode(response.body);
          print('   Serveur dit: ${error['error']}');
        } catch (e) {
          print('   Réponse non-JSON');
        }
      }
      return false;
    } catch (e) {
      print('❌ EXCEPTION: $e');
      print('   Type: ${e.runtimeType}');
      return false;
    }
  }

  // Connexion
  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = '$baseUrl/auth/login';
      print('\n📡 === LOGIN REQUEST ===');
      print('URL: $url');
      print('Email: $email');

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          print('⏱️ TIMEOUT - Le serveur n\'a pas répondu après 10 secondes');
          throw Exception('Timeout');
        },
      );

      print('\n📡 === LOGIN RESPONSE ===');
      print('Status: ${response.statusCode}');
      print('Headers: ${response.headers}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await storage.write(key: _tokenKey, value: data['token']);
        print('✓ Connexion réussie - Token sauvegardé: ${data['token'].substring(0, 20)}...');
        return true;
      } else {
        print('❌ Status: ${response.statusCode}');
        try {
          final error = jsonDecode(response.body);
          print('   Serveur dit: ${error['error']}');
        } catch (e) {
          print('   Réponse non-JSON');
        }
      }
      return false;
    } catch (e) {
      print('❌ EXCEPTION: $e');
      print('   Type: ${e.runtimeType}');
      return false;
    }
  }

  // Récupérer le token
  Future<String?> getToken() async {
    return await storage.read(key: _tokenKey);
  }

  // Déconnexion
  Future<void> logout() async {
    await storage.delete(key: _tokenKey);
  }
}
