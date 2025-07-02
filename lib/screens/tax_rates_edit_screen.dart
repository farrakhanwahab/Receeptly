import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

class TaxRatesEditScreen extends StatefulWidget {
  const TaxRatesEditScreen({super.key});

  @override
  State<TaxRatesEditScreen> createState() => _TaxRatesEditScreenState();
}

class _TaxRatesEditScreenState extends State<TaxRatesEditScreen> {
  late List<Map<String, dynamic>> _taxRates;
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _rateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>().settings;
    _taxRates = List<Map<String, dynamic>>.from(settings.taxRates ?? []);
  }

  void _addTaxRate() {
    if (_nameController.text.isNotEmpty && double.tryParse(_rateController.text) != null) {
      setState(() {
        _taxRates.add({
          'name': _nameController.text,
          'rate': double.parse(_rateController.text),
        });
        _nameController.clear();
        _rateController.clear();
      });
    }
  }

  void _removeTaxRate(int index) {
    setState(() {
      _taxRates.removeAt(index);
    });
  }

  void _save() async {
    await context.read<SettingsProvider>().updateTaxRatesList(_taxRates);
    if (mounted) Navigator.pop(context);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _rateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Tax Rates')),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Form(
              key: _formKey,
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(labelText: 'Tax Name'),
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: TextFormField(
                      controller: _rateController,
                      decoration: const InputDecoration(labelText: 'Rate (%)'),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: _addTaxRate,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            Expanded(
              child: ListView.builder(
                itemCount: _taxRates.length,
                itemBuilder: (context, index) {
                  final tax = _taxRates[index];
                  return Card(
                    child: ListTile(
                      title: Text(tax['name']),
                      subtitle: Text('${tax['rate']}%'),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _removeTaxRate(index),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppTheme.spacingL),
            SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 