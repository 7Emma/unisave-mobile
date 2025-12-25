import 'package:flutter/material.dart';

class AddSavingsScreen extends StatefulWidget {
  const AddSavingsScreen({super.key});

  @override
  State<AddSavingsScreen> createState() => _AddSavingsScreenState();
}

class _AddSavingsScreenState extends State<AddSavingsScreen> {
  final TextEditingController _amountController = TextEditingController();
  String _selectedCategory = 'Autre';

  static const Color darkGreen = Color(0xFF0B6E4F);
  static const Color gold = Color(0xFFF4C430);
  static const Color beige = Color(0xFFFAF3E0);

  final List<String> categories = [
    'Autre',
    'Urgence',
    'Projet',
    'Investissement',
    'Voyage',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _addSavings() {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Veuillez entrer un montant valide'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // TODO: Appeler API pour ajouter l'épargne
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Épargne de ${amount.toStringAsFixed(2)}€ ajoutée'),
        backgroundColor: darkGreen,
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: beige,
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        title: const Text('Ajouter une épargne'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Montant
              Text(
                'Montant',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  hintText: '0.00',
                  prefixIcon: const Icon(Icons.euro, color: gold),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: darkGreen.withOpacity(0.3)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: darkGreen.withOpacity(0.3)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: darkGreen, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Catégorie
              Text(
                'Catégorie',
                style: TextStyle(
                  color: darkGreen,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: darkGreen.withOpacity(0.3)),
                ),
                child: DropdownButton<String>(
                  value: _selectedCategory,
                  isExpanded: true,
                  underline: const SizedBox(),
                  items: categories.map((String category) {
                    return DropdownMenuItem<String>(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedCategory = newValue;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 40),

              // Résumé
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: beige,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: gold.withOpacity(0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Résumé',
                      style: TextStyle(
                        color: darkGreen,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Montant:',
                          style: TextStyle(color: darkGreen.withOpacity(0.7)),
                        ),
                        Text(
                          '${_amountController.text.isEmpty ? '0.00' : _amountController.text}€',
                          style: TextStyle(
                            color: darkGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Catégorie:',
                          style: TextStyle(color: darkGreen.withOpacity(0.7)),
                        ),
                        Text(
                          _selectedCategory,
                          style: TextStyle(
                            color: darkGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),

              // Bouton Ajouter
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _addSavings,
                  icon: const Icon(Icons.check_circle),
                  label: const Text('Ajouter l\'épargne'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: darkGreen,
                    foregroundColor: gold,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
