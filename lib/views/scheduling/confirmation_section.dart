import 'package:flutter/material.dart';
import '../../colors.dart';

class ConfirmationSection extends StatelessWidget {
  final bool isSuccess;
  final String? errorMessage;
  final VoidCallback onScheduleAnother;
  final VoidCallback onGoToDashboard;

  const ConfirmationSection({
    super.key,
    required this.isSuccess,
    this.errorMessage,
    required this.onScheduleAnother,
    required this.onGoToDashboard,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final message = isSuccess
        ? 'Your tow request has been submitted successfully! We will contact you shortly.'
        : (errorMessage ?? 'An error occurred while submitting your request. Please try again.');

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            isSuccess ? Icons.check_circle : Icons.error,
            size: 64,
            color: isSuccess ? AppColors.success : AppColors.error,
          ),
          const SizedBox(height: 24),
          Text(
            isSuccess ? 'Request Submitted' : 'Submission Failed',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: theme.textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: onScheduleAnother,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Schedule Another Tow'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: onGoToDashboard,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Go to Dashboard'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

