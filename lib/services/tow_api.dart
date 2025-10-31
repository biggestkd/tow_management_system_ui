import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/tow.dart';
import '../service_configurations.dart';

class TowAPI {
  static final String baseUrl = '${ApiSettings.apiBaseUrl}/tows/company';

  /// Get all tows for a specific company
  /// Endpoint: GET /company/:companyId/tows
  /// Response: 200 [Tow] | 400/404/500 error text
  static Future<List<Tow>?> getTowsByCompanyId(String companyId) async {
    if (companyId.isEmpty) {
      debugPrint("Company ID is required to fetch tows.");
      return null;
    }

    final uri = Uri.parse('$baseUrl/$companyId');
    debugPrint("Fetching tows for company ID: $companyId");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);

        if (decodedBody is List) {
          return decodedBody.map((item) => Tow.fromJson(item)).toList();
        } else {
          debugPrint("Unexpected tow response format.");
          return null;
        }
      } else if (response.statusCode == 404) {
        debugPrint("No tows found for company (404).");
        return null;
      } else {
        debugPrint("Failed to fetch tows. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching tows: $e");
      return null;
    }
  }
}
