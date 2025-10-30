import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/models/company.dart';
import 'package:tow_management_system_ui/models/user.dart';
import 'package:tow_management_system_ui/services/company_api_service.dart';
import 'package:tow_management_system_ui/services/user_api_service.dart';

import '../models/metric.dart';
import '../services/metric_api.dart';

class DashboardController {

  /// Attempts to grab the current user's from Amplify
  static Future<User?> loadUser() async {
    try {
      var authUser = await Amplify.Auth.getCurrentUser();

      var user = UserAPI.getUser(authUser.userId);

      return user;

    } on SignedOutException {
      safePrint("Signed Out");
      return null;
    } catch (_) {
      safePrint("Issue pulling user");
      return null;
    }
  }

  /// Loads a Company by its ID using the CompanyAPI
  static Future<Company?> loadCompany(String? companyId) async {
    if (companyId == null || companyId.isEmpty) {
      debugPrint("No companyId provided to loadCompany.");
      return null;
    }

    try {
      debugPrint("Loading company with ID: $companyId");
      final company = await CompanyAPI.getCompanyById(companyId);

      if (company != null) {
        debugPrint("Company loaded successfully: ${company.name}");
      } else {
        debugPrint("Company not found or failed to load.");
      }

      return company;
    } catch (e) {
      debugPrint("Error loading company: $e");
      return null;
    }
  }

  /// Loads metrics for a specific company
  static Future<List<Metric>?> loadMetrics(String? companyId) async {
    if (companyId == null || companyId.isEmpty) {
      debugPrint("No companyId provided to loadMetrics.");
      return null;
    }

    try {
      debugPrint("Loading metrics for company ID: $companyId");
      final metrics = await MetricsAPI.getMetricsForCompany(companyId);

      if (metrics != null && metrics.isNotEmpty) {
        debugPrint("Metrics loaded successfully (${metrics.length} records).");
      } else {
        debugPrint("No metrics found for company ID: $companyId");
      }

      return metrics;
    } catch (e) {
      debugPrint("Error loading metrics: $e");
      return null;
    }
  }

}
