import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/models/company.dart';
import 'package:tow_management_system_ui/models/user.dart';
import 'package:tow_management_system_ui/services/company_api_service.dart';
import 'package:tow_management_system_ui/services/user_api_service.dart';

class DashboardController {

  /// Attempts to grab the current user's from Amplify
  static Future<User?> loadSignedIn() async {
    try {
      var authUser = await Amplify.Auth.getCurrentUser();

      var user = User(id: authUser.userId); // TODO: replace this line with a call to the USer API to get the user data

      return user;

    } on SignedOutException {
      safePrint("Signed Out");
      return null;
    } catch (_) {
      safePrint("Issue pulling user");
      return null;
    }
  }

  // load data
  // activeTows, completedTows, payoutAmount

  // getTowHistory


}
