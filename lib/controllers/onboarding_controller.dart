import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/models/company.dart';
import 'package:tow_management_system_ui/models/user.dart';
import 'package:tow_management_system_ui/services/company_api_service.dart';
import 'package:tow_management_system_ui/services/user_api_service.dart';

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
  static Future<void> validateConfirmationCode(userId, confirmationCode, email, password, firstName, lastName) async {
    try {

      await Amplify.Auth.confirmSignUp(
        username: userId,
        confirmationCode: confirmationCode,
      );

      await Amplify.Auth.signIn(username: email, password: password);

      // Create new user
      final user = User(id: userId, email: email, firstName: firstName, lastName: lastName);

      // Create the user account
      await UserAPI.createUser(user);
      
    } on AuthException catch (e) {
      safePrint('Error confirming user: ${e.message}');
    }
  }

  /// Attempts to create a new Tow Pro account using the onboarding information and
  /// create a new user account using the userId from identity provider and newly
  static Future<User?> completeAccountCreation(userId, companyName, phone, address) async {
    // Create company
    final company = Company(name: companyName, phoneNumber: phone, street: address);
    
    // Send company details to backend
    var createdCompany = await CompanyAPI.createCompany(company);
    
    // Create user update
    final user = User(id: userId, companyId: createdCompany?.id);
    
    // Update user with company id
    UserAPI.updateUser(user);
    
  }


}
