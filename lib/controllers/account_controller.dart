import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/models/company.dart';
import 'package:tow_management_system_ui/models/pricing.dart';
import 'package:tow_management_system_ui/models/user.dart';
import 'package:tow_management_system_ui/services/pricing_api.dart';
import 'package:tow_management_system_ui/services/company_api_service.dart';
import 'package:tow_management_system_ui/services/user_api_service.dart';
import 'package:tow_management_system_ui/services/payments_api.dart';
import 'package:tow_management_system_ui/service_configurations.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AccountController {
  /// Loads prices for a specific company
  /// Returns List<Pricing> on success, null on failure
  static Future<List<Pricing>?> loadPrices(String companyId) async {
    try {
      debugPrint("Account_Controller.loadPrices called for company ID: $companyId");
      
      if (companyId.isEmpty) {
        debugPrint("Company ID is required to load prices");
        return null;
      }

      final prices = await PricingAPI.getPricesByCompanyId(companyId);
      
      if (prices != null) {
        debugPrint("Loaded ${prices.length} price(s) successfully");
      } else {
        debugPrint("Failed to load prices");
      }
      
      return prices;
    } catch (e) {
      debugPrint("Error in loadPrices: $e");
      return null;
    }
  }

  /// Loads user information by user ID
  /// Returns User on success, null on failure
  static Future<User?> loadUserInformation(String userId) async {
    try {
      debugPrint("Account_Controller.loadUserInformation called for user ID: $userId");
      
      if (userId.isEmpty) {
        debugPrint("User ID is required to load user information");
        return null;
      }

      final user = await UserAPI.getUser(userId);
      
      if (user != null) {
        debugPrint("User information loaded successfully");
      } else {
        debugPrint("Failed to load user information");
      }
      
      return user;
    } catch (e) {
      debugPrint("Error in loadUserInformation: $e");
      return null;
    }
  }

  /// Loads company information by company ID
  /// Returns Company on success, null on failure
  static Future<Company?> loadCompanyInformation(String companyId) async {
    try {
      debugPrint("Account_Controller.loadCompanyInformation called for company ID: $companyId");
      
      if (companyId.isEmpty) {
        debugPrint("Company ID is required to load company information");
        return null;
      }

      final company = await CompanyAPI.getCompanyById(companyId);
      
      if (company != null) {
        debugPrint("Company information loaded successfully: ${company.name}");
      } else {
        debugPrint("Failed to load company information");
      }
      
      return company;
    } catch (e) {
      debugPrint("Error in loadCompanyInformation: $e");
      return null;
    }
  }

  /// Updates prices for the account
  /// Returns error message if there were issues, otherwise null for success
  static Future<String?> updatePrices(List<Pricing> prices) async {
    try {
      debugPrint("Account_Controller.updatePrices called with ${prices.length} price(s)");
      
      if (prices.isEmpty) {
        return "At least one price is required";
      }

      final success = await PricingAPI.putPrices(prices);
      
      if (success) {
        debugPrint("Prices updated successfully");
        return null; // Success
      } else {
        return "Failed to update prices";
      }
    } catch (e) {
      debugPrint("Error in updatePrices: $e");
      return "Error updating prices: $e";
    }
  }

  /// Saves company information
  /// Returns error message if there were issues, otherwise null for success
  static Future<String?> saveCompanyInformation(Company company) async {
    try {
      debugPrint("Account_Controller.saveCompanyInformation called");
      
      if (company.id == null || company.id!.isEmpty) {
        return "Company ID is required to save company information";
      }

      final updatedCompany = await CompanyAPI.updateCompany(company);
      
      if (updatedCompany != null) {
        debugPrint("Company information saved successfully");
        return null; // Success
      } else {
        return "Failed to save company information";
      }
    } catch (e) {
      debugPrint("Error in saveCompanyInformation: $e");
      return "Error saving company information: $e";
    }
  }

  /// Saves contact information (user)
  /// Returns error message if there were issues, otherwise null for success
  static Future<String?> saveContactInformation(User user) async {
    try {
      debugPrint("Account_Controller.saveContactInformation called");
      
      if (user.id == null || user.id!.isEmpty) {
        return "User ID is required to save contact information";
      }

      final updatedUser = await UserAPI.updateUser(user);
      
      if (updatedUser != null) {
        debugPrint("Contact information saved successfully");
        return null; // Success
      } else {
        return "Failed to save contact information";
      }
    } catch (e) {
      debugPrint("Error in saveContactInformation: $e");
      return "Error saving contact information: $e";
    }
  }

  /// Navigates to Stripe dashboard for payment account management
  /// Opens the Stripe dashboard link in a new tab
  static Future<void> navigateToStripeDashboard(String companyId) async {
    try {
      debugPrint("Account_Controller.navigateToStripeDashboard called for company ID: $companyId");
      
      if (companyId.isEmpty) {
        debugPrint("Company ID is required to navigate to Stripe dashboard");
        return;
      }

      final returnURL = '${ApiSettings.uiBaseUrl}/dashboard';
      final refreshURL = '${ApiSettings.uiBaseUrl}/';

      final url = await PaymentsAPI.postPaymentAccount(
        companyId,
        returnURL,
        refreshURL,
      );

      if (url != null && url.isNotEmpty) {
        debugPrint("Opening Stripe dashboard URL in new tab");
        await launchUrlString(url, webOnlyWindowName: '_blank');
      } else {
        debugPrint("Failed to generate Stripe dashboard URL");
      }
    } catch (e) {
      debugPrint("Error in navigateToStripeDashboard: $e");
    }
  }
}
