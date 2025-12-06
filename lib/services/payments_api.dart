import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../service_configurations.dart';

class PaymentsAPI {
  static final String baseUrl = '${ApiSettings.apiBaseUrl}/payments';

  /// Get payment account for a specific company
  /// Endpoint: GET /payments/account/:companyId
  /// Response: 200 Stripe Account | 400 invalid request | 404 not found
  static Future<Map<String, dynamic>?> getPaymentAccount(String companyId) async {
    if (companyId.isEmpty) {
      debugPrint("Company ID is required.");
      return null;
    }

    final uri = Uri.parse('$baseUrl/account/$companyId');
    debugPrint("Fetching payment account for company ID: $companyId");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        debugPrint("Payment account retrieved successfully.");
        return decodedBody as Map<String, dynamic>;
      } else if (response.statusCode == 400) {
        debugPrint("Invalid request for payment account (400).");
        return null;
      } else if (response.statusCode == 404) {
        debugPrint("Company not found for payment account (404).");
        return null;
      } else {
        debugPrint("Failed to fetch payment account. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching payment account: $e");
      return null;
    }
  }

  /// Generate dashboard link for payment account
  /// Endpoint: POST /payments/account/:companyId
  /// Request Body: { "returnURL": "...", "refreshURL": "..." }
  /// Response: 200 { "url": "..." } | 400 invalid request | 404 not found
  static Future<String?> postPaymentAccount(String companyId, String returnURL, String refreshURL,) async {
    if (companyId.isEmpty) {
      debugPrint("Company ID is required.");
      return null;
    }

    if (returnURL.isEmpty || refreshURL.isEmpty) {
      debugPrint("Return URL and Refresh URL are required.");
      return null;
    }

    final uri = Uri.parse('$baseUrl/account/$companyId');
    debugPrint("Generating dashboard link for company ID: $companyId");

    try {
      final requestBody = jsonEncode({
        'returnURL': returnURL,
        'refreshURL': refreshURL,
      });

      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
        final url = decodedBody['url'] as String?;
        if (url != null && url.isNotEmpty) {
          debugPrint("Dashboard link generated successfully.");
          return url;
        } else {
          debugPrint("Missing URL in response.");
          return null;
        }
      } else if (response.statusCode == 400) {
        debugPrint("Invalid request for payment account dashboard link (400).");
        return null;
      } else if (response.statusCode == 404) {
        debugPrint(
            "Company not found for payment account dashboard link (404).");
        return null;
      } else {
        debugPrint("Failed to generate dashboard link. ${response
            .statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error generating dashboard link: $e");
      return null;
    }
  }

  /// Get total amount for a tow request
  /// Endpoint: GET /payments/total/:companyId?pickup=...&destination=...
  /// Response: 200 { "total": int } | 400 invalid request | 404 not found
  static Future<int?> getTotalAmount(String companyId, String pickup, String destination) async {
    if (companyId.isEmpty) {
      debugPrint("Company ID is required.");
      return null;
    }

    if (pickup.isEmpty || destination.isEmpty) {
      debugPrint("Pickup and destination are required.");
      return null;
    }

    final uri = Uri.parse('$baseUrl/total/$companyId').replace(
      queryParameters: {
        'pickup': pickup,
        'destination': destination,
      },
    );
    debugPrint("Fetching total amount for company ID: $companyId, pickup: $pickup, destination: $destination");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body) as Map<String, dynamic>;
        final total = decodedBody['total'];
        if (total != null) {
          // Handle both int and string representations of integers
          final totalInt = total is int ? total : int.tryParse(total.toString());
          if (totalInt != null) {
            debugPrint("Total amount retrieved successfully: $totalInt");
            return totalInt;
          } else {
            debugPrint("Invalid total format in response.");
            return null;
          }
        } else {
          debugPrint("Missing total field in response.");
          return null;
        }
      } else if (response.statusCode == 400) {
        debugPrint("Invalid request for total amount (400).");
        return null;
      } else if (response.statusCode == 404) {
        debugPrint("Company not found for total amount (404).");
        return null;
      } else {
        debugPrint("Failed to fetch total amount. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching total amount: $e");
      return null;
    }
  }

}

