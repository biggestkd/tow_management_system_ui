import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/company.dart';
import '../service_configurations.dart';

class CompanyAPI {
  static final String baseUrl = '${ApiSettings.apiBaseUrl}/company';

  /// Create a new company
  static Future<Company?> createCompany(Company company) async {
    final uri = Uri.parse(baseUrl);

    debugPrint("Creating company: ${jsonEncode(company.toJson())}");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(company.toJson()),
    );

    if (response.statusCode == 201) {
      debugPrint("Company created successfully.");
      final decodedBody = jsonDecode(response.body);
      return Company.fromJson(decodedBody);
    } else {
      debugPrint("Failed to create company. ${response.statusCode} - ${response.body}");
      return null;
    }
  }
}
