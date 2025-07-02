import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/receipt_provider.dart';
import '../providers/settings_provider.dart';
import '../widgets/items_form.dart';
import '../widgets/receipt_style_selector.dart';
import '../theme/app_theme.dart';
import '../../main.dart';
import 'receipt_preview_screen.dart';

class ReceiptCreationScreen extends StatefulWidget {
  const ReceiptCreationScreen({super.key});

  @override
  State<ReceiptCreationScreen> createState() => _ReceiptCreationScreenState();
}

class _ReceiptCreationScreenState extends State<ReceiptCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;

  // Recipient controllers
  final _recipientNameController = TextEditingController();
  final _recipientAddressController = TextEditingController();
  final _recipientPhoneController = TextEditingController();
  final _recipientEmailController = TextEditingController();
  final _receiptNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedFormData();
    _setupTextControllerListeners();
  }

  void _setupTextControllerListeners() {
    _recipientNameController.addListener(_saveFormData);
    _recipientAddressController.addListener(_saveFormData);
    _recipientPhoneController.addListener(_saveFormData);
    _recipientEmailController.addListener(_saveFormData);
    _receiptNumberController.addListener(_saveFormData);
  }

  Future<void> _loadSavedFormData() async {
    final provider = context.read<ReceiptProvider>();
    final formData = await provider.loadFormData();
    
    setState(() {
      _recipientNameController.text = formData['recipientName'] ?? '';
      _recipientAddressController.text = formData['recipientAddress'] ?? '';
      _recipientPhoneController.text = formData['recipientPhone'] ?? '';
      _recipientEmailController.text = formData['recipientEmail'] ?? '';
      _receiptNumberController.text = formData['receiptNumber'] ?? '';
    });
  }

  void _saveFormData() {
    final provider = context.read<ReceiptProvider>();
    provider.saveFormData(
      recipientName: _recipientNameController.text,
      recipientAddress: _recipientAddressController.text,
      recipientPhone: _recipientPhoneController.text,
      recipientEmail: _recipientEmailController.text,
      receiptNumber: _receiptNumberController.text,
    );
  }

  @override
  void dispose() {
    _recipientNameController.removeListener(_saveFormData);
    _recipientAddressController.removeListener(_saveFormData);
    _recipientPhoneController.removeListener(_saveFormData);
    _recipientEmailController.removeListener(_saveFormData);
    _receiptNumberController.removeListener(_saveFormData);
    _recipientNameController.dispose();
    _recipientAddressController.dispose();
    _recipientPhoneController.dispose();
    _recipientEmailController.dispose();
    _receiptNumberController.dispose();
    super.dispose();
  }

  void _clearForm(ReceiptProvider provider, SettingsProvider settingsProvider) {
    _recipientNameController.clear();
    _recipientAddressController.clear();
    _recipientPhoneController.clear();
    _recipientEmailController.clear();
    _receiptNumberController.clear();
    provider.clearCurrentReceipt();
    provider.clearFormData();
    provider.initializeReceipt();
    setState(() {
      _currentStep = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<ReceiptProvider, SettingsProvider>(
      builder: (context, provider, settingsProvider, child) {
        final receipt = provider.currentReceipt;
        if (receipt == null) {
          return const Center(child: CircularProgressIndicator());
        }

        // Set up receipt number using user's specified format
        if (settingsProvider.settings.autoGenerateReceiptNumber && _receiptNumberController.text.isEmpty) {
          _receiptNumberController.text = settingsProvider.generateReceiptNumber();
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Receipt'),
            actions: [
              IconButton(
                icon: const Icon(Icons.clear),
                tooltip: 'Clear All',
                onPressed: () => _clearForm(provider, settingsProvider),
              ),
            ],
          ),
          body: Stepper(
            currentStep: _currentStep,
            onStepTapped: (step) {
              setState(() {
                _currentStep = step;
              });
            },
            controlsBuilder: (context, details) {
              return Column(
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      if (_currentStep > 0)
                        TextButton(
                          onPressed: () {
                            setState(() {
                              _currentStep--;
                            });
                          },
                          child: const Text('Previous'),
                        ),
                      const SizedBox(width: 16),
                      if (_currentStep < 2)
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _currentStep++;
                            });
                          },
                          child: const Text('Next'),
                        ),
                      if (_currentStep == 2)
                        ElevatedButton(
                          style: AppTheme.primaryButtonStyle,
                          onPressed: () async {
                            if (_formKey.currentState?.validate() ?? false) {
                              // Set merchant info from settings
                              final merchant = settingsProvider.settings;
                              provider.updateMerchantInfo(
                                name: merchant.merchantName,
                                address: merchant.merchantAddress,
                                phone: merchant.merchantPhone,
                                email: merchant.merchantEmail,
                              );
                              provider.updateLogoPath(merchant.logoPath);
                              // Save recipient info to provider
                              provider.updateRecipientInfo(
                                name: _recipientNameController.text,
                                address: _recipientAddressController.text,
                                phone: _recipientPhoneController.text,
                                email: _recipientEmailController.text,
                              );
                              // Set receipt number
                              provider.updateReceiptNumber(_receiptNumberController.text);
                              await provider.saveReceipt();
                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const ReceiptPreviewScreen(),
                                  ),
                                );
                                // After preview, navigate to receipts page, but do not clear the form
                                final navState = MainNavigation.of(context);
                                if (navState != null) {
                                  navState.setState(() {
                                    navState.selectedIndex = 1;
                                  });
                                }
                              }
                            }
                          },
                          child: const Text('Generate Receipt'),
                        ),
                    ],
                  ),
                ],
              );
            },
            steps: [
              Step(
                title: const Text('Recipient Information'),
                content: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _recipientNameController,
                        decoration: const InputDecoration(
                          labelText: 'Recipient Name *',
                          hintText: 'Enter recipient name',
                        ),
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _recipientAddressController,
                        decoration: const InputDecoration(
                          labelText: 'Recipient Address',
                          hintText: 'Enter recipient address',
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _recipientPhoneController,
                        decoration: const InputDecoration(
                          labelText: 'Recipient Phone',
                          hintText: 'Enter recipient phone',
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _recipientEmailController,
                        decoration: const InputDecoration(
                          labelText: 'Recipient Email',
                          hintText: 'Enter recipient email',
                        ),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 12),
                      if (!settingsProvider.settings.autoGenerateReceiptNumber)
                        TextFormField(
                          controller: _receiptNumberController,
                          decoration: const InputDecoration(
                            labelText: 'Receipt Number',
                            hintText: 'Enter receipt number',
                          ),
                        ),
                      if (settingsProvider.settings.autoGenerateReceiptNumber)
                        TextFormField(
                          controller: _receiptNumberController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            labelText: 'Receipt Number',
                            hintText: 'Auto-generated',
                          ),
                        ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
                isActive: _currentStep >= 0,
              ),
              Step(
                title: const Text('Items & Pricing'),
                content: const ItemsForm(),
                isActive: _currentStep >= 1,
              ),
              Step(
                title: const Text('Receipt Style'),
                content: Column(
                  children: [
                    const ReceiptStyleSelector(),
                    const SizedBox(height: 24),
                  ],
                ),
                isActive: _currentStep >= 2,
              ),
            ],
          ),
        );
      },
    );
  }
} 