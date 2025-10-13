class User {
  final String id;
  final String username;
  final String accountId;

  User({
    required this.id,
    required this.username,
    required this.accountId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'] ?? '',
      accountId: json['accountId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'accountId': accountId,
  };
}
