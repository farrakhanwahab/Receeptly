import 'receipt_item.dart';

enum ReceiptStyle {
  bank,
  restaurant,
  retail,
  document,
}

class Receipt {
  final String id;
  final String merchantName;
  final String? merchantAddress;
  final String? merchantPhone;
  final String? merchantEmail;
  final String? logoPath;
  final String recipientName;
  final String? recipientAddress;
  final String? recipientPhone;
  final String? recipientEmail;
  final List<ReceiptItem> items;
  final double subtotal;
  final double discount;
  final double taxRate;
  final double taxAmount;
  final double vatRate;
  final double vatAmount;
  final double otherRate;
  final double otherAmount;
  final double total;
  final String currency;
  final DateTime date;
  final String? receiptNumber;
  final ReceiptStyle style;
  final String? notes;
  final List<Map<String, dynamic>> taxes;

  Receipt({
    required this.id,
    required this.merchantName,
    this.merchantAddress,
    this.merchantPhone,
    this.merchantEmail,
    this.logoPath,
    required this.recipientName,
    this.recipientAddress,
    this.recipientPhone,
    this.recipientEmail,
    required this.items,
    required this.subtotal,
    this.discount = 0.0,
    required this.taxRate,
    required this.taxAmount,
    this.vatRate = 0.0,
    this.vatAmount = 0.0,
    this.otherRate = 0.0,
    this.otherAmount = 0.0,
    required this.total,
    this.currency = 'USD',
    required this.date,
    this.receiptNumber,
    this.style = ReceiptStyle.retail,
    this.notes,
    this.taxes = const [],
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'merchantName': merchantName,
      'merchantAddress': merchantAddress,
      'merchantPhone': merchantPhone,
      'merchantEmail': merchantEmail,
      'logoPath': logoPath,
      'recipientName': recipientName,
      'recipientAddress': recipientAddress,
      'recipientPhone': recipientPhone,
      'recipientEmail': recipientEmail,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'taxRate': taxRate,
      'taxAmount': taxAmount,
      'vatRate': vatRate,
      'vatAmount': vatAmount,
      'otherRate': otherRate,
      'otherAmount': otherAmount,
      'total': total,
      'currency': currency,
      'date': date.toIso8601String(),
      'receiptNumber': receiptNumber,
      'style': style.name,
      'notes': notes,
      'taxes': taxes,
    };
  }

  factory Receipt.fromJson(Map<String, dynamic> json) {
    return Receipt(
      id: json['id'],
      merchantName: json['merchantName'],
      merchantAddress: json['merchantAddress'],
      merchantPhone: json['merchantPhone'],
      merchantEmail: json['merchantEmail'],
      logoPath: json['logoPath'],
      recipientName: json['recipientName'] ?? '',
      recipientAddress: json['recipientAddress'],
      recipientPhone: json['recipientPhone'],
      recipientEmail: json['recipientEmail'],
      items: (json['items'] as List)
          .map((item) => ReceiptItem.fromJson(item))
          .toList(),
      subtotal: json['subtotal'],
      discount: json['discount'] ?? 0.0,
      taxRate: json['taxRate'],
      taxAmount: json['taxAmount'],
      vatRate: json['vatRate'] ?? 0.0,
      vatAmount: json['vatAmount'] ?? 0.0,
      otherRate: json['otherRate'] ?? 0.0,
      otherAmount: json['otherAmount'] ?? 0.0,
      total: json['total'],
      currency: json['currency'] ?? 'USD',
      date: DateTime.parse(json['date']),
      receiptNumber: json['receiptNumber'],
      style: ReceiptStyle.values.firstWhere(
        (e) => e.name == json['style'],
        orElse: () => ReceiptStyle.retail,
      ),
      notes: json['notes'],
      taxes: (json['taxes'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [],
    );
  }

  Receipt copyWith({
    String? id,
    String? merchantName,
    String? merchantAddress,
    String? merchantPhone,
    String? merchantEmail,
    String? logoPath,
    String? recipientName,
    String? recipientAddress,
    String? recipientPhone,
    String? recipientEmail,
    List<ReceiptItem>? items,
    double? subtotal,
    double? discount,
    double? taxRate,
    double? taxAmount,
    double? vatRate,
    double? vatAmount,
    double? otherRate,
    double? otherAmount,
    double? total,
    String? currency,
    DateTime? date,
    String? receiptNumber,
    ReceiptStyle? style,
    String? notes,
    List<Map<String, dynamic>>? taxes,
  }) {
    return Receipt(
      id: id ?? this.id,
      merchantName: merchantName ?? this.merchantName,
      merchantAddress: merchantAddress ?? this.merchantAddress,
      merchantPhone: merchantPhone ?? this.merchantPhone,
      merchantEmail: merchantEmail ?? this.merchantEmail,
      logoPath: logoPath ?? this.logoPath,
      recipientName: recipientName ?? this.recipientName,
      recipientAddress: recipientAddress ?? this.recipientAddress,
      recipientPhone: recipientPhone ?? this.recipientPhone,
      recipientEmail: recipientEmail ?? this.recipientEmail,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      taxRate: taxRate ?? this.taxRate,
      taxAmount: taxAmount ?? this.taxAmount,
      vatRate: vatRate ?? this.vatRate,
      vatAmount: vatAmount ?? this.vatAmount,
      otherRate: otherRate ?? this.otherRate,
      otherAmount: otherAmount ?? this.otherAmount,
      total: total ?? this.total,
      currency: currency ?? this.currency,
      date: date ?? this.date,
      receiptNumber: receiptNumber ?? this.receiptNumber,
      style: style ?? this.style,
      notes: notes ?? this.notes,
      taxes: taxes ?? this.taxes,
    );
  }
} 