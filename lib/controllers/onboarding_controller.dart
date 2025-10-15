import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/models/user.dart';

class OnboardingController {

  /// Attempts to create an account with the identity provider
  static Future<User?> signUpWithEmailAndPassword(email, password) async {

  }

  /// Attempts to finalize account creation with identity provider
  static Future<User?> validateConfirmationCode(confirmationCode) async {

  }

  /// Attempts to create a new Tow Pro account using the onboarding information plus
  /// will attempt to create a new user account using the userId from identity provider and newly
  /// created account id
  static Future<User?> completeAccountCreation(userId, companyName, phone, address) async {

  }


}
