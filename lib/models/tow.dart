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
  };
}
