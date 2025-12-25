import 'package:flutter/material.dart';
import '../../services/tontine_service.dart';
import 'tontine_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<dynamic>> _tontinesFuture;

  // Palette de couleurs
  static const Color darkGreen = Color(0xFF0B6E4F);
  static const Color gold = Color(0xFFF4C430);
  static const Color beige = Color(0xFFFAF3E0);

  @override
  void initState() {
    super.initState();
    _tontinesFuture = TontineService().getUserTontines();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: gold.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.account_balance_wallet,
                color: gold,
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mes Tontines',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'UniSave',
                  style: TextStyle(
                    color: gold,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _tontinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: darkGreen, strokeWidth: 3),
                  const SizedBox(height: 16),
                  Text(
                    'Chargement de vos tontines...',
                    style: TextStyle(
                      color: darkGreen.withOpacity(0.7),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red.shade700,
                      size: 48,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Erreur lors du chargement',
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Vérifiez votre connexion',
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          final tontines = snapshot.data!;
          if (tontines.isEmpty) {
            return Center(
              child: Container(
                margin: const EdgeInsets.all(24),
                padding: const EdgeInsets.all(32),
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
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: beige,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.group_add, color: darkGreen, size: 64),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Aucune tontine',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Créez votre première tontine\net commencez à épargner ensemble !',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: darkGreen.withOpacity(0.7),
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: () {
                        // TODO: Implémenter écran création tontine
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Créer une tontine'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: darkGreen,
                        foregroundColor: gold,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tontines.length,
            itemBuilder: (context, index) {
              final tontine = tontines[index];
              final memberCount = tontine['members'].length;
              final monthlyAmount = tontine['monthlyAmount'];

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: darkGreen.withOpacity(0.08),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TontineDetailScreen(
                            tontineId: tontine['_id'],
                            tontoneName: tontine['name'],
                          ),
                        ),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Icône
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: beige,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              Icons.savings,
                              color: darkGreen,
                              size: 28,
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Informations
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tontine['name'],
                                  style: const TextStyle(
                                    color: darkGreen,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 4,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.people,
                                          size: 16,
                                          color: darkGreen.withOpacity(0.6),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$memberCount membre${memberCount > 1 ? 's' : ''}',
                                          style: TextStyle(
                                            color: darkGreen.withOpacity(0.7),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.payments,
                                          size: 16,
                                          color: gold.withOpacity(0.8),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '$monthlyAmount€/mois',
                                          style: TextStyle(
                                            color: darkGreen.withOpacity(0.7),
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Flèche
                          Icon(Icons.arrow_forward_ios, color: gold, size: 18),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Implémenter écran création tontine
        },
        backgroundColor: darkGreen,
        foregroundColor: gold,
        icon: const Icon(Icons.add),
        label: const Text(
          'Nouvelle tontine',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
