import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/main_screen.dart';
import 'services/auth_service.dart';

void main() {
  print('\n========== FLUTTER APP START ==========');
  print('🚀 Démarrage de l\'application');
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniSave - Tontine',
      debugShowCheckedModeBanner: false, // Désactive le "rainbow" de repaint
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: AuthService().getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasData && snapshot.data != null) {
          return const MainScreen();
        }

        return const LoginScreen();
      },
    );
  }
}
