import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/pricing.dart';
import '../service_configurations.dart';

class PricingAPI {
  static final String baseUrl = '${ApiSettings.apiBaseUrl}/pricing';

  /// Get all prices for a specific company
  /// Endpoint: GET /prices/company/:companyId
  /// Response: 200 [Price] | 400/404/500 generic error text
  static Future<List<Pricing>?> getPricesByCompanyId(String companyId) async {
    if (companyId.isEmpty) {
      debugPrint("Company ID is required to fetch prices.");
      return null;
    }

    final uri = Uri.parse('$baseUrl/company/$companyId');
    debugPrint("Fetching prices for company ID: $companyId");

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
          debugPrint("Unexpected prices response format.");
          return null;
        }
      } else if (response.statusCode == 404) {
        debugPrint("Prices not found for company (404).");
        return [];
      } else {
        debugPrint("Failed to fetch prices. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching prices: $e");
      return null;
    }
  }

  /// Creates or sets multiple prices
  /// Endpoint: PUT /prices
  /// Request: [Price] (array of prices)
  /// Response: 204 | 400/500 generic error text
  static Future<bool> putPrices(List<Pricing> prices) async {
    if (prices.isEmpty) {
      debugPrint("At least one price is required.");
      return false;
    }

    final uri = Uri.parse(baseUrl);
    
    // Convert prices to JSON array
    final List<Map<String, dynamic>> pricesJson = prices.map((p) => p.toJson()).toList();

    debugPrint("Putting prices: ${jsonEncode(pricesJson)}");

    try {
      final response = await http.put(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(pricesJson),
      );

      if (response.statusCode == 204) {
        debugPrint("Prices updated successfully.");
        return true;
      } else {
        debugPrint("Failed to put prices. ${response.statusCode} - ${response.body}");
        return false;
      }
    } catch (e) {
      debugPrint("Error putting prices: $e");
      return false;
    }
  }

  // Legacy methods for backwards compatibility - deprecated
  /// @deprecated Use getPricesByCompanyId instead
  static Future<List<Pricing>?> getPricingByAccountId(String accountId) async {
    debugPrint("Warning: getPricingByAccountId is deprecated. Use getPricesByCompanyId with companyId instead.");
    // This method is kept for backwards compatibility but should be replaced
    return getPricesByCompanyId(accountId);
  }

  /// @deprecated Use putPrices instead
  static Future<Pricing?> updatePricing(Pricing pricing) async {
    debugPrint("Warning: updatePricing is deprecated. Use putPrices instead.");
    final success = await putPrices([pricing]);
    return success ? pricing : null;
  }

  /// @deprecated Use putPrices instead
  static Future<Pricing?> createPricing(Pricing pricing) async {
    debugPrint("Warning: createPricing is deprecated. Use putPrices instead.");
    final success = await putPrices([pricing]);
    if (success) {
      return pricing;
    }
    return null;
  }
}

