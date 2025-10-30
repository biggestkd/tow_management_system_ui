// lib/screens/auth/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import '../../utilities/validator.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const _bg = Color(0xFFF5F7FB);

  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _loading = false;
  bool _obscure = true;
  String? _error;

  @override
  void dispose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final res = await Amplify.Auth.signIn(
        username: emailCtrl.text.trim(),
        password: passwordCtrl.text,
      );

      if (!mounted) return;

      if (res.isSignedIn) {
        context.go('/dashboard');
        return;
      }

      // Handle next steps (MFA/New Password/etc.) as needed
      setState(() {
        _error = 'Additional sign-in step required (${res.nextStep.signInStep.name}).';
      });
    } on AuthException catch (e) {
      setState(() {
        _error = e.message;
      });
    } catch (e) {
      setState(() {
        _error = 'Something went wrong. Please try again.';
      });
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                        // Header
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'Welcome back',
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Sign in to continue',
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),

                        // Body
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                            child: SingleChildScrollView(
                              physics: const ClampingScrollPhysics(),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: emailCtrl,
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        hintText: 'you@company.com',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                      textInputAction: TextInputAction.next,
                                      validator: validateEmail,
                                    ),
                                    const SizedBox(height: 12),
                                    TextFormField(
                                      controller: passwordCtrl,
                                      decoration: InputDecoration(
                                        labelText: 'Password',
                                        hintText: 'Minimum 8 characters',
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                        suffixIcon: IconButton(
                                          icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                                          onPressed: () => setState(() => _obscure = !_obscure),
                                        ),
                                      ),
                                      obscureText: _obscure,
                                      textInputAction: TextInputAction.done,
                                      validator: (v) => validatePassword(v, min: 8),
                                      onFieldSubmitted: (_) => _handleSignIn(),
                                    ),
                                    const SizedBox(height: 12),
                                    if (_error != null) ...[
                                      Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
                                      const SizedBox(height: 6),
                                    ],
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        TextButton(
                                          onPressed: () {
                                            // TODO: route to forgot password flow if implemented
                                          },
                                          child: const Text('Forgot password?'),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Footer actions
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                          child: Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {
                                    if (!context.mounted) return;
                                    context.go('/onboarding'); // optional: route to sign-up flow
                                  },
                                  child: const Text('Create account'),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: _loading ? null : _handleSignIn,
                                  child: _loading
                                      ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                      : const Text('Sign in'),
                                ),
                              ),
                            ],
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
}
