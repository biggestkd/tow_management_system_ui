import 'package:go_router/go_router.dart';
import 'package:tow_management_system_ui/views/dashboard/dashboard_screen.dart';
import '../views/onboarding/onboarding_screen.dart';

final router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => const DashboardScreen()),
  ],
);
