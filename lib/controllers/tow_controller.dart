import 'package:flutter/foundation.dart';
import '../models/tow.dart';
import '../services/tow_api.dart';

class TowController {

  /// Loads a Tow by its ID using TowAPI
  static Future<Tow?> loadTowData(String towId) async {
    if (towId.isEmpty) {
      debugPrint("No towId provided to loadTowData.");
      return null;
    }

    try {
      debugPrint("Loading tow with ID: $towId");
      final tow = await TowAPI.getTowById(towId);
      if (tow == null) {
        debugPrint("Tow not found or failed to load.");
      }
      return tow;
    } catch (e) {
      debugPrint("Error loading tow: $e");
      return null;
    }
  }

  /// Saves a Tow using TowAPI (PUT). Returns true on success, false otherwise.
  static Future<bool> saveTowData(Tow tow) async {
    try {
      final updated = await TowAPI.putTow(tow);
      final success = updated != null;
      if (!success) {
        debugPrint("Failed to save tow.");
      }
      return success;
    } catch (e) {
      debugPrint("Error saving tow: $e");
      return false;
    }
  }

  /// Updates a tow's status using TowAPI (PUT). Returns true on success, false otherwise.
  static Future<bool> updateTowStatus(String towId, String status) async {
    if (towId.isEmpty) {
      debugPrint("No towId provided to updateTowStatus.");
      return false;
    }

    try {
      debugPrint("Updating tow status: $towId to $status");
      // Create a minimal Tow object with just the id and status
      final tow = Tow(
        id: towId,
        status: status,
      );
      
      final updated = await TowAPI.putTow(tow);
      final success = updated != null;
      if (!success) {
        debugPrint("Failed to update tow status.");
      } else {
        debugPrint("Tow status updated successfully.");
      }
      return success;
    } catch (e) {
      debugPrint("Error updating tow status: $e");
      return false;
    }
  }
}


