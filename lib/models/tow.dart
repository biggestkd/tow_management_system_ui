import 'vehicle.dart';
import 'primary_contact.dart';

class Tow {
  final String? id;
  final String? destination;
  final String? pickup;
  final Vehicle? vehicle;
  final PrimaryContact? primaryContact;
  final List<String>? attachments;
  final String? notes;
  final List<String>? history;
  final String? status; // pending, accepted, dispatched, arrived_pickup, in_transit, completed, cancelled
  final String? companyId;
  final int? createdAt; // Unix timestamp (int64 in Go)
  final int? price;

  Tow({
    this.id,
    this.destination,
    this.pickup,
    this.vehicle,
    this.primaryContact,
    this.attachments,
    this.notes,
    this.history,
    this.status,
    this.companyId,
    this.createdAt,
    this.price,
  });

  factory Tow.fromJson(Map<String, dynamic> json) {
    return Tow(
      id: json['id'],
      destination: json['destination'],
      pickup: json['pickup'],
      vehicle: _parseVehicle(json['vehicle']),
      primaryContact: json['primaryContact'] != null
          ? PrimaryContact.fromJson(json['primaryContact'] as Map<String, dynamic>)
          : null,
      attachments: json['attachments'] != null
          ? List<String>.from(json['attachments'])
          : [],
      notes: json['notes'],
      history: json['history'] != null
          ? List<String>.from(json['history'])
          : [],
      status: json['status'],
      companyId: json['companyId'],
      createdAt: json['createdAt'] is int
          ? json['createdAt']
          : int.tryParse(json['createdAt']?.toString() ?? ''),
      price: json['price'] is int
          ? json['price']
          : int.tryParse(json['price']?.toString() ?? ''),
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (destination != null) 'destination': destination,
    if (pickup != null) 'pickup': pickup,
    if (vehicle != null) 'vehicle': vehicle!.toJson(),
    if (primaryContact != null) 'primaryContact': primaryContact!.toJson(),
    if (attachments != null) 'attachments': attachments,
    if (notes != null) 'notes': notes,
    if (history != null) 'history': history,
    if (status != null) 'status': status,
    if (companyId != null) 'companyId': companyId,
    if (createdAt != null) 'createdAt': createdAt,
    if (price != null) 'price': price,
  };

  /// Optional helper to convert Unix timestamp to DateTime
  DateTime? get createdAtDate =>
      createdAt != null ? DateTime.fromMillisecondsSinceEpoch(createdAt! * 1000) : null;

  static Vehicle? _parseVehicle(dynamic raw) {
    if (raw == null) return null;
    if (raw is Map<String, dynamic>) return Vehicle.fromJson(raw);
    // Backward-compat: accept a single string like "2020 Toyota Camry"
    if (raw is String) {
      final parts = raw.trim().split(RegExp(r'\s+'));
      if (parts.length >= 3) {
        return Vehicle(year: parts[0], make: parts[1], model: parts.sublist(2).join(' '));
      }
      if (parts.length == 2) {
        return Vehicle(make: parts[0], model: parts[1]);
      }
      return Vehicle(model: raw);
    }
    return null;
  }
}
