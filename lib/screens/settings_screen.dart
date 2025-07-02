import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import 'merchant_info_edit_screen.dart';
import 'currency_edit_screen.dart';
import 'tax_rates_edit_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _merchantNameController = TextEditingController();
  final _merchantAddressController = TextEditingController();
  final _merchantPhoneController = TextEditingController();
  final _merchantEmailController = TextEditingController();
  final _merchantNotesController = TextEditingController();
  final _defaultNoteController = TextEditingController();
  final _receiptPrefixController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSettings();
    });
  }

  void _loadSettings() {
    final settings = context.read<SettingsProvider>().settings;
    _merchantNameController.text = settings.merchantName;
    _merchantAddressController.text = settings.merchantAddress ?? '';
    _merchantPhoneController.text = settings.merchantPhone ?? '';
    _merchantEmailController.text = settings.merchantEmail ?? '';
    _merchantNotesController.text = settings.merchantNotes ?? '';
    _defaultNoteController.text = settings.defaultNote;
    _receiptPrefixController.text = settings.receiptNumberPrefix;
  }

  @override
  void dispose() {
    _merchantNameController.dispose();
    _merchantAddressController.dispose();
    _merchantPhoneController.dispose();
    _merchantEmailController.dispose();
    _merchantNotesController.dispose();
    _defaultNoteController.dispose();
    _receiptPrefixController.dispose();
    super.dispose();
  }

  Future<void> _pickLogo() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null) {
        final provider = context.read<SettingsProvider>();
        await provider.updateLogoPath(result.files.single.path);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Logo uploaded successfully!'),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading logo: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final settings = settingsProvider.settings;
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: ListView(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            children: [
              // Profile Card
              if (settings.merchantName.isNotEmpty || settings.logoPath != null)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacingM),
                    child: Row(
                      children: [
                        if (settings.logoPath != null)
                          CircleAvatar(
                            radius: 32,
                            backgroundImage: AssetImage(settings.logoPath!),
                            backgroundColor: Colors.grey[200],
                          ),
                        if (settings.logoPath != null) const SizedBox(width: AppTheme.spacingM),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(settings.merchantName, style: AppTheme.headingSmall),
                              if (settings.merchantEmail != null && settings.merchantEmail!.isNotEmpty)
                                Text(settings.merchantEmail!, style: AppTheme.bodySmall),
                              if (settings.merchantPhone != null && settings.merchantPhone!.isNotEmpty)
                                Text(settings.merchantPhone!, style: AppTheme.bodySmall),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              const SizedBox(height: AppTheme.spacingL),
              // Settings Sections
              Card(
                child: ListTile(
                  leading: const Icon(Icons.business),
                  title: const Text('Merchant Information'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const MerchantInfoEditScreen()),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.attach_money),
                  title: const Text('Currency'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const CurrencyEditScreen()),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.calculate),
                  title: const Text('Tax Rates'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const TaxRatesEditScreen()),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingL),
              // App Settings (inline)
              Text('App Settings', style: AppTheme.headingSmall),
              Card(
                child: SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Enable dark theme'),
                  value: settings.isDarkMode,
                  onChanged: (value) => settingsProvider.toggleDarkMode(),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.help_outline),
                  title: const Text('Help & Support'),
                  onTap: () => _showHelpDialog(context),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('About'),
                  onTap: () => _showAboutDialog(context),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Help & Support', style: AppTheme.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('How to use the app:', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingS),
            Text('1. Configure your business settings in this page', style: AppTheme.bodySmall),
            Text('2. Create receipts with recipient information', style: AppTheme.bodySmall),
            Text('3. Add items and set pricing', style: AppTheme.bodySmall),
            Text('4. Choose receipt style and generate', style: AppTheme.bodySmall),
            Text('5. Preview, share, or save receipts', style: AppTheme.bodySmall),
            const SizedBox(height: AppTheme.spacingM),
            Text('For support:', style: AppTheme.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: AppTheme.spacingS),
            Text('Email: support@receiptgenerator.com', style: AppTheme.bodySmall),
            Text('Phone: +1-800-RECEIPT', style: AppTheme.bodySmall),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('About', style: AppTheme.headingMedium),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long, size: 64, color: Colors.grey),
            const SizedBox(height: AppTheme.spacingM),
            Text('Receipt Generator', style: AppTheme.headingSmall),
            const SizedBox(height: AppTheme.spacingS),
            Text('Version 1.0.0', style: AppTheme.bodySmall),
            const SizedBox(height: AppTheme.spacingS),
            Text('A professional receipt generator app', style: AppTheme.bodySmall),
            const SizedBox(height: AppTheme.spacingM),
            Text('© 2024 Receipt Generator', style: AppTheme.caption),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
} 