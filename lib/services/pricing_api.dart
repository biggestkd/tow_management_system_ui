import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/pricing.dart';
import '../service_configurations.dart';

class PricingAPI {
  static final String baseUrl = '${ApiSettings.apiBaseUrl}/pricing';

  /// Get all pricing for a specific account
  /// Endpoint: GET /pricing/account/:accountId
  /// Response: 200 [Pricing] | 400/404 error text
  static Future<List<Pricing>?> getPricingByAccountId(String accountId) async {
    if (accountId.isEmpty) {
      debugPrint("Account ID is required to fetch pricing.");
      return null;
    }

    final uri = Uri.parse('$baseUrl/account/$accountId');
    debugPrint("Fetching pricing for account ID: $accountId");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);

        if (decodedBody is List) {
          return decodedBody.map((item) => Pricing.fromJson(item)).toList();
        } else {
          debugPrint("Unexpected pricing response format.");
          return null;
        }
      } else if (response.statusCode == 404) {
        debugPrint("Pricing not found for account (404).");
        return [];
      } else {
        debugPrint("Failed to fetch pricing. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching pricing: $e");
      return null;
    }
  }

  /// Update an existing pricing item
  /// Endpoint: PUT /pricing/:id
  /// Response: 204 | error text
  static Future<Pricing?> updatePricing(Pricing pricing) async {
    final uri = Uri.parse('$baseUrl/${pricing.id}');

    debugPrint("Updating pricing: ${jsonEncode(pricing.toJson())}");

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(pricing.toJson()),
    );

    if (response.statusCode == 204 || response.statusCode == 200) {
      debugPrint("Pricing updated successfully.");
      return pricing;
    } else {
      debugPrint("Failed to update pricing. ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  /// Create a new pricing item
  /// Endpoint: POST /pricing
  /// Response: 201 | error text
  static Future<Pricing?> createPricing(Pricing pricing) async {
    final uri = Uri.parse(baseUrl);

    // Create JSON without id if it's empty (backend will generate)
    final Map<String, dynamic> jsonToSend = {
      'itemName': pricing.itemName,
      'amount': pricing.amount,
      'rule': pricing.rule.toJson(),
      'accountId': pricing.accountId,
    };
    
    if (pricing.id.isNotEmpty) {
      jsonToSend['id'] = pricing.id;
    }

    debugPrint("Creating pricing: ${jsonEncode(jsonToSend)}");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(jsonToSend),
    );

    if (response.statusCode == 201) {
      debugPrint("Pricing created successfully.");
      final decodedBody = jsonDecode(response.body);
      return Pricing.fromJson(decodedBody);
    } else {
      debugPrint("Failed to create pricing. ${response.statusCode} - ${response.body}");
      return null;
    }
  }
}

