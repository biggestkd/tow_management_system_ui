class Account {
  final String id;
  final String companyInformation;
  final String stripeAccountId;

  Account({
    required this.id,
    required this.companyInformation,
    this.stripeAccountId = '',
  });

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      id: json['id'] ?? '',
      companyInformation: json['companyInformation'] ?? '',
      stripeAccountId: json['stripeAccountId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'companyInformation': companyInformation,
    'stripeAccountId': stripeAccountId,
  };
}
