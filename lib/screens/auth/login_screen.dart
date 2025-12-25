import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';
import '../home/main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  // Palette de couleurs
  static const Color darkGreen = Color(0xFF0B6E4F);
  static const Color gold = Color(0xFFF4C430);
  static const Color beige = Color(0xFFFAF3E0);

  Future<void> _login() async {
    print('\n========== LOGIN START ==========');
    print('Email: ${_emailController.text}');

    setState(() => _isLoading = true);

    print('📡 Vérification de la connexion au serveur...');
    final connected = await AuthService.testConnection();

    if (!connected) {
      print('❌ Serveur inaccessible!');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              '❌ Serveur inaccessible - Vérifiez que le backend est lancé',
            ),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
      return;
    }

    print('✓ Serveur OK, proceeding connexion...');
    final success = await AuthService().login(
      email: _emailController.text,
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (success) {
      print('✓ Connexion réussie, navigation vers MainScreen');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } else {
      print('❌ Connexion échouée');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Identifiants invalides - Consultez les logs'),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
    print('========== LOGIN END ==========\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo et titre
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: darkGreen,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: darkGreen.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.account_balance_wallet,
                    size: 60,
                    color: gold,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'UniSave',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Épargner ensemble, grandir ensemble',
                  style: TextStyle(
                    fontSize: 16,
                    color: darkGreen.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 48),

                // Formulaire de connexion
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: darkGreen.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Champ Email
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(
                            color: darkGreen.withOpacity(0.7),
                          ),
                          prefixIcon: const Icon(
                            Icons.email_outlined,
                            color: darkGreen,
                          ),
                          filled: true,
                          fillColor: beige.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: gold, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Champ Mot de passe
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          labelStyle: TextStyle(
                            color: darkGreen.withOpacity(0.7),
                          ),
                          prefixIcon: const Icon(
                            Icons.lock_outline,
                            color: darkGreen,
                          ),
                          filled: true,
                          fillColor: beige.withOpacity(0.3),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: gold, width: 2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Bouton de connexion
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkGreen,
                            foregroundColor: gold,
                            disabledBackgroundColor: darkGreen.withOpacity(0.6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: gold,
                                  ),
                                )
                              : const Text(
                                  'Se connecter',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Lien vers l'inscription
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Pas encore de compte ? ',
                      style: TextStyle(
                        color: darkGreen.withOpacity(0.7),
                        fontSize: 14,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: darkGreen,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                      child: const Text(
                        'Créer un compte',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                          decorationColor: gold,
                          decorationThickness: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
