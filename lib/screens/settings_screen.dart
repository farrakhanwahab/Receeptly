import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import 'merchant_info_edit_screen.dart';
import 'currency_edit_screen.dart';
import 'tax_rates_edit_screen.dart';
import 'help_support_screen.dart';
import '../widgets/banner_message.dart';
import 'auto_generate_settings_screen.dart';
import '../providers/receipt_provider.dart';

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
  final _receiptNumberLengthController = TextEditingController();
  BannerMessageType? _bannerType;
  String? _bannerTitle;
  String? _bannerSubtitle;

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
    _receiptNumberLengthController.text = settings.receiptNumberLength.toString();
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
    _receiptNumberLengthController.dispose();
    super.dispose();
  }

  void _showBanner(String title, String subtitle, BannerMessageType type) {
    setState(() {
      _bannerTitle = title;
      _bannerSubtitle = subtitle;
      _bannerType = type;
    });
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
          _showBanner('Success', 'Logo uploaded successfully!', BannerMessageType.success);
        }
      }
    } catch (e) {
      if (mounted) {
        _showBanner('Error', 'Error uploading logo: $e', BannerMessageType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        final settings = settingsProvider.settings;
        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(title: Text('Settings', style: AppTheme.headingLarge)),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: Column(
                children: [
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.all(AppTheme.spacingM),
                      children: [
                        // Profile Card
                        if (settings.merchantName.isNotEmpty || settings.logoPath != null)
                          Card(
                            color: Theme.of(context).cardColor,
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
                                        if (settings.merchantAddress != null && settings.merchantAddress!.isNotEmpty)
                                          Text(settings.merchantAddress!, style: AppTheme.bodySmall),
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
                        // Settings Sections
                        Card(
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            leading: const Icon(Icons.business),
                            title: Text('Merchant Information', style: AppTheme.bodyMedium),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const MerchantInfoEditScreen()),
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            leading: const Icon(Icons.attach_money),
                            title: Text('Currency', style: AppTheme.bodyMedium),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const CurrencyEditScreen()),
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            leading: const Icon(Icons.calculate),
                            title: Text('Tax Rates', style: AppTheme.bodyMedium),
                            subtitle: settings.taxRates.isNotEmpty 
                                ? Text('${settings.taxRates.length} tax rate(s) configured', style: AppTheme.bodySmall)
                                : Text('No tax rates configured', style: AppTheme.bodySmall),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const TaxRatesEditScreen()),
                            ),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingL),
                        // App Settings (inline)
                        Text('App Settings', style: AppTheme.bodyMedium),
                        Card(
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            leading: const Icon(Icons.dark_mode),
                            title: Text('Dark Mode', style: AppTheme.bodyMedium),
                            trailing: Consumer<SettingsProvider>(
                              builder: (context, provider, child) {
                                return Switch(
                                  value: provider.settings.isDarkMode,
                                  onChanged: (value) async {
                                    await provider.toggleDarkMode();
                                  },
                                );
                              },
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            leading: const Icon(Icons.confirmation_number),
                            title: Text('Auto-generate Receipt Number', style: AppTheme.bodyMedium),
                            trailing: const Icon(Icons.chevron_right),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const AutoGenerateSettingsScreen()),
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            leading: const Icon(Icons.help_outline),
                            title: Text('Help & Support', style: AppTheme.bodyMedium),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const HelpSupportScreen()),
                            ),
                          ),
                        ),
                        Card(
                          color: Theme.of(context).cardColor,
                          child: ListTile(
                            leading: const Icon(Icons.info_outline),
                            title: Text('About', style: AppTheme.bodyMedium),
                            onTap: () => _showAboutDialog(context),
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                        ElevatedButton(
                          style: AppTheme.dangerButtonStyle,
                          onPressed: () async {
                            final confirmed = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Clear All Data', style: AppTheme.headingMedium),
                                content: Text('Are you sure you want to clear all settings and receipts? This cannot be undone.', style: AppTheme.bodyMedium),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    style: AppTheme.dangerButtonStyle,
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text('Clear'),
                                  ),
                                ],
                              ),
                            );
                            if (confirmed == true) {
                              await context.read<SettingsProvider>().clearAllSettings();
                              await context.read<ReceiptProvider>().clearAllReceipts();
                              if (context.mounted) {
                                BannerMessage.show(
                                  context,
                                  title: 'Success',
                                  subtitle: 'All data cleared.',
                                  type: BannerMessageType.success,
                                );
                                Navigator.of(context).popUntil((route) => route.isFirst);
                              }
                            }
                          },
                          child: const Text('Clear All Data'),
                        ),
                        const SizedBox(height: AppTheme.spacingXL),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (_bannerTitle != null && _bannerSubtitle != null && _bannerType != null)
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: BannerMessage(
                  title: _bannerTitle!,
                  subtitle: _bannerSubtitle!,
                  type: _bannerType!,
                  onClose: () => setState(() {
                    _bannerTitle = null;
                    _bannerSubtitle = null;
                  }),
                ),
              ),
          ],
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
            Text('Email: wahabfarrakhan@gmail.com', style: AppTheme.bodySmall),
            Text('Phone: +233-500-428501', style: AppTheme.bodySmall),
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
            Text('Receeptly', style: AppTheme.headingSmall),
            const SizedBox(height: AppTheme.spacingS),
            Text('Version 1.0.0', style: AppTheme.bodySmall),
            const SizedBox(height: AppTheme.spacingS),
            Text('A receipt generator app', style: AppTheme.bodySmall),
            const SizedBox(height: AppTheme.spacingM),
            Text('© 2025 Farrakhan Wahab', style: AppTheme.caption),
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