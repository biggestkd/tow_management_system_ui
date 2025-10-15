// lib/screens/onboarding/step_auth.dart
import 'package:flutter/material.dart';
import '../../utilities/validator.dart';

class StepConfirmation extends StatelessWidget {
  const StepConfirmation({
    super.key,
    required this.confirmationCodeController,
    required this.errorText,
    required this.goToNextStep,

  });

  final TextEditingController confirmationCodeController;
  final String? errorText;
  final void Function(int) goToNextStep;
  final bool loading = false;


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        TextField(
          controller: confirmationCodeController,
          decoration: InputDecoration(
            labelText: 'Confirmation Code',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 48),
        // Footer actions
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: loading ? null : () => goToNextStep(0),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: loading ? null : () => goToNextStep(2),
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
        )

      ],
    );
  }

}
