import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/models/user.dart';

class OnboardingController {

  /// Attempts to create an account with the identity provider
  /// returns the userId/username of the new account
  static Future<String?> signUpWithEmailAndPassword(email, password) async {

    try {

      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
      );

      return result.userId;

    } on AuthException catch (e) {
      safePrint('Error signing up: ${e.message}');
    }

    return null;
  }

  /// Attempts to finalize account creation with identity provider
  /// and sign in the user with valid credentials
  static Future<void> validateConfirmationCode(userId, confirmationCode, email, password) async {
    try {

      await Amplify.Auth.confirmSignUp(
        username: userId,
        confirmationCode: confirmationCode,
      );

      await Amplify.Auth.signIn(username: email, password: password);

      // Create the user account here by hitting UserApi.create(userId, email)

    } on AuthException catch (e) {
      safePrint('Error confirming user: ${e.message}');
    }
  }

  /// Attempts to create a new Tow Pro account using the onboarding information and
  /// create a new user account using the userId from identity provider and newly
  static Future<User?> completeAccountCreation(userId, companyName, phone, address) async {
    // CompanyApi.create
    // Create account for the company with the company name
    // Create a user account using the current information
    // Should the UI care what is being done in the background to create the account? No
    // UI wants to share the form information and expects an account id to be returned
    // This controller especially is not concerned with the business logic
    // This is an API design consideration. Should APIs be doing multiple things? Should
    // the account API update something with the user API
    // What happens if the client is in an area with low bandwidth? 2 steps and seperate APIs
    // will lead to multiple
    // User API is different than the
    // Company API
    // let the controller be responsible for doing both 1. Create the Account and wait for a response
    // 2. Create a new User with the account ID, email, username,
  }


}
