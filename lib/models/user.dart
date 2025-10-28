class User {
  final String id;
  final String? username;
  final String? companyId;
  final String? displayName;
  final String? avatarUrl;

  User({
    required this.id, // only required field
    this.username,
    this.companyId,
    this.displayName,
    this.avatarUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      username: json['username'],
      companyId: json['companyId'],
      displayName: json['displayName'],
      avatarUrl: json['avatarUrl'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    if (username != null) 'username': username,
    if (companyId != null) 'companyId': companyId,
    if (displayName != null) 'displayName': displayName,
    if (avatarUrl != null) 'avatarUrl': avatarUrl,
  };
}
