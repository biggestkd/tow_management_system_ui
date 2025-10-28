class Tow {
  final String id;
  final String destination;
  final String pickup;
  final String vehicle;
  final String primaryContact;
  final List<String> attachments;
  final String notes;
  final List<String> history;
  final String status;
  final String checkoutUrl;
  final DateTime? createdAt;
  final double? price;

  Tow({
    required this.id,
    required this.destination,
    required this.pickup,
    required this.vehicle,
    required this.primaryContact,
    required this.attachments,
    required this.notes,
    required this.history,
    required this.status,
    required this.checkoutUrl,
    this.createdAt,
    this.price,
  });

  factory Tow.fromJson(Map<String, dynamic> json) {
    return Tow(
      id: json['id'] ?? '',
      destination: json['destination'] ?? '',
      pickup: json['pickup'] ?? '',
      vehicle: json['vehicle'] ?? '',
      primaryContact: json['primaryContact'] ?? '',
      attachments: List<String>.from(json['attachments'] ?? []),
      notes: json['notes'] ?? '',
      history: List<String>.from(json['history'] ?? []),
      status: json['status'] ?? '',
      checkoutUrl: json['checkoutUrl'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      price: json['price'] != null
          ? (json['price'] is num
          ? (json['price'] as num).toDouble()
          : double.tryParse(json['price'].toString()))
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'destination': destination,
    'pickup': pickup,
    'vehicle': vehicle,
    'primaryContact': primaryContact,
    'attachments': attachments,
    'notes': notes,
    'history': history,
    'status': status,
    'checkoutUrl': checkoutUrl,
    if (createdAt != null) 'createdAt': createdAt!.toIso8601String(),
    if (price != null) 'price': price,
  };
}
