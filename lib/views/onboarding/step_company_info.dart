// lib/screens/onboarding/step_company_info.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StepCompanyInfo extends StatelessWidget {
  const StepCompanyInfo({
    super.key,
    required this.companyNameController,
    required this.phoneController,
    required this.websiteController,
    required this.addressController,
    required this.loading,
    required this.errorText,
    required this.goToNextStep,
    required this.goToPrevious,
  });

  final TextEditingController companyNameController;
  final TextEditingController phoneController;
  final TextEditingController websiteController;
  final TextEditingController addressController;
  final void Function(int) goToNextStep;
  final void Function(int) goToPrevious;

  final bool loading;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 12),
        TextField(
          controller: companyNameController,
          decoration: InputDecoration(
            labelText: 'Company name *',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: phoneController,
          decoration: InputDecoration(
            labelText: 'Phone',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 12),
        TextField(
          controller: addressController,
          decoration: InputDecoration(
            labelText: 'Address',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          minLines: 2,
          maxLines: 4,
        ),
        const SizedBox(height: 48),

        // Footer actions
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
          child: Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: loading ? null : () => goToPrevious(0),
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: loading ? null : () => goToNextStep(1),
                  child: loading
                      ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Finish'),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
