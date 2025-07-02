import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/receipt.dart';
import '../models/receipt_item.dart';

class ReceiptProvider extends ChangeNotifier {
  Receipt? _currentReceipt;
  List<Receipt> _recentReceipts = [];
  String _selectedCurrency = 'USD';
  double _taxRate = 0.0;
  bool _isLoading = false;

  ReceiptProvider() {
    initializeReceipt();
  }

  Receipt? get currentReceipt => _currentReceipt;
  List<Receipt> get recentReceipts => _recentReceipts;
  String get selectedCurrency => _selectedCurrency;
  double get taxRate => _taxRate;
  bool get isLoading => _isLoading;

  // Load receipts from local storage
  Future<void> loadReceipts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final receiptsJson = prefs.getString('receipts');
      
      if (receiptsJson != null) {
        final receiptsList = json.decode(receiptsJson) as List;
        _recentReceipts = receiptsList
            .map((receiptJson) => Receipt.fromJson(receiptJson))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading receipts: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Save receipts to local storage
  Future<void> _saveReceipts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final receiptsJson = json.encode(_recentReceipts.map((r) => r.toJson()).toList());
      await prefs.setString('receipts', receiptsJson);
    } catch (e) {
      debugPrint('Error saving receipts: $e');
    }
  }

  void initializeReceipt() {
    _currentReceipt = Receipt(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      merchantName: '',
      recipientName: '', // Added default for required field
      items: [],
      subtotal: 0.0,
      taxRate: _taxRate,
      taxAmount: 0.0,
      total: 0.0,
      currency: _selectedCurrency,
      date: DateTime.now(),
      receiptNumber: _generateReceiptNumber(),
    );
    notifyListeners();
  }

  void updateMerchantInfo({
    String? name,
    String? address,
    String? phone,
    String? email,
  }) {
    if (_currentReceipt != null) {
      _currentReceipt = _currentReceipt!.copyWith(
        merchantName: name ?? _currentReceipt!.merchantName,
        merchantAddress: address ?? _currentReceipt!.merchantAddress,
        merchantPhone: phone ?? _currentReceipt!.merchantPhone,
        merchantEmail: email ?? _currentReceipt!.merchantEmail,
      );
      notifyListeners();
    }
  }

  void updateLogoPath(String? logoPath) {
    if (_currentReceipt != null) {
      _currentReceipt = _currentReceipt!.copyWith(logoPath: logoPath);
      notifyListeners();
    }
  }

  void addItem(ReceiptItem item) {
    if (_currentReceipt != null) {
      final updatedItems = List<ReceiptItem>.from(_currentReceipt!.items)..add(item);
      _updateReceiptWithItems(updatedItems);
    }
  }

  void updateItem(int index, ReceiptItem item) {
    if (_currentReceipt != null && index < _currentReceipt!.items.length) {
      final updatedItems = List<ReceiptItem>.from(_currentReceipt!.items);
      updatedItems[index] = item;
      _updateReceiptWithItems(updatedItems);
    }
  }

  void removeItem(int index) {
    if (_currentReceipt != null && index < _currentReceipt!.items.length) {
      final updatedItems = List<ReceiptItem>.from(_currentReceipt!.items)..removeAt(index);
      _updateReceiptWithItems(updatedItems);
    }
  }

  void _updateReceiptWithItems(List<ReceiptItem> items) {
    if (_currentReceipt != null) {
      final subtotal = items.fold(0.0, (sum, item) => sum + item.total);
      final taxAmount = subtotal * (_taxRate / 100);
      final total = subtotal + taxAmount;

      _currentReceipt = _currentReceipt!.copyWith(
        items: items,
        subtotal: subtotal,
        taxAmount: taxAmount,
        total: total,
      );
      notifyListeners();
    }
  }

  void updateTaxRate(double taxRate) {
    _taxRate = taxRate;
    if (_currentReceipt != null) {
      final taxAmount = _currentReceipt!.subtotal * (taxRate / 100);
      final total = _currentReceipt!.subtotal + taxAmount;
      _currentReceipt = _currentReceipt!.copyWith(
        taxRate: taxRate,
        taxAmount: taxAmount,
        total: total,
      );
      notifyListeners();
    }
  }

  void updateCurrency(String currency) {
    _selectedCurrency = currency;
    if (_currentReceipt != null) {
      _currentReceipt = _currentReceipt!.copyWith(currency: currency);
      notifyListeners();
    }
  }

  void updateReceiptStyle(ReceiptStyle style) {
    if (_currentReceipt != null) {
      _currentReceipt = _currentReceipt!.copyWith(style: style);
      notifyListeners();
    }
  }

  void updateNotes(String? notes) {
    if (_currentReceipt != null) {
      _currentReceipt = _currentReceipt!.copyWith(notes: notes);
      notifyListeners();
    }
  }

  void updateRecipientInfo({
    String? name,
    String? address,
    String? phone,
    String? email,
  }) {
    if (_currentReceipt != null) {
      _currentReceipt = _currentReceipt!.copyWith(
        recipientName: name ?? _currentReceipt!.recipientName,
        recipientAddress: address ?? _currentReceipt!.recipientAddress,
        recipientPhone: phone ?? _currentReceipt!.recipientPhone,
        recipientEmail: email ?? _currentReceipt!.recipientEmail,
      );
      notifyListeners();
    }
  }

  void updateReceiptNumber(String? number) {
    if (_currentReceipt != null) {
      _currentReceipt = _currentReceipt!.copyWith(receiptNumber: number);
      notifyListeners();
    }
  }

  Future<void> saveReceipt() async {
    if (_currentReceipt != null && _currentReceipt!.merchantName.isNotEmpty) {
      // Remove if already exists (for updates)
      _recentReceipts.removeWhere((receipt) => receipt.id == _currentReceipt!.id);
      
      // Add to recent receipts
      _recentReceipts.insert(0, _currentReceipt!);
      
      // Keep only last 10 receipts
      if (_recentReceipts.length > 10) {
        _recentReceipts = _recentReceipts.take(10).toList();
      }
      
      // Save to local storage
      await _saveReceipts();
      notifyListeners();
    }
  }

  void loadReceipt(Receipt receipt) {
    _currentReceipt = receipt;
    notifyListeners();
  }

  Future<void> deleteReceipt(Receipt receipt) async {
    _recentReceipts.remove(receipt);
    await _saveReceipts();
    notifyListeners();
  }

  void clearCurrentReceipt() {
    _currentReceipt = null;
    notifyListeners();
  }

  String _generateReceiptNumber() {
    final now = DateTime.now();
    return 'R${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}-${now.millisecondsSinceEpoch % 10000}';
  }

  String formatCurrency(double amount) {
    switch (_selectedCurrency) {
      case 'USD':
        return '\$${amount.toStringAsFixed(2)}';
      case 'EUR':
        return '€${amount.toStringAsFixed(2)}';
      case 'GBP':
        return '£${amount.toStringAsFixed(2)}';
      default:
        return '${amount.toStringAsFixed(2)} $_selectedCurrency';
    }
  }
} 