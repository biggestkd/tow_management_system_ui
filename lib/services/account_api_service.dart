import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/account.dart';
import '../service_configurations.dart';

class AccountAPI {
  static final String baseUrl = '${ApiSettings.apiBaseUrl}/account';

  /// Get an account by its ID
  static Future<Account?> getAccountById(String accountId) async {
    if (accountId.isEmpty) {
      debugPrint("Account ID is required.");
      return null;
    }

    final uri = Uri.parse('$baseUrl/$accountId');
    debugPrint("Fetching account with ID: $accountId");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        return Account.fromJson(decodedBody);
      } else if (response.statusCode == 404) {
        debugPrint("Account not found (404).");
        return null;
      } else {
        debugPrint("Failed to fetch account. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching account: $e");
      return null;
    }
  }

  /// Get account by company ID
  static Future<Account?> getAccountByCompanyId(String companyId) async {
    if (companyId.isEmpty) {
      debugPrint("Company ID is required.");
      return null;
    }

    final uri = Uri.parse('$baseUrl/company/$companyId');
    debugPrint("Fetching account for company ID: $companyId");

    try {
      final response = await http.get(
        uri,
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decodedBody = jsonDecode(response.body);
        return Account.fromJson(decodedBody);
      } else if (response.statusCode == 404) {
        debugPrint("Account not found for company (404).");
        return null;
      } else {
        debugPrint("Failed to fetch account. ${response.statusCode} - ${response.body}");
        return null;
      }
    } catch (e) {
      debugPrint("Error fetching account: $e");
      return null;
    }
  }

  /// Update an existing account
  static Future<Account?> updateAccount(Account account) async {
    if (account.id.isEmpty) {
      debugPrint("Account ID is required for update.");
      return null;
    }

    final uri = Uri.parse('$baseUrl/${account.id}');
    debugPrint("Updating account: ${jsonEncode(account.toJson())}");

    final response = await http.put(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(account.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      debugPrint("Account updated successfully.");
      if (response.statusCode == 200 && response.body.isNotEmpty) {
        final decodedBody = jsonDecode(response.body);
        return Account.fromJson(decodedBody);
      }
      return account;
    } else {
      debugPrint("Failed to update account. ${response.statusCode} - ${response.body}");
      return null;
    }
  }

  /// Create a new account
  static Future<Account?> createAccount(Account account) async {
    final uri = Uri.parse(baseUrl);

    debugPrint("Creating account: ${jsonEncode(account.toJson())}");

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(account.toJson()),
    );

    if (response.statusCode == 201) {
      debugPrint("Account created successfully.");
      final decodedBody = jsonDecode(response.body);
      return Account.fromJson(decodedBody);
    } else {
      debugPrint("Failed to create account. ${response.statusCode} - ${response.body}");
      return null;
    }
  }
}

