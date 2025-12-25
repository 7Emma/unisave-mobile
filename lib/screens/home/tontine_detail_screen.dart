import 'package:flutter/material.dart';
import '../../services/tontine_service.dart';

class TontineDetailScreen extends StatefulWidget {
  final String tontineId;
  final String tontoneName;

  const TontineDetailScreen({
    Key? key,
    required this.tontineId,
    required this.tontoneName,
  }) : super(key: key);

  @override
  State<TontineDetailScreen> createState() => _TontineDetailScreenState();
}

class _TontineDetailScreenState extends State<TontineDetailScreen> {
  final _amountController = TextEditingController();
  bool _isLoading = false;

  Future<void> _makeDeposit() async {
    setState(() => _isLoading = true);

    final amount = double.tryParse(_amountController.text) ?? 0;
    final success = await TontineService().deposit(
      tontineId: widget.tontineId,
      amount: amount,
    );

    setState(() => _isLoading = false);

    if (success) {
      _amountController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Dépôt effectué avec succès')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erreur lors du dépôt')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.tontoneName)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Montant du dépôt', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Montant (€)',
                hintText: '0.00',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _makeDeposit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Effectuer le dépôt'),
            ),
          ],
        ),
      ),
    );
  }
}
