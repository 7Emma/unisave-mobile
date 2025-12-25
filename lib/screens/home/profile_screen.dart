import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Palette de couleurs
  static const Color darkGreen = Color(0xFF0B6E4F);
  static const Color gold = Color(0xFFF4C430);
  static const Color beige = Color(0xFFFAF3E0);

  // Langue sélectionnée
  String _selectedLanguage = 'Français';

  // Langues disponibles
  final List<Map<String, String>> _languages = [
    {'name': 'Français', 'code': 'fr', 'flag': '🇫🇷'},
    {'name': 'English', 'code': 'en', 'flag': '🇬🇧'},
    {'name': 'Español', 'code': 'es', 'flag': '🇪🇸'},
    {'name': 'Português', 'code': 'pt', 'flag': '🇵🇹'},
    {'name': 'Italiano', 'code': 'it', 'flag': '🇮🇹'},
    {'name': 'Deutsch', 'code': 'de', 'flag': '🇩🇪'},
    {'name': 'Nederlands', 'code': 'nl', 'flag': '🇳🇱'},
    {'name': 'العربية', 'code': 'ar', 'flag': '🇸🇦'},
  ];

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.language, color: darkGreen),
            const SizedBox(width: 12),
            const Text('Sélectionner une langue'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _languages.length,
            itemBuilder: (context, index) {
              final language = _languages[index];
              final isSelected = _selectedLanguage == language['name'];

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected ? darkGreen : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(10),
                  color: isSelected ? darkGreen.withOpacity(0.1) : Colors.white,
                ),
                child: ListTile(
                  leading: Text(
                    language['flag']!,
                    style: const TextStyle(fontSize: 24),
                  ),
                  title: Text(
                    language['name']!,
                    style: TextStyle(
                      color: darkGreen,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  trailing: isSelected
                      ? Icon(Icons.check_circle, color: darkGreen)
                      : Icon(Icons.circle_outlined, color: Colors.grey),
                  onTap: () {
                    setState(() {
                      _selectedLanguage = language['name']!;
                    });
                    Navigator.pop(context);
                  },
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer'),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Déconnexion'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await AuthService().logout();
              if (mounted) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              }
            },
            child: Text(
              'Déconnecter',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        title: const Text(
          'Mon profil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // En-tête profil
            Container(
              padding: const EdgeInsets.all(24),
              color: darkGreen,
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: gold.withOpacity(0.2),
                      border: Border.all(
                        color: gold,
                        width: 3,
                      ),
                    ),
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: gold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Emma Dupont',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'emma@example.com',
                    style: TextStyle(
                      color: gold.withOpacity(0.9),
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: gold.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: gold),
                    ),
                    child: const Text(
                      'Membre depuis 6 mois',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Corps
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Statistiques
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: darkGreen.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _StatCard(
                          title: 'Tontines',
                          value: '4',
                          icon: Icons.group,
                          color: darkGreen,
                        ),
                        _StatCard(
                          title: 'Total épargné',
                          value: '1250€',
                          icon: Icons.savings,
                          color: gold,
                        ),
                        _StatCard(
                          title: 'Rang',
                          value: '#12',
                          icon: Icons.leaderboard,
                          color: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Section Paramètres
                  Text(
                    'Paramètres',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingTile(
                    icon: Icons.person_outline,
                    title: 'Modifier le profil',
                    onTap: () {},
                  ),
                  _SettingTile(
                    icon: Icons.lock_outline,
                    title: 'Changer le mot de passe',
                    onTap: () {},
                  ),
                  _SettingTile(
                    icon: Icons.notifications_outlined,
                    title: 'Notifications',
                    trailing: Switch(
                      value: true,
                      onChanged: (_) {},
                      activeColor: darkGreen,
                    ),
                  ),
                  _SettingTile(
                    icon: Icons.language,
                    title: 'Langue',
                    subtitle: _selectedLanguage,
                    onTap: _showLanguageDialog,
                  ),
                  const SizedBox(height: 24),
                  // Section Support
                  Text(
                    'Support',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _SettingTile(
                    icon: Icons.help_outline,
                    title: 'Aide et support',
                    onTap: () {},
                  ),
                  _SettingTile(
                    icon: Icons.description_outlined,
                    title: 'Conditions d\'utilisation',
                    onTap: () {},
                  ),
                  _SettingTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Politique de confidentialité',
                    onTap: () {},
                  ),
                  const SizedBox(height: 24),
                  // Bouton déconnexion
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _logout,
                      icon: const Icon(Icons.logout),
                      label: const Text('Déconnexion'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Version
                  Center(
                    child: Text(
                      'UniSave v1.0.0',
                      style: TextStyle(
                        color: darkGreen.withOpacity(0.5),
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF0B6E4F),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            fontSize: 11,
            color: const Color(0xFF0B6E4F).withOpacity(0.6),
          ),
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF0B6E4F).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: const Color(0xFF0B6E4F),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Color(0xFF0B6E4F),
            fontWeight: FontWeight.w500,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle!,
                style: TextStyle(
                  color: const Color(0xFF0B6E4F).withOpacity(0.6),
                  fontSize: 12,
                ),
              )
            : null,
        trailing: trailing ??
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: const Color(0xFFF4C430),
            ),
        onTap: onTap,
      ),
    );
  }
}
