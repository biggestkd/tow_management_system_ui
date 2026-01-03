import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/tow.dart';
import '../service_configurations.dart';

class TowAPI {
  static final String baseUrl = '${ApiSettings.apiBaseUrl}/tows/company';
  static final String towBaseUrl = '${ApiSettings.apiBaseUrl}/tows';

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
          return [];
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

  /// Get a tow by its ID
  /// Endpoint: GET /tows/:towId
  /// Response: 200 Tow | 404 null | other -> null
  static Future<Tow?> getTowById(String towId) async {
    if (towId.isEmpty) {
      debugPrint("Tow ID is required to fetch tow.");
      return null;
    }

    final uri = Uri.parse('$towBaseUrl/$towId');
    debugPrint("Fetching tow with ID: $towId");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        return Tow.fromJson(decodedBody);
      } else if (response.statusCode == 404) {
        debugPrint("Tow not found (404).");
        return null;
      } else {
        debugPrint("Failed to fetch tow. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching tow: $e");
      return null;
    }
  }

  /// Create a new tow
  /// Endpoint: POST /tows/:schedulingLink
  /// Response: 201 Tow | other -> null
  static Future<Tow?> postTow(Tow tow, String schedulingLink) async {
    final uri = Uri.parse('$towBaseUrl/$schedulingLink');
    debugPrint("Creating tow: ${jsonEncode(tow.toJson())}");

    try {
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tow.toJson()),
      );

      if (response.statusCode == 201) {
        // API typically returns the created tow with generated ID
        if (response.body.isNotEmpty) {
          final decodedBody = jsonDecode(response.body);
          return Tow.fromJson(decodedBody);
        }
        return tow;
      } else {
        debugPrint("Failed to create tow. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error creating tow: $e");
      return null;
    }
  }

  /// Update a tow by its ID
  /// Endpoint: PUT /tows/:towId
  /// Response: 200/204 Tow (echoed or persisted) | other -> null
  static Future<Tow?> putTow(Tow tow) async {
    if (tow.id == null || tow.id!.isEmpty) {
      debugPrint("Tow ID is required to update tow.");
      return null;
    }

    final uri = Uri.parse('$towBaseUrl/${tow.id}');
    debugPrint("Updating tow: ${jsonEncode(tow.toJson())}");

    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(tow.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        // Some APIs return the updated entity, some return no content.
        if (response.body.isNotEmpty) {
          final decodedBody = jsonDecode(response.body);
          return Tow.fromJson(decodedBody);
        }
        return tow;
      } else {
        debugPrint("Failed to update tow. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error updating tow: $e");
      return null;
    }
  }

  /// Get tow estimate based on pickup, dropoff, and company
  /// Endpoint: GET /tows/estimates?pickup=...&dropoff=...&company=...
  /// Response: 200 { "estimate": int } | other -> null
  /// Returns the estimate in cents, or null on failure
  static Future<int?> getTowEstimate({required String pickup, required String dropoff, required String company,}) async {
    if (pickup.trim().isEmpty || dropoff.trim().isEmpty || company.trim().isEmpty) {
      debugPrint("Pickup, dropoff, and company are required to get tow estimate.");
      return null;
    }

    final uri = Uri.parse('$towBaseUrl/estimates').replace(
      queryParameters: {
        'pickup': pickup.trim(),
        'dropoff': dropoff.trim(),
        'company': company.trim(),
      },
    );
    debugPrint("Fetching tow estimate for pickup: $pickup, dropoff: $dropoff, company: $company");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
          final estimate = decodedBody['estimate'];
          if (estimate != null) {
            // Handle both int and string representations of integers
            final estimateInt = estimate is int ? estimate : int.tryParse(estimate.toString());
            if (estimateInt != null) {
              debugPrint("Tow estimate retrieved successfully: $estimateInt");
              return estimateInt;
            } else {
              debugPrint("Invalid estimate format in response.");
              return null;
            }
          } else {
            debugPrint("Missing estimate field in response.");
            return null;
          }
        } else {
          debugPrint("Empty response body for tow estimate.");
          return null;
        }
      } else {
        debugPrint("Failed to fetch tow estimate. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching tow estimate: $e");
      return null;
    }
  }
}
