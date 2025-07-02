import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/banner_message.dart';

class CurrencyEditScreen extends StatefulWidget {
  const CurrencyEditScreen({super.key});

  @override
  State<CurrencyEditScreen> createState() => _CurrencyEditScreenState();
}

class _CurrencyEditScreenState extends State<CurrencyEditScreen> {
  late String _selectedCurrency;
  late TextEditingController _noteController;
  BannerMessageType? _bannerType;
  String? _bannerMessage;

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

  void _showBanner(String message, BannerMessageType type) {
    setState(() {
      _bannerMessage = message;
      _bannerType = type;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('Edit Currency & Note', style: AppTheme.headingMedium)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: ListView(
                          children: [
                            DropdownButtonFormField<String>(
                              value: _selectedCurrency,
                              decoration: const InputDecoration(labelText: 'Default Currency'),
                              items: SettingsProvider.availableCurrencies
                                  .map((currency) => DropdownMenuItem(
                                        value: currency['code'],
                                        child: Text(currency['name']!, style: AppTheme.bodyMedium),
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
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 24.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                await context.read<SettingsProvider>().updateCurrency(_selectedCurrency);
                                await context.read<SettingsProvider>().updateDefaultNote(_noteController.text);
                                if (mounted) {
                                  _showBanner('Currency and note saved!', BannerMessageType.success);
                                  Future.delayed(const Duration(seconds: 1), () {
                                    if (mounted) Navigator.pop(context);
                                  });
                                }
                              } catch (e) {
                                if (mounted) {
                                  _showBanner('Error saving: $e', BannerMessageType.error);
                                }
                              }
                            },
                            child: const Text('Save'),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        if (_bannerMessage != null && _bannerType != null)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: BannerMessage(
              message: _bannerMessage!,
              type: _bannerType!,
              onClose: () => setState(() => _bannerMessage = null),
            ),
          ),
      ],
    );
  }
} 