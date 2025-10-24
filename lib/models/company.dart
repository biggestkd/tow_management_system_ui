class Company {
  final String? id;
  final String companyName;
  final String? website;
  final String? status;
  final String? street;
  final String? city;
  final String? zipCode;
  final String? state;
  final String? phoneNumber;

  Company({
    this.id,
    required this.companyName,
    this.website,
    this.status,
    this.street,
    this.city,
    this.zipCode,
    this.state,
    this.phoneNumber,
  });

  /// Factory method to create a Company from JSON
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'] ?? json['id'],
      companyName: json['companyName'] ?? '',
      website: json['website'],
      status: json['status'],
      street: json['street'],
      city: json['city'],
      zipCode: json['zipCode'],
      state: json['state'],
      phoneNumber: json['phoneNumber'],
    );
  }

  /// Convert a Company object into JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'companyName': companyName,
      if (website != null) 'website': website,
      if (status != null) 'status': status,
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (zipCode != null) 'zipCode': zipCode,
      if (state != null) 'state': state,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
    };
  }

  @override
  String toString() {
    return 'Company(companyName: $companyName, city: $city, state: $state, status: $status)';
  }
}
