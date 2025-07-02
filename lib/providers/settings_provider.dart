import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/settings.dart';

class SettingsProvider extends ChangeNotifier {
  Settings _settings = Settings();
  bool _isLoading = false;

  Settings get settings => _settings;
  bool get isLoading => _isLoading;

  // Initialize settings from local storage
  Future<void> loadSettings() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = prefs.getString('settings');
      
      if (settingsJson != null) {
        final settingsMap = json.decode(settingsJson) as Map<String, dynamic>;
        _settings = Settings.fromJson(settingsMap);
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save settings to local storage
  Future<void> saveSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final settingsJson = json.encode(_settings.toJson());
      await prefs.setString('settings', settingsJson);
    } catch (e) {
      debugPrint('Error saving settings: $e');
    }
  }

  // Update merchant information
  Future<void> updateMerchantInfo({
    String? name,
    String? address,
    String? phone,
    String? email,
    String? notes,
  }) async {
    _settings = _settings.copyWith(
      merchantName: name ?? _settings.merchantName,
      merchantAddress: address ?? _settings.merchantAddress,
      merchantPhone: phone ?? _settings.merchantPhone,
      merchantEmail: email ?? _settings.merchantEmail,
      merchantNotes: notes ?? _settings.merchantNotes,
    );
    await saveSettings();
    notifyListeners();
  }

  // Update logo path
  Future<void> updateLogoPath(String? logoPath) async {
    _settings = _settings.copyWith(logoPath: logoPath);
    await saveSettings();
    notifyListeners();
  }

  // Update currency
  Future<void> updateCurrency(String currency) async {
    _settings = _settings.copyWith(currency: currency);
    await saveSettings();
    notifyListeners();
  }

  // Update tax rates
  Future<void> updateTaxRates({
    double? taxRate,
    double? vatRate,
    double? otherRate,
  }) async {
    _settings = _settings.copyWith(
      taxRate: taxRate ?? _settings.taxRate,
      vatRate: vatRate ?? _settings.vatRate,
      otherRate: otherRate ?? _settings.otherRate,
    );
    await saveSettings();
    notifyListeners();
  }

  // Update default note
  Future<void> updateDefaultNote(String defaultNote) async {
    _settings = _settings.copyWith(defaultNote: defaultNote);
    await saveSettings();
    notifyListeners();
  }

  // Update receipt number settings
  Future<void> updateReceiptNumberSettings({
    bool? autoGenerate,
    String? prefix,
    int? length,
  }) async {
    _settings = _settings.copyWith(
      autoGenerateReceiptNumber: autoGenerate ?? _settings.autoGenerateReceiptNumber,
      receiptNumberPrefix: prefix ?? _settings.receiptNumberPrefix,
      receiptNumberLength: length ?? _settings.receiptNumberLength,
    );
    await saveSettings();
    notifyListeners();
  }

  // Toggle dark mode
  Future<void> toggleDarkMode() async {
    _settings = _settings.copyWith(isDarkMode: !_settings.isDarkMode);
    await saveSettings();
    notifyListeners();
  }

  // Generate receipt number
  String generateReceiptNumber() {
    if (!_settings.autoGenerateReceiptNumber) {
      return '';
    }
    
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch % 10000;
    return '${_settings.receiptNumberPrefix}${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-$timestamp';
  }

  // Format currency
  String formatCurrency(double amount) {
    switch (_settings.currency) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      case 'JPY':
        return '¥${amount.toStringAsFixed(0)}';
      case 'CAD':
        return 'C\$${amount.toStringAsFixed(2)}';
      case 'AUD':
        return 'A\$${amount.toStringAsFixed(2)}';
      case 'CHF':
        return 'CHF ${amount.toStringAsFixed(2)}';
      case 'GHS':
        return '₵${amount.toStringAsFixed(2)}';
      case 'NGN':
        return '₦${amount.toStringAsFixed(2)}';
      default:
        return '${amount.toStringAsFixed(2)} ${_settings.currency}';
    }
  }

  // Get available currencies
  static List<Map<String, String>> get availableCurrencies => [
    {'code': 'USD', 'name': 'US Dollar (\$)'},
    {'code': 'EUR', 'name': 'Euro (€)'},
    {'code': 'GBP', 'name': 'British Pound (£)'},
    {'code': 'JPY', 'name': 'Japanese Yen (¥)'},
    {'code': 'CAD', 'name': 'Canadian Dollar (C\$)'},
    {'code': 'AUD', 'name': 'Australian Dollar (A\$)'},
    {'code': 'CHF', 'name': 'Swiss Franc (CHF)'},
    {'code': 'GHS', 'name': 'Ghana Cedi (₵)'},
    {'code': 'NGN', 'name': 'Nigerian Naira (₦)'},
  ];

  Future<void> updateTaxRatesList(List<Map<String, dynamic>> taxRates) async {
    _settings = _settings.copyWith(taxRates: taxRates);
    await saveSettings();
    notifyListeners();
  }
} 