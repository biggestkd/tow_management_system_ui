class Pricing {
  final String id;
  final String itemName;
  final int amount;
  final String companyId;

  Pricing({
    required this.id,
    required this.itemName,
    required this.amount,
    required this.companyId,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    final amountValue = json['amount'] ?? 0;
    return Pricing(
      id: json['id'] ?? '',
      itemName: json['itemName'] ?? '',
      amount: amountValue is int ? amountValue : (amountValue as num).toInt(),
      companyId: json['companyId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemName': itemName,
    'amount': amount,
    'companyId': companyId,
  };
}
