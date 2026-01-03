import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../service_configurations.dart';

class LocationAPI {
  static final String baseUrl = '${ApiSettings.apiBaseUrl}/locations';

  /// Get addresses for a given address query
  /// Endpoint: GET /locations/suggest?query={address}
  /// Response: 200 {"suggestions": [String]} | other -> []
  static Future<List<String>> getAddresses(String address) async {
    if (address.isEmpty) {
      debugPrint("Address is required to fetch addresses.");
      return [];
    }

    final uri = Uri.parse('$baseUrl/suggest').replace(queryParameters: {'query': address});
    debugPrint("Fetching addresses for: $address");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);

        if (decodedBody is Map<String, dynamic> && decodedBody.containsKey('suggestions')) {
          final suggestions = decodedBody['suggestions'];
          if (suggestions is List) {
            return suggestions.map((e) => e.toString()).toList();
          } else {
            debugPrint("Unexpected suggestions format: $suggestions");
            return [];
          }
        } else {
          debugPrint("Unexpected response format: $decodedBody");
          return [];
        }
      } else if (response.statusCode == 404) {
        debugPrint("No addresses found (404).");
        return [];
      } else {
        debugPrint(
          "Failed to fetch addresses. ${response.statusCode} - ${response.body}",
        );
        return [];
      }
    } catch (e) {
      debugPrint("Error fetching addresses: $e");
      return [];
    }
  }
}

