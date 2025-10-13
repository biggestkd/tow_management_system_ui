import 'package:go_router/go_router.dart';
import '../views/onboarding/onboarding_screen.dart';

final router = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    GoRoute(path: '/onboarding', builder: (_, __) => const OnboardingScreen()),
  ],
);
