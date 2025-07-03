import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../theme/app_theme.dart';
import 'package:file_picker/file_picker.dart';
import '../widgets/banner_message.dart';

class MerchantInfoEditScreen extends StatefulWidget {
  const MerchantInfoEditScreen({super.key});

  @override
  State<MerchantInfoEditScreen> createState() => _MerchantInfoEditScreenState();
}

class _MerchantInfoEditScreenState extends State<MerchantInfoEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _notesController;
  BannerMessageType? _bannerType;
  String? _bannerTitle;
  String? _bannerSubtitle;

  @override
  void initState() {
    super.initState();
    final settings = context.read<SettingsProvider>().settings;
    _nameController = TextEditingController(text: settings.merchantName);
    _addressController = TextEditingController(text: settings.merchantAddress ?? '');
    _phoneController = TextEditingController(text: settings.merchantPhone ?? '');
    _emailController = TextEditingController(text: settings.merchantEmail ?? '');
    _notesController = TextEditingController(text: settings.merchantNotes ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _showBanner(String title, String subtitle, BannerMessageType type) {
    BannerMessage.show(
      context,
      title: title,
      subtitle: subtitle,
      type: type,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(title: Text('Edit Merchant Info', style: AppTheme.headingMedium)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacingM),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // Logo upload button
                        Align(
                          alignment: Alignment.center,
                          child: Column(
                            children: [
                              Consumer<SettingsProvider>(
                                builder: (context, provider, child) {
                                  final logoPath = provider.settings.logoPath;
                                  return Column(
                                    children: [
                                      if (logoPath != null && logoPath.isNotEmpty)
                                        CircleAvatar(
                                          radius: 32,
                                          backgroundImage: AssetImage(logoPath),
                                          backgroundColor: Colors.grey[200],
                                        ),
                                      TextButton.icon(
                                        onPressed: () async {
                                          try {
                                            FilePickerResult? result = await FilePicker.platform.pickFiles(
                                              type: FileType.image,
                                              allowMultiple: false,
                                            );
                                            if (result != null) {
                                              await provider.updateLogoPath(result.files.single.path);
                                              if (context.mounted) {
                                                _showBanner('Success', 'Logo uploaded successfully!', BannerMessageType.success);
                                              }
                                            }
                                          } catch (e) {
                                            if (context.mounted) {
                                              _showBanner('Error', 'Error uploading logo: $e', BannerMessageType.error);
                                            }
                                          }
                                        },
                                        icon: const Icon(Icons.upload_file),
                                        label: Text('Upload Logo', style: AppTheme.bodyMedium),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingL),
                        Expanded(
                          child: ListView(
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(labelText: 'Business Name *'),
                                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                              ),
                              const SizedBox(height: AppTheme.spacingM),
                              TextFormField(
                                controller: _addressController,
                                decoration: const InputDecoration(labelText: 'Business Address'),
                                maxLines: 2,
                              ),
                              const SizedBox(height: AppTheme.spacingM),
                              TextFormField(
                                controller: _phoneController,
                                decoration: const InputDecoration(labelText: 'Phone Number'),
                                keyboardType: TextInputType.phone,
                              ),
                              const SizedBox(height: AppTheme.spacingM),
                              TextFormField(
                                controller: _emailController,
                                decoration: const InputDecoration(labelText: 'Email Address'),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: AppTheme.spacingM),
                              TextFormField(
                                controller: _notesController,
                                decoration: const InputDecoration(labelText: 'Business Notes'),
                                maxLines: 3,
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
                                if (_formKey.currentState?.validate() ?? false) {
                                  try {
                                    await context.read<SettingsProvider>().updateMerchantInfo(
                                      name: _nameController.text,
                                      address: _addressController.text,
                                      phone: _phoneController.text,
                                      email: _emailController.text,
                                      notes: _notesController.text,
                                    );
                                    if (mounted) {
                                      _showBanner('Success', 'Merchant info saved!', BannerMessageType.success);
                                      Future.delayed(const Duration(seconds: 1), () {
                                        if (mounted) Navigator.pop(context);
                                      });
                                    }
                                  } catch (e) {
                                    if (mounted) {
                                      _showBanner('Error', 'Error saving info: $e', BannerMessageType.error);
                                    }
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
              ),
            ],
          ),
        ),
      ],
    );
  }
} 