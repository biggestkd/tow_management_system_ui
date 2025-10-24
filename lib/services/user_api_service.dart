import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';
import '../service_configurations.dart';

class UserAPI {
  static final String baseUrl = '${ApiSettings.apiBaseUrl}/user';

  /// Create a new user
  static Future<User?> createUser(User user) async {
    final uri = Uri.parse(baseUrl);

    debugPrint("Creating user: ${jsonEncode(user.toJson())}");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 201) {
      debugPrint("User created successfully.");
      return user;
    } else {
      debugPrint("Failed to create user. ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  /// Get a user by ID
  static Future<User?> getUser(String userId) async {
    final uri = Uri.parse('$baseUrl/$userId');

    debugPrint("Fetching user: $userId");

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      debugPrint("User fetched successfully.");
      final decodedBody = jsonDecode(response.body);
      return User.fromJson(decodedBody);
    } else {
      debugPrint("Failed to fetch user. ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  /// Update an existing user
  static Future<User?> updateUser(User user) async {
    final uri = Uri.parse('$baseUrl/${user.id}');

    debugPrint("Updating user: ${jsonEncode(user.toJson())}");

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(user.toJson()),
    );

    if (response.statusCode == 204) {
      debugPrint("User updated successfully.");
      return user;
    } else {
      debugPrint("Failed to update user. ${response.statusCode} - ${response.body}");
      return null;
    }
  }
}
