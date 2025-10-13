import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../utilities/validator.dart';

class StepAuth extends StatefulWidget {
  const StepAuth({
    super.key,
    required this.email,
    required this.password,
    required this.loading,
    required this.errorText,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onContinue,
    required this.onGoogle,
  });

  final String email;
  final String password;
  final bool loading;
  final String? errorText;
  final void Function(String email) onEmailChanged;
  final void Function(String password) onPasswordChanged;
  final Future<void> Function(String email, String password) onContinue;
  final Future<void> Function() onGoogle;

  @override
  State<StepAuth> createState() => _StepAuthState();
}

class _StepAuthState extends State<StepAuth> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  bool _obscure = true;
  bool _formValid = false;
  bool _showErrors = false; // <- gate error messages

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController(text: widget.email);
    _passwordController = TextEditingController(text: widget.password);
    _emailController.addListener(_revalidate);
    _passwordController.addListener(_revalidate);
  }

  @override
  void didUpdateWidget(StepAuth oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.email != widget.email) {
      _emailController.text = widget.email;
    }
    if (oldWidget.password != widget.password) {
      _passwordController.text = widget.password;
    }
  }

  @override
  void dispose() {
    _emailController
      ..removeListener(_revalidate)
      ..dispose();
    _passwordController
      ..removeListener(_revalidate)
      ..dispose();
    super.dispose();
  }

  void _revalidate() {
    // Lightweight enablement only (no messages yet)
    final okEmail = _emailController.text.trim().isNotEmpty && validateEmail(_emailController.text.trim()) == null;
    final okPass  = validatePassword(_passwordController.text, min: 8) == null;
    final v = okEmail && okPass;
    if (v != _formValid) setState(() => _formValid = v);
  }

  Future<void> _submit() async {
    setState(() => _showErrors = true); // <-- show messages from now on
    final ok = _formKey.currentState?.validate() ?? false;
    if (!ok) {
      HapticFeedback.selectionClick();
      return;
    }
    HapticFeedback.lightImpact();
    
    // Update parent state
    widget.onEmailChanged(_emailController.text.trim());
    widget.onPasswordChanged(_passwordController.text);
    
    await widget.onContinue(_emailController.text.trim(), _passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Create your account', style: theme.textTheme.titleMedium),
        const SizedBox(height: 4),
        Text(
          'Use your work email or continue with Google.',
          style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
        ),
        const SizedBox(height: 16),

        // Error banner from backend/auth attempt (animated)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 200),
          child: (widget.errorText == null)
              ? const SizedBox.shrink()
              : Container(
            key: const ValueKey('error'),
            width: double.infinity,
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: theme.colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.error_outline, color: theme.colorScheme.onErrorContainer),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.errorText!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onErrorContainer,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        Form(
          key: _formKey,
          // Only show validation messages after user taps Continue
          autovalidateMode: _showErrors
              ? AutovalidateMode.always
              : AutovalidateMode.disabled,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  hintText: 'you@company.com',
                  prefixIcon: const Icon(Icons.alternate_email),
                  filled: true,
                  fillColor: Colors.white, // white on gray bg
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                validator: validateEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  hintText: 'Minimum 8 characters',
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    tooltip: _obscure ? 'Show password' : 'Hide password',
                    onPressed: () => setState(() => _obscure = !_obscure),
                    icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                obscureText: _obscure,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => widget.loading ? null : _submit(),
                validator: (v) => validatePassword(v, min: 8),
              ),
              const SizedBox(height: 16),

              // Divider with "or"
              Row(
                children: [
                  const Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text('or', style: theme.textTheme.bodySmall),
                  ),
                  const Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: 14),

              // Google button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  onPressed: widget.loading
                      ? null
                      : () async {
                    HapticFeedback.selectionClick();
                    await widget.onGoogle();
                  },
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Replace with real Google SVG if you have it
                      Icon(Icons.g_mobiledata),
                      SizedBox(width: 10),
                      Text('Continue with Google'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
