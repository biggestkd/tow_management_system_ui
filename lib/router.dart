import 'package:go_router/go_router.dart';
import 'package:tow_management_system_ui/views/dashboard/dashboard_screen.dart';
import 'package:tow_management_system_ui/views/login/login_screen.dart';
import 'package:tow_management_system_ui/views/account/account_information.dart';
import 'package:tow_management_system_ui/views/scheduling/schedule_form.dart';
import '../views/onboarding/onboarding_screen.dart';

final router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/account-information', builder: (_, __) => const AccountInformationScreen()),
    GoRoute(
      path: '/schedule-tow/:companyUrl',
      builder: (context, state) {
        final companyUrl = state.pathParameters['companyUrl'] ?? '';
        return ScheduleTowScreen(companyUrl: companyUrl);
      },
    ),
  ],
);
