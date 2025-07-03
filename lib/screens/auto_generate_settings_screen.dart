import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/banner_message.dart';

class AutoGenerateSettingsScreen extends StatefulWidget {
  const AutoGenerateSettingsScreen({super.key});

  @override
  State<AutoGenerateSettingsScreen> createState() => _AutoGenerateSettingsScreenState();
}

class _AutoGenerateSettingsScreenState extends State<AutoGenerateSettingsScreen> {
  late TextEditingController _prefixController;
  late TextEditingController _lengthController;
  bool _autoGenerate = true;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>().settings;
    _autoGenerate = settings.autoGenerateReceiptNumber;
    _prefixController = TextEditingController(text: settings.receiptNumberPrefix);
    _lengthController = TextEditingController(text: settings.receiptNumberLength.toString());
  }

  @override
  void dispose() {
    _prefixController.dispose();
    _lengthController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final provider = context.read<SettingsProvider>();
    final prefix = _prefixController.text;
    final length = int.tryParse(_lengthController.text) ?? 4;
    await provider.updateReceiptNumberSettings(
      autoGenerate: _autoGenerate,
      prefix: prefix,
      length: length,
    );
    if (mounted) Navigator.pop(context);
  }

  void _toggleAutoGenerate(bool value) async {
    try {
      final provider = context.read<SettingsProvider>();
      await provider.updateReceiptNumberSettings(autoGenerate: value);
      setState(() => _autoGenerate = value);
      BannerMessage.show(
        context,
        title: 'Success',
        subtitle: value ? 'Auto-generate enabled!' : 'Auto-generate disabled!',
        type: BannerMessageType.success,
      );
    } catch (e) {
      BannerMessage.show(
        context,
        title: 'Error',
        subtitle: 'Failed to update setting: $e',
        type: BannerMessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Auto-generate Receipt Number')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Enable Auto-generate', style: AppTheme.bodyMedium),
                Switch(
                  value: _autoGenerate,
                  onChanged: _toggleAutoGenerate,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingL),
            if (_autoGenerate) ...[
              TextField(
                controller: _prefixController,
                decoration: const InputDecoration(
                  labelText: 'Prefix (optional)',
                  hintText: 'e.g. R, INV, 2024-',
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              TextField(
                controller: _lengthController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Number Length',
                  hintText: 'e.g. 4',
                ),
              ),
            ],
            Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 