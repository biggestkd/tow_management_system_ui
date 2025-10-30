import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/metric.dart';
import '../service_configurations.dart';

class MetricsAPI {
  static final String baseUrl = '${ApiSettings.apiBaseUrl}/metrics';

  /// Get all metrics for a specific company
  /// Endpoint: GET /metrics/:companyId
  /// Response: 200 [Metric] | 400/404 error text
  static Future<List<Metric>?> getMetricsForCompany(String companyId) async {
    if (companyId.isEmpty) {
      debugPrint("Company ID is required to fetch metrics.");
      return null;
    }

    final uri = Uri.parse('$baseUrl/$companyId');
    debugPrint("Fetching metrics for company ID: $companyId");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);

        if (decodedBody is List) {
          return decodedBody.map((item) => Metric.fromJson(item)).toList();
        } else {
          debugPrint("Unexpected metrics response format.");
          return null;
        }
      } else if (response.statusCode == 404) {
        debugPrint("Metrics not found for company (404).");
        return null;
      } else {
        debugPrint("Failed to fetch metrics. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching metrics: $e");
      return null;
    }
  }
}
