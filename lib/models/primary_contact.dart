class PrimaryContact {
  final String? lastName;
  final String? firstName;
  final String? email;
  final String? phone;

  const PrimaryContact({
    this.lastName,
    this.firstName,
    this.email,
    this.phone,
  });

  factory PrimaryContact.fromJson(Map<String, dynamic> json) {
    return PrimaryContact(
      lastName: json['lastName']?.toString(),
      firstName: json['firstName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => {
    if (lastName != null) 'lastName': lastName,
    if (firstName != null) 'firstName': firstName,
    if (email != null) 'email': email,
    if (phone != null) 'phone': phone,
  };

  /// Helper to get full name
  String get fullName {
    final parts = [firstName, lastName]
        .where((p) => p != null && p!.trim().isNotEmpty)
        .map((p) => p!.trim())
        .toList();
    return parts.isEmpty ? '' : parts.join(' ');
  }

  /// Helper to check if contact has any data
  bool get isEmpty {
    return (lastName?.trim().isEmpty ?? true) &&
        (firstName?.trim().isEmpty ?? true) &&
        (email?.trim().isEmpty ?? true) &&
        (phone?.trim().isEmpty ?? true);
  }
}

