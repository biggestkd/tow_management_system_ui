import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../models/account.dart';
import 'step_auth.dart';
import 'step_company_info.dart';
import 'step_review.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0; // 0=auth, 1=company, 2=review
  bool _loading = false;
  String? _error;

  // State for all steps - preserved when navigating between steps
  String _email = '';
  String _password = '';
  String _companyName = '';
  String _phone = '';
  String _website = '';
  String _address = '';
  
  Account? _account;
  final _auth = MockAuthService();
  final _accounts = MockAccountService();

  @override
  Widget build(BuildContext context) {
    const totalSteps = 3;
    final theme = Theme.of(context);
    final progress = totalSteps <= 0 ? 0.0 : (_currentStep + 1) / totalSteps;

    return Scaffold(
      // Light gray background
      backgroundColor: const Color(0xFFF3F4F6), // gray-100 vibe
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: _currentStep > 0 ? BackButton(onPressed: () => _goToStep(_currentStep - 1)) : null,
        toolbarHeight: 72,
        centerTitle: true,
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Logo above "Tow Pro"
            Image.asset(
              'assets/logo.png',
              height: 28,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 6),
            Text(
              'Tow Pro',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.green,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Get Started with Tow Pro TEST', style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text('Step ${_currentStep + 1} of $totalSteps', style: theme.textTheme.bodyMedium?.copyWith(color: Colors.green)),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(value: progress.clamp(0, 1)),
                  ),
                  const SizedBox(height: 24),

                  // Card that holds the step content
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 18,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: _buildCurrentStepContent(),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surface,
                              border: Border(
                                top: BorderSide(
                                  color: theme.dividerColor.withOpacity(0.15),
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: _currentStep > 0 ? () => _goToStep(_currentStep - 1) : null,
                                    child: const Text('Back'),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: _getContinueButtonEnabled() ? _getContinueAction() : null,
                                    child: _loading
                                        ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(strokeWidth: 2),
                                    )
                                        : Text(_getContinueButtonText()),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
  }

  Widget _buildCurrentStepContent() {
    switch (_currentStep) {
      case 0:
        return StepAuth(
          email: _email,
          password: _password,
          loading: _loading,
          errorText: _error,
          onEmailChanged: (email) => setState(() => _email = email),
          onPasswordChanged: (password) => setState(() => _password = password),
          onContinue: _signInEmail,
          onGoogle: _signInGoogle,
        );

      case 1:
        return StepCompanyInfo(
          companyName: _companyName,
          phone: _phone,
          website: _website,
          address: _address,
          loading: _loading,
          errorText: _error,
          onCompanyNameChanged: (name) => setState(() => _companyName = name),
          onPhoneChanged: (phone) => setState(() => _phone = phone),
          onWebsiteChanged: (website) => setState(() => _website = website),
          onAddressChanged: (address) => setState(() => _address = address),
          onContinue: _saveCompanyInfo,
        );

      case 2:
        return StepReview(
          email: _email,
          account: _account,
        );

      default:
        return const Center(child: Text('Invalid step'));
    }
  }

  bool _getContinueButtonEnabled() {
    switch (_currentStep) {
      case 0:
        // Auth step - check if form is valid
        return _email.isNotEmpty && _password.isNotEmpty;
      case 1:
        // Company info step - check if company name is filled
        return _companyName.isNotEmpty;
      case 2:
        // Review step - always enabled
        return true;
      default:
        return false;
    }
  }

  String _getContinueButtonText() {
    switch (_currentStep) {
      case 0:
      case 1:
        return 'Continue';
      case 2:
        return 'Finish';
      default:
        return 'Continue';
    }
  }

  VoidCallback? _getContinueAction() {
    switch (_currentStep) {
      case 0:
        return () => _signInEmail(_email, _password);
      case 1:
        return () => _saveCompanyInfo(
          _companyName,
          _phone.isEmpty ? null : _phone,
          _website.isEmpty ? null : _website,
          _address.isEmpty ? null : _address,
        );
      case 2:
        return _finish;
      default:
        return null;
    }
  }

  void _goToStep(int step) {
    setState(() {
      _currentStep = step.clamp(0, 2);
      _error = null; // Clear error when changing steps
    });
  }

  Future<void> _signInEmail(String email, String password) async {
    setState(() { 
      _loading = true; 
      _error = null; 
    });
    
    try {
      final idToken = await _auth.signInEmail(email, password);
      final acct = await _accounts.bootstrap(idToken: idToken);
      setState(() { 
        _account = acct; 
        _loading = false; 
      });
      _goToStep(1);
    } catch (e) {
      setState(() { 
        _loading = false; 
        _error = _err(e); 
      });
    }
  }

  Future<void> _signInGoogle() async {
    setState(() { 
      _loading = true; 
      _error = null; 
    });
    
    try {
      final idToken = await _auth.signInWithGoogle();
      final acct = await _accounts.bootstrap(idToken: idToken);
      setState(() { 
        _account = acct; 
        _loading = false; 
      });
      _goToStep(1);
    } catch (e) {
      setState(() { 
        _loading = false; 
        _error = _err(e); 
      });
    }
  }

  Future<void> _saveCompanyInfo(String companyName, String? phone, String? website, String? address) async {
    setState(() { 
      _loading = true; 
      _error = null; 
    });
    
    try {
      final acct = await _accounts.updateCompanyInfo(
        accountId: _account!.id,
        phone: phone,
        website: website,
        address: address!,
      );
      setState(() { 
        _account = acct; 
        _loading = false; 
      });
      _goToStep(2);
    } catch (e) {
      setState(() { 
        _loading = false; 
        _error = _err(e); 
      });
    }
  }

  void _finish() {
    // Navigate to dashboard
    if (mounted) {
      try {
        context.go('/dashboard');
      } catch (_) {
        Navigator.of(context).pushReplacementNamed('/dashboard');
      }
    }
  }

  String _err(Object e) => e.toString().replaceFirst('Exception: ', '');
}

// Mock services (same as before)
class MockAuthService {
  Future<String> signInEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (email.isEmpty || password.isEmpty) throw Exception('Email and password are required');
    return 'mock.id.token.$email';
  }

  Future<String> signInWithGoogle() async {
    await Future.delayed(const Duration(milliseconds: 400));
    return 'mock.id.token.google';
  }
}

class MockAccountService {
  Account? _acct;
  
  Future<Account> bootstrap({required String idToken}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    _acct ??= Account(
      id: 'acct_demo_123', 
      companyInformation: '',
      stripeAccountId: 'acct_stripe_demo_001',
    );
    return _acct!;
  }

  Future<Account> updateCompanyInfo({
    required String accountId, 
    String? phone, 
    String? website, 
    String? address
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final info = [
      if ((phone ?? '').isNotEmpty) 'Phone: $phone',
      if ((website ?? '').isNotEmpty) 'Website: $website',
      if ((address ?? '').isNotEmpty) 'Address: $address',
    ].join(' | ');

    return Account(
      id: _acct!.id,
      companyInformation: info,
      stripeAccountId: _acct!.stripeAccountId,
    );
  }
}
