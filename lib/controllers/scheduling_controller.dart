import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/tow.dart';
import '../models/vehicle.dart';
import '../service_configurations.dart';
import '../services/tow_api.dart';
import '../services/location_api.dart';
import '../services/payments_api.dart';

class SchedulingController {

  /// Submits a completed request for scheduling a tow.
  /// Returns the created Tow object on success, null on failure.
  static Future<Tow?> submitTowRequest({required String pickup, String? destination, Vehicle? vehicle, String? primaryContact, String? companyId,}) async {
    if (pickup.trim().isEmpty) {
      debugPrint("Pickup location is required to submit tow request.");
      return null;
    }

    try {
      // Build the tow object
      final tow = Tow(
        pickup: pickup.trim(),
        destination: destination?.trim().isEmpty == true ? null : destination?.trim(),
        vehicle: vehicle,
        primaryContact: primaryContact?.trim().isEmpty == true ? null : primaryContact?.trim(),
        status: 'pending',
        companyId: companyId,
      );

      debugPrint("Submitting tow request: ${tow.toJson()}");

      final created = await TowAPI.postTow(tow);
      
      if (created != null) {
        debugPrint("Tow request submitted successfully.");
        return created;
      } else {
        debugPrint("Failed to submit tow request.");
        return null;
      }
    } catch (e) {
      debugPrint("Error submitting tow request: $e");
      return null;
    }
  }

  /// Autocompletes addresses based on partial input.
  /// Returns a list of suggested addresses.
  static Future<List<String>> getAddressOptions(String query) async {
    if (query.trim().isEmpty) {
      return [];
    }

    try {
      final response = await LocationAPI.getAddresses(query.trim());
      
      if (response == null) {
        return [];
      }

      // Response is always a list of strings
      if (response is List) {
        return response.cast<String>();
      }

      debugPrint("Unexpected address response format: $response");
      return [];
    } catch (e) {
      debugPrint("Error autocompleting address: $e");
      return [];
    }
  }

  /// Calculates the tow price based on pickup, dropoff, and company ID.
  /// Returns the calculated price in cents, or 0 if calculation fails.
  static Future<int> calculateTowPrice({required String pickup, required String dropoff, required String companyId,}) async {
    if (pickup.trim().isEmpty || dropoff.trim().isEmpty || companyId.trim().isEmpty) {
      debugPrint("Pickup, dropoff, and companyId are required for price calculation.");
      return 0;
    }

    try {
      final total = await PaymentsAPI.getTotalAmount(
        companyId.trim(),
        pickup.trim(),
        dropoff.trim(),
      );

      if (total != null) {
        return total;
      } else {
        debugPrint("Failed to calculate tow price.");
        return 0;
      }
    } catch (e) {
      debugPrint("Error calculating tow price: $e");
      return 0;
    }
  }

}

