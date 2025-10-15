// lib/screens/onboarding/onboarding_screen.dart
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/colors.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late final Future<AuthUser?> _user;

  @override
  void initState() {
    super.initState();
    _user = _currentUser();
  }

  Future<AuthUser?> _currentUser() async {
    try {
      return await Amplify.Auth.getCurrentUser(); // has userId, username
    } on SignedOutException {
      safePrint("Signed Out");
      return null;
    } catch (_) {
      safePrint("Issue pulling user");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 0),
              child: Center(
                child: FutureBuilder<AuthUser?>(
                  future: _user,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator(strokeWidth: 2);
                    }
                    final user = snapshot.data;
                    if (user == null) {
                      // Signed out or failed to fetch — pick your preferred fallback
                      return const Text('Hi');
                    }
                    return Text('hi ${user.userId}');
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

