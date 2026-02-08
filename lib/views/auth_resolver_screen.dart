import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Resolves initial navigation based on Cognito auth state:
/// - If the user is signed in → navigate to dashboard.
/// - If the user is not signed in (Cognito available) → navigate to onboarding.
class AuthResolverScreen extends StatefulWidget {
  const AuthResolverScreen({super.key});

  @override
  State<AuthResolverScreen> createState() => _AuthResolverScreenState();
}

class _AuthResolverScreenState extends State<AuthResolverScreen> {
  @override
  void initState() {
    super.initState();
    _resolveAndNavigate();
  }

  Future<void> _resolveAndNavigate() async {
    try {
      await Amplify.Auth.getCurrentUser();
      if (!mounted) return;
      context.go('/dashboard');
    } on SignedOutException {
      if (!mounted) return;
      context.go('/onboarding');
    } catch (_) {
      // Any other error (e.g. not configured) → treat as not signed in
      if (!mounted) return;
      context.go('/onboarding');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
