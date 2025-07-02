class ReceiptItem {
  final String name;
  final int quantity;
  final double price;
  final double discount;
  final double total;

  ReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
    this.discount = 0.0,
  }) : total = (quantity * price) - discount;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'price': price,
      'discount': discount,
      'total': total,
    };
  }

  factory ReceiptItem.fromJson(Map<String, dynamic> json) {
    return ReceiptItem(
      name: json['name'],
      quantity: json['quantity'],
      price: json['price'],
      discount: json['discount'] ?? 0.0,
    );
  }

  ReceiptItem copyWith({
    String? name,
    int? quantity,
    double? price,
    double? discount,
  }) {
    return ReceiptItem(
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      discount: discount ?? this.discount,
    );
  }
} 