class User {
  final String id;
  final String? username;
  final String? companyId;

  User({
    required this.id, // only required field
    this.username,
    this.companyId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'],
      companyId: json['companyId'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (username != null) 'username': username,
    if (companyId != null) 'companyId': companyId,
  };
}
