class User {
  final String? id;
  final String? companyId;
  final int? createdDate;
  final String? firstName;
  final String? lastName;
  final String? phone;
  final String? email;

  User({
    this.id,
    this.companyId,
    this.createdDate,
    this.firstName,
    this.lastName,
    this.phone,
    this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      companyId: json['companyId'],
      createdDate: json['createdDate'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phone: json['phone'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() => {
    if (id != null) 'id': id,
    if (companyId != null) 'companyId': companyId,
    if (createdDate != null) 'createdDate': createdDate,
    if (firstName != null) 'firstName': firstName,
    if (lastName != null) 'lastName': lastName,
    if (phone != null) 'phone': phone,
    if (email != null) 'email': email,
  };
}
