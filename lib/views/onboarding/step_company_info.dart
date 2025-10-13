import 'package:flutter/material.dart';
import '../../utilities/validator.dart';

class StepCompanyInfo extends StatefulWidget {
  const StepCompanyInfo({
    super.key,
    required this.companyName,
    required this.phone,
    required this.website,
    required this.address,
    required this.loading,
    required this.errorText,
    required this.onCompanyNameChanged,
    required this.onPhoneChanged,
    required this.onWebsiteChanged,
    required this.onAddressChanged,
    required this.onContinue,
  });

  final String companyName;
  final String phone;
  final String website;
  final String address;
  final bool loading;
  final String? errorText;
  final void Function(String companyName) onCompanyNameChanged;
  final void Function(String phone) onPhoneChanged;
  final void Function(String website) onWebsiteChanged;
  final void Function(String address) onAddressChanged;

  /// NEW SIGNATURE:
  /// onContinue(companyName, phone?, website?, address?)
  final Future<void> Function(
      String companyName,
      String? phone,
      String? website,
      String? address,
      ) onContinue;

  @override
  State<StepCompanyInfo> createState() => _StepCompanyInfoState();
}

class _StepCompanyInfoState extends State<StepCompanyInfo> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _companyController;
  late TextEditingController _phoneController;
  late TextEditingController _websiteController;
  late TextEditingController _addressController;

  bool _formValid = false;

  @override
  void initState() {
    super.initState();
    _companyController = TextEditingController(text: widget.companyName);
    _phoneController = TextEditingController(text: widget.phone);
    _websiteController = TextEditingController(text: widget.website);
    _addressController = TextEditingController(text: widget.address);
    _companyController.addListener(_revalidate);
    _phoneController.addListener(_revalidate);
    _websiteController.addListener(_revalidate);
    _addressController.addListener(_revalidate);
  }

  @override
  void didUpdateWidget(StepCompanyInfo oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.companyName != widget.companyName) {
      _companyController.text = widget.companyName;
    }
    if (oldWidget.phone != widget.phone) {
      _phoneController.text = widget.phone;
    }
    if (oldWidget.website != widget.website) {
      _websiteController.text = widget.website;
    }
    if (oldWidget.address != widget.address) {
      _addressController.text = widget.address;
    }
  }

  @override
  void dispose() {
    _companyController
      ..removeListener(_revalidate)
      ..dispose();
    _phoneController
      ..removeListener(_revalidate)
      ..dispose();
    _websiteController
      ..removeListener(_revalidate)
      ..dispose();
    _addressController
      ..removeListener(_revalidate)
      ..dispose();
    super.dispose();
  }

  void _revalidate() {
    // Button enablement: company required, others optional but validated if present
    final companyOk = validateNotEmpty(_companyController.text, field: 'Company name') == null;
    final phoneOk = _phoneController.text.trim().isEmpty || validatePhone(_phoneController.text) == null;
    final websiteOk = _websiteController.text.trim().isEmpty || validateWebsite(_websiteController.text, required: false) == null;
    // Address optional; no strict check here
    final nextValid = companyOk && phoneOk && websiteOk;
    if (nextValid != _formValid) setState(() => _formValid = nextValid);
  }

  Future<void> _submit() async {
    // Run validators so messages show
    if (!(_formKey.currentState?.validate() ?? false)) return;
    
    // Update parent state
    widget.onCompanyNameChanged(_companyController.text.trim());
    widget.onPhoneChanged(_phoneController.text.trim());
    widget.onWebsiteChanged(_websiteController.text.trim());
    widget.onAddressChanged(_addressController.text.trim());
    
    await widget.onContinue(
      _companyController.text.trim(),
      _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      _websiteController.text.trim().isEmpty ? null : _websiteController.text.trim(),
      _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
    );
  }

  InputDecoration _dec(BuildContext context, {required String label, String? hint, Widget? prefixIcon}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: prefixIcon,
      filled: true,
      fillColor: Colors.white, // white input on gray page (from OnboardingShell)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)), // gray-200
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Company Information', style: theme.textTheme.titleMedium),
            const SizedBox(height: 16),

            // Company Name (REQUIRED)
            TextFormField(
              controller: _companyController,
              decoration: _dec(context, label: 'Company name', hint: 'Acme Towing', prefixIcon: const Icon(Icons.apartment)),
              textInputAction: TextInputAction.next,
              validator: (v) => validateNotEmpty(v, field: 'Company name'),
            ),
            const SizedBox(height: 12),

            // Phone (OPTIONAL)
            TextFormField(
              controller: _phoneController,
              decoration: _dec(context, label: 'Phone (Optional)', hint: 'e.g., (973) 555-0101', prefixIcon: const Icon(Icons.phone_outlined)),
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if ((v ?? '').trim().isEmpty) return null; // optional
                return validatePhone(v);
              },
            ),
            const SizedBox(height: 12),

            // Website (OPTIONAL)
            TextFormField(
              controller: _websiteController,
              decoration: _dec(context, label: 'Website (Optional)', hint: 'https://example.com', prefixIcon: const Icon(Icons.public)),
              keyboardType: TextInputType.url,
              textInputAction: TextInputAction.next,
              validator: (v) => validateWebsite(v, required: false),
            ),
            const SizedBox(height: 12),

            // Address (OPTIONAL)
            TextFormField(
              controller: _addressController,
              decoration: _dec(context, label: 'Address (Optional)', hint: 'Street, City, State', prefixIcon: const Icon(Icons.location_on_outlined)),
              keyboardType: TextInputType.streetAddress,
              maxLines: 2,
              validator: (_) => null, // optional
            ),

            const SizedBox(height: 16),
            if (widget.errorText != null)
              Text(widget.errorText!, style: const TextStyle(color: Colors.red)),
          ],
        ),
      ),
    );
  }
}
