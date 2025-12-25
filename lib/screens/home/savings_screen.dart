import 'package:flutter/material.dart';
import '../../services/tontine_service.dart';

class SavingsScreen extends StatefulWidget {
  const SavingsScreen({super.key});

  @override
  State<SavingsScreen> createState() => _SavingsScreenState();
}

class _SavingsScreenState extends State<SavingsScreen> {
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
        title: const Text(
          'Statistiques d\'épargne',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _tontinesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: darkGreen),
            );
          }

          if (snapshot.hasError || !snapshot.hasData) {
            return Center(
              child: Text(
                'Erreur lors du chargement',
                style: TextStyle(color: darkGreen),
              ),
            );
          }

          final tontines = snapshot.data!;

          if (tontines.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.trending_up,
                    size: 64,
                    color: darkGreen.withOpacity(0.5),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Aucune tontine',
                    style: TextStyle(
                      color: darkGreen,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Rejoignez ou créez une tontine',
                    style: TextStyle(
                      color: darkGreen.withOpacity(0.6),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            );
          }

          double totalSavings = 0;
          int totalContributions = 0;

          for (var tontine in tontines) {
            totalSavings += (tontine['totalAmount'] ?? 0).toDouble();
            totalContributions += (tontine['members'].length as int);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Carte résumé
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [darkGreen, darkGreen.withOpacity(0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: darkGreen.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total épargné',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        '${totalSavings.toStringAsFixed(2)}€',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: gold.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Nombre de contributeurs: $totalContributions',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Détails par tontine',
                  style: TextStyle(
                    color: darkGreen,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                // Liste des tontines
                ...tontines.map((tontine) {
                  final amount = (tontine['totalAmount'] ?? 0).toDouble();
                  final members = tontine['members'].length;
                  final percentage = (amount / (totalSavings > 0 ? totalSavings : 1) * 100);

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: darkGreen.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              tontine['name'],
                              style: TextStyle(
                                color: darkGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${amount.toStringAsFixed(2)}€',
                              style: TextStyle(
                                color: darkGreen,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: LinearProgressIndicator(
                            value: percentage / 100,
                            minHeight: 6,
                            backgroundColor: darkGreen.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(gold),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.people,
                              size: 14,
                              color: darkGreen.withOpacity(0.6),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$members membre${members > 1 ? 's' : ''}',
                              style: TextStyle(
                                color: darkGreen.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '${percentage.toStringAsFixed(1)}% du total',
                              style: TextStyle(
                                color: gold,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
    );
  }
}
