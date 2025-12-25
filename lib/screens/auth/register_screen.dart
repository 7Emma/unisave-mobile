import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../home/main_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullNameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  // Palette de couleurs
  static const Color darkGreen = Color(0xFF0B6E4F);
  static const Color gold = Color(0xFFF4C430);
  static const Color beige = Color(0xFFFAF3E0);

  Future<void> _register() async {
    print('\n========== INSCRIPTION START ==========');
    print('Email: ${_emailController.text}');
    print('FullName: ${_fullNameController.text}');

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

    print('✓ Serveur OK, proceeding inscription...');
    print('🔄 Appel AuthService.register()...');
    final success = await AuthService().register(
      email: _emailController.text,
      password: _passwordController.text,
      fullName: _fullNameController.text,
      phone: _phoneController.text,
    );

    print('📊 Résultat: $success');
    setState(() => _isLoading = false);

    if (success) {
      print('✓ Inscription réussie, navigation vers MainScreen');
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()),
        );
      }
    } else {
      print('❌ Inscription échouée');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'Erreur lors de l\'inscription - Consultez les logs',
          ),
          backgroundColor: Colors.red.shade700,
        ),
      );
    }
    print('========== INSCRIPTION END ==========\n');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: darkGreen),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // En-tête
                Container(
                  padding: const EdgeInsets.all(16),
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
                  child: const Icon(Icons.person_add, size: 50, color: gold),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Rejoignez UniSave',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: darkGreen,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Commencez votre voyage d\'épargne collective',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: darkGreen.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 32),

                // Formulaire d'inscription
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
                      // Champ Nom complet
                      TextField(
                        controller: _fullNameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Nom complet',
                          labelStyle: TextStyle(
                            color: darkGreen.withOpacity(0.7),
                          ),
                          prefixIcon: const Icon(
                            Icons.person_outline,
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

                      // Champ Téléphone
                      TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Téléphone',
                          labelStyle: TextStyle(
                            color: darkGreen.withOpacity(0.7),
                          ),
                          prefixIcon: const Icon(
                            Icons.phone_outlined,
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

                      // Bouton d'inscription
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _register,
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
                                  'Créer mon compte',
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

                // Message d'encouragement
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: gold.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: gold.withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: darkGreen, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Ensemble, nous construisons un avenir financier solide',
                          style: TextStyle(
                            color: darkGreen,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
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
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
