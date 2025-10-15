// lib/screens/onboarding/onboarding_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tow_management_system_ui/views/onboarding/step_confirmation.dart';

import '../../controllers/onboarding_controller.dart';
import '../../models/account.dart';

/// --- Step widgets (defined below) ---
import 'step_auth.dart';
import 'step_company_info.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  int _currentStep = 0;
  bool _loading = false;
  String? _error;

  // Single source of truth: controllers live in parent
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();
  final companyNameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final websiteCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final confirmationCtrl = TextEditingController();

  String? _idToken;
  Account? _account;

  static const _bg = Color(0xFFF5F7FB);

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    companyNameCtrl.dispose();
    phoneCtrl.dispose();
    websiteCtrl.dispose();
    addressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const totalSteps = 3;
    final progress = ((_currentStep + 1) / totalSteps).clamp(0, 1);

    return Scaffold(
      backgroundColor: _bg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 600;
          const double cardSide = 520;

          return SafeArea(
            child: Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 0),
              child: Center(
                child: ConstrainedBox(
                  constraints: isMobile
                      ? const BoxConstraints.expand()
                      : const BoxConstraints.tightFor(width: cardSide, height: cardSide),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 18,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Header + progress
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _headerTitleForStep(_currentStep),
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 10),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(value: progress.toDouble()),
                              ),
                            ],
                          ),
                        ),

                        // Body (step content — conditional render)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: ClipRect(
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                child: _buildCurrentStep(),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  String _headerTitleForStep(int step) {
    switch (step) {
      case 0:
        return 'Create your account';
      case 1:
        return 'Enter code sent to email';
      case 2:
        return 'Provide your company information';
      default:
        return '';
    }
  }

  Widget _buildCurrentStep() {
    switch (_currentStep) {
      case 0:
        return StepAuth(
          emailController: emailCtrl,
          passwordController: passwordCtrl,
          errorText: _error,
          goToNextStep: (int step) async => {
            _idToken = await OnboardingController.signUpWithEmailAndPassword(emailCtrl.text, passwordCtrl.text),
            _goToStep(step)
          },
        );

      case 1:
        return StepConfirmation(
          confirmationCodeController: confirmationCtrl,
          errorText: _error,
          goToNextStep: (int step) async => {
            await OnboardingController.validateConfirmationCode(_idToken, confirmationCtrl.text, emailCtrl.text, passwordCtrl.text),
            _goToStep(step)
          },
        );

      case 2:
        return StepCompanyInfo(
          companyNameController: companyNameCtrl,
          phoneController: phoneCtrl,
          websiteController: websiteCtrl,
          addressController: addressCtrl,
          loading: _loading,
          goToNextStep: _goToStep,
          errorText: _error,
        );

      default:
        return const SizedBox.shrink();
    }
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step;
      _error = null;
    });
  }

}

