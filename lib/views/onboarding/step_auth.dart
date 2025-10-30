// lib/screens/onboarding/step_auth.dart
import 'package:flutter/material.dart';
import '../../utilities/validator.dart';

class StepAuth extends StatelessWidget {
  StepAuth({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.errorText,
    required this.goToNextStep,
    required this.goToPrevious,
    required this.firstNameController,
    required this.lastNameController,

  });

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final String? errorText;
  final void Function(int) goToNextStep;
  final void Function(int) goToPrevious;
  final TextEditingController firstNameController;
  final TextEditingController lastNameController;

  bool obscure = true;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        TextFormField(
          controller: emailController,
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
          controller: passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            hintText: 'Minimum 8 characters',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          obscureText: obscure,
          textInputAction: TextInputAction.done,
          validator: (v) => validatePassword(v, min: 2),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: firstNameController,
          decoration: InputDecoration(
            labelText: 'First Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          textInputAction: TextInputAction.done,
          validator: (v) => validatePassword(v, min: 8),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: lastNameController,
          decoration: InputDecoration(
            labelText: 'Last Name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          textInputAction: TextInputAction.done,
          validator: (v) => validatePassword(v, min: 2),
        ),
        const SizedBox(height: 48),

        // Footer actions
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Row(
            children: [
              Expanded(
                child:
                  OutlinedButton(
                    onPressed: null,
                    child: const Text('Back'),
                  ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => goToNextStep(1),
                  child: loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Continue'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
