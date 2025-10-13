import 'package:tow_management_system_ui/models/rule.dart';

class Pricing {
  final String id;
  final String itemName;
  final double amount;
  final Rule rule;
  final String accountId;

  Pricing({
    required this.id,
    required this.itemName,
    required this.amount,
    required this.rule,
    required this.accountId,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) {
    return Pricing(
      id: json['id'] ?? '',
      itemName: json['itemName'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      rule: Rule.fromJson(json['rule'] ?? {}),
      accountId: json['accountId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'itemName': itemName,
    'amount': amount,
    'rule': rule.toJson(),
    'accountId': accountId,
  };
}
