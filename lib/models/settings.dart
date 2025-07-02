class Settings {
  final String merchantName;
  final String? merchantAddress;
  final String? merchantPhone;
  final String? merchantEmail;
  final String? merchantNotes;
  final String? logoPath;
  final String currency;
  final List<Map<String, dynamic>> taxRates;
  final String defaultNote;
  final bool autoGenerateReceiptNumber;
  final bool isDarkMode;
  final String receiptNumberPrefix;
  final int receiptNumberLength;

  // Deprecated: for compatibility
  final double taxRate;
  final double vatRate;
  final double otherRate;

  Settings({
    this.merchantName = '',
    this.merchantAddress,
    this.merchantPhone,
    this.merchantEmail,
    this.merchantNotes,
    this.logoPath,
    this.currency = 'USD',
    this.taxRates = const [],
    this.defaultNote = 'Thank you for your business!',
    this.autoGenerateReceiptNumber = true,
    this.isDarkMode = false,
    this.receiptNumberPrefix = 'R',
    this.receiptNumberLength = 4,
    this.taxRate = 0.0,
    this.vatRate = 0.0,
    this.otherRate = 0.0,
  });

  Map<String, dynamic> toJson() {
    return {
      'merchantName': merchantName,
      'merchantAddress': merchantAddress,
      'merchantPhone': merchantPhone,
      'merchantEmail': merchantEmail,
      'merchantNotes': merchantNotes,
      'logoPath': logoPath,
      'currency': currency,
      'taxRates': taxRates,
      'defaultNote': defaultNote,
      'autoGenerateReceiptNumber': autoGenerateReceiptNumber,
      'isDarkMode': isDarkMode,
      'receiptNumberPrefix': receiptNumberPrefix,
      'receiptNumberLength': receiptNumberLength,
      'taxRate': taxRate,
      'vatRate': vatRate,
      'otherRate': otherRate,
    };
  }

  factory Settings.fromJson(Map<String, dynamic> json) {
    return Settings(
      merchantName: json['merchantName'] ?? '',
      merchantAddress: json['merchantAddress'],
      merchantPhone: json['merchantPhone'],
      merchantEmail: json['merchantEmail'],
      merchantNotes: json['merchantNotes'],
      logoPath: json['logoPath'],
      currency: json['currency'] ?? 'USD',
      taxRates: (json['taxRates'] as List?)?.map((e) => Map<String, dynamic>.from(e)).toList() ?? [],
      defaultNote: json['defaultNote'] ?? 'Thank you for your business!',
      autoGenerateReceiptNumber: json['autoGenerateReceiptNumber'] ?? true,
      isDarkMode: json['isDarkMode'] ?? false,
      receiptNumberPrefix: json['receiptNumberPrefix'] ?? 'R',
      receiptNumberLength: json['receiptNumberLength'] ?? 4,
      taxRate: json['taxRate']?.toDouble() ?? 0.0,
      vatRate: json['vatRate']?.toDouble() ?? 0.0,
      otherRate: json['otherRate']?.toDouble() ?? 0.0,
    );
  }

  Settings copyWith({
    String? merchantName,
    String? merchantAddress,
    String? merchantPhone,
    String? merchantEmail,
    String? merchantNotes,
    String? logoPath,
    String? currency,
    List<Map<String, dynamic>>? taxRates,
    String? defaultNote,
    bool? autoGenerateReceiptNumber,
    bool? isDarkMode,
    String? receiptNumberPrefix,
    int? receiptNumberLength,
    double? taxRate,
    double? vatRate,
    double? otherRate,
  }) {
    return Settings(
      merchantName: merchantName ?? this.merchantName,
      merchantAddress: merchantAddress ?? this.merchantAddress,
      merchantPhone: merchantPhone ?? this.merchantPhone,
      merchantEmail: merchantEmail ?? this.merchantEmail,
      merchantNotes: merchantNotes ?? this.merchantNotes,
      logoPath: logoPath ?? this.logoPath,
      currency: currency ?? this.currency,
      taxRates: taxRates ?? this.taxRates,
      defaultNote: defaultNote ?? this.defaultNote,
      autoGenerateReceiptNumber: autoGenerateReceiptNumber ?? this.autoGenerateReceiptNumber,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      receiptNumberPrefix: receiptNumberPrefix ?? this.receiptNumberPrefix,
      receiptNumberLength: receiptNumberLength ?? this.receiptNumberLength,
      taxRate: taxRate ?? this.taxRate,
      vatRate: vatRate ?? this.vatRate,
      otherRate: otherRate ?? this.otherRate,
    );
  }
} 