// lib/controllers/onboarding_controller.dart
//
// Self-contained, runnable mock for your onboarding flow.
// - Uses Riverpod Notifier API (Riverpod 2.x)
// - Mocks AuthService and AccountService with small delays
// - Includes a minimal Account model so you don't need other files yet
//
// When you’re ready to wire real services, replace the mock providers
// (authServiceProvider/accountServiceProvider) with your implementations.

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ---- Mock domain models (TEMP) ----
/// If you already have lib/models/account.dart, you can delete this class
/// and import your real one instead.
class Account {
  final String id;
  final String companyInformation;
  final String stripeAccountId;

  const Account({
    required this.id,
    required this.companyInformation,
    required this.stripeAccountId,
  });

  Account copyWith({
    String? id,
    String? companyInformation,
    String? stripeAccountId,
  }) {
    return Account(
      id: id ?? this.id,
      companyInformation: companyInformation ?? this.companyInformation,
      stripeAccountId: stripeAccountId ?? this.stripeAccountId,
    );
  }
}

/// ---- Public state for the onboarding flow ----
class OnboardingState {
  final Account? account;     // Becomes non-null after bootstrap
  final int stepIndex;        // 0=auth, 1=company, 2=review, 3=finished
  final bool loading;
  final String? error;

  const OnboardingState({
    this.account,
    this.stepIndex = 0,
    this.loading = false,
    this.error,
  });

  OnboardingState copyWith({
    Account? account,
    int? stepIndex,
    bool? loading,
    String? error, // pass null to clear error
  }) {
    return OnboardingState(
      account: account ?? this.account,
      stepIndex: stepIndex ?? this.stepIndex,
      loading: loading ?? this.loading,
      error: error,
    );
  }

  static const initial = OnboardingState();
}

/// ---- Service abstractions (so you can swap mocks for real later) ----
abstract class AuthService {
  /// Returns a fake ID token string on success.
  Future<String> signInEmail(String email, String password);

  /// Returns a fake ID token string on success.
  Future<String> signInWithGoogle();

  Future<void> signOut();
}

abstract class AccountService {
  /// Creates/loads an account for the signed-in user.
  Future<Account> bootstrap({required String idToken});

  /// Updates company info for the account and returns the updated account.
  Future<Account> updateCompanyInfo({
    required String accountId,
    required String phone,
    String? website,
    required String address,
  });
}

/// ---- Mock implementations (TEMP) ----
class MockAuthService implements AuthService {
  @override
  Future<String> signInEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required.');
    }
    // Return a dummy JWT-like string.
    return 'mock.id.token.for:$email';
  }

  @override
  Future<String> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 'mock.id.token.google.user';
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }
}

class MockAccountService implements AccountService {
  Account? _acct;

  @override
  Future<Account> bootstrap({required String idToken}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Create an account the first time, reuse after.
    _acct ??= const Account(
      id: 'acct_demo_123',
      companyInformation: '',
      stripeAccountId: 'acct_stripe_demo_001',
    );
    return _acct!;
  }

  @override
  Future<Account> updateCompanyInfo({
    required String accountId,
    required String phone,
    String? website,
    required String address,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // Smash the fields into a single string to keep the mock simple.
    final companyInfo = [
      if (phone.isNotEmpty) 'Phone: $phone',
      if ((website ?? '').isNotEmpty) 'Website: $website',
      if (address.isNotEmpty) 'Address: $address',
    ].join(' | ');

    _acct = (_acct ??
        Account(
          id: accountId,
          companyInformation: '',
          stripeAccountId: 'acct_stripe_demo_001',
        ))
        .copyWith(companyInformation: companyInfo);

    return _acct!;
  }
}

/// ---- Providers for the services (swap these to real impls later) ----
final authServiceProvider = Provider<AuthService>((ref) => MockAuthService());
final accountServiceProvider =
Provider<AccountService>((ref) => MockAccountService());

/// ---- The Notifier that your UI listens to ----
class OnboardingControllerNotifier extends Notifier<OnboardingState> {
  late final AuthService _auth;
  late final AccountService _accounts;

  @override
  OnboardingState build() {
    // Grab our (mock) services once. Replace with real services later.
    _auth = ref.read(authServiceProvider);
    _accounts = ref.read(accountServiceProvider);
    return OnboardingState.initial;
  }

  /// Step 1: Email/password sign-in
  Future<void> signInEmail(String email, String password) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final idToken = await _auth.signInEmail(email, password);
      final acct = await _accounts.bootstrap(idToken: idToken);
      state = state.copyWith(account: acct, loading: false, stepIndex: 1);
    } catch (e) {
      state = state.copyWith(loading: false, error: _err(e));
    }
  }

  /// Step 1 (alt): Google sign-in
  Future<void> signInGoogle() async {
    state = state.copyWith(loading: true, error: null);
    try {
      final idToken = await _auth.signInWithGoogle();
      final acct = await _accounts.bootstrap(idToken: idToken);
      state = state.copyWith(account: acct, loading: false, stepIndex: 1);
    } catch (e) {
      state = state.copyWith(loading: false, error: _err(e));
    }
  }

  /// Step 2: Save company info
  Future<void> saveCompanyInfo({
    required String phone,
    String? website,
    required String address,
  }) async {
    state = state.copyWith(loading: true, error: null);
    try {
      final acct = state.account;
      if (acct == null) throw Exception('No account to update.');
      final updated = await _accounts.updateCompanyInfo(
        accountId: acct.id,
        phone: phone,
        website: website,
        address: address,
      );
      state = state.copyWith(account: updated, loading: false, stepIndex: 2);
    } catch (e) {
      state = state.copyWith(loading: false, error: _err(e));
    }
  }

  /// Step 3: Finish onboarding → the UI should route to /dashboard
  void finish() {
    state = state.copyWith(stepIndex: 3);
  }

  /// Optional: simple back navigation inside the flow.
  void back() {
    final next = (state.stepIndex - 1).clamp(0, 3);
    state = state.copyWith(stepIndex: next);
  }

  /// Reset the flow to the beginning (e.g., from a "Start Over" action).
  void reset() {
    state = OnboardingState.initial;
  }

  String _err(Object e) => e.toString().replaceFirst('Exception: ', '');
}

/// Expose the controller as a provider for the UI to watch.
final onboardingControllerProvider =
NotifierProvider<OnboardingControllerNotifier, OnboardingState>(
  OnboardingControllerNotifier.new,
);
