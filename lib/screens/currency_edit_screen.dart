import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';

class CurrencyEditScreen extends StatefulWidget {
  const CurrencyEditScreen({super.key});

  @override
  State<CurrencyEditScreen> createState() => _CurrencyEditScreenState();
}

class _CurrencyEditScreenState extends State<CurrencyEditScreen> {
  late String _selectedCurrency;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>().settings;
    _selectedCurrency = settings.currency;
    _noteController = TextEditingController(text: settings.defaultNote);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Currency & Note')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedCurrency,
              decoration: const InputDecoration(labelText: 'Default Currency'),
              items: SettingsProvider.availableCurrencies
                  .map((currency) => DropdownMenuItem(
                        value: currency['code'],
                        child: Text(currency['name']!),
                      ))
                  .toList(),
              onChanged: (value) {
                if (value != null) setState(() => _selectedCurrency = value);
              },
            ),
            const SizedBox(height: AppTheme.spacingL),
            TextFormField(
              controller: _noteController,
              decoration: const InputDecoration(labelText: 'Default Note'),
              maxLines: 2,
            ),
            const SizedBox(height: AppTheme.spacingL),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await context.read<SettingsProvider>().updateCurrency(_selectedCurrency);
                  await context.read<SettingsProvider>().updateDefaultNote(_noteController.text);
                  if (mounted) Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 