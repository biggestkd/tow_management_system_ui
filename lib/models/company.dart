class Company {
  final String? id;
  final String name;
  final String? website;
  final String? status;
  final String? street;
  final String? city;
  final String? zipCode;
  final String? state;
  final String? phoneNumber;
  final String? schedulingLink;

  Company({
    this.id,
    required this.name,
    this.website,
    this.status,
    this.street,
    this.city,
    this.zipCode,
    this.state,
    this.phoneNumber,
    this.schedulingLink,
  });

  /// Factory method to create a Company from JSON
  factory Company.fromJson(Map<String, dynamic> json) {
    return Company(
      id: json['_id'] ?? json['id'],
      name: json['name'],
      website: json['website'],
      status: json['status'],
      street: json['street'],
      city: json['city'],
      zipCode: json['zipCode'],
      state: json['state'],
      phoneNumber: json['phoneNumber'],
      schedulingLink: json['schedulingLink'],
    );
  }

  /// Convert a Company object into JSON
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (website != null) 'website': website,
      if (status != null) 'active': status,
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (zipCode != null) 'zipCode': zipCode,
      if (state != null) 'state': state,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (schedulingLink != null) 'schedulingLink': schedulingLink,
    };
  }

  @override
  String toString() {
    return 'Company(name: $name, city: $city, state: $state, active: $status)';
  }
}
