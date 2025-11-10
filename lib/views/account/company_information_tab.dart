import 'package:flutter/material.dart';
import '../../colors.dart';

class CompanyInformationTab extends StatefulWidget {
  const CompanyInformationTab({
    super.key,
    required this.name,
    required this.website,
    required this.street,
    required this.city,
    required this.zipCode,
    required this.state,
    required this.phoneNumber,
    required this.onSave,
  });

  final String name;
  final String website;
  final String street;
  final String city;
  final String zipCode;
  final String state;
  final String phoneNumber;
  final Future<void> Function(String name, String website, String street, String city, String zipCode, String state, String phoneNumber) onSave;

  @override
  State<CompanyInformationTab> createState() => _CompanyInformationTabState();
}

class _CompanyInformationTabState extends State<CompanyInformationTab> {
  late TextEditingController _nameController;
  late TextEditingController _websiteController;
  late TextEditingController _streetController;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _zipCodeController;
  late TextEditingController _phoneNumberController;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _websiteController = TextEditingController(text: widget.website);
    _streetController = TextEditingController(text: widget.street);
    _cityController = TextEditingController(text: widget.city);
    _stateController = TextEditingController(text: widget.state);
    _zipCodeController = TextEditingController(text: widget.zipCode);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  void didUpdateWidget(CompanyInformationTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Always reset controllers when widget updates (tab switch) to discard unsaved edits
    // This ensures that switching tabs always shows the saved data from AccountInformationScreen
    _nameController.text = widget.name;
    _websiteController.text = widget.website;
    _streetController.text = widget.street;
    _cityController.text = widget.city;
    _stateController.text = widget.state;
    _zipCodeController.text = widget.zipCode;
    _phoneNumberController.text = widget.phoneNumber;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _websiteController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipCodeController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    setState(() {
      _saving = true;
    });

    await widget.onSave(
      _nameController.text.trim(),
      _websiteController.text.trim(),
      _streetController.text.trim(),
      _cityController.text.trim(),
      _zipCodeController.text.trim(),
      _stateController.text.trim(),
      _phoneNumberController.text.trim(),
    );

    setState(() {
      _saving = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: AppColors.background,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Company Information',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildEditableTextField(
                    label: 'Company Name',
                    controller: _nameController,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  _buildEditableTextField(
                    label: 'Website',
                    controller: _websiteController,
                    theme: theme,
                    keyboardType: TextInputType.url,
                  ),
                  const SizedBox(height: 16),
                  _buildEditableTextField(
                    label: 'Street Address',
                    controller: _streetController,
                    theme: theme,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildEditableTextField(
                          label: 'City',
                          controller: _cityController,
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: _buildEditableTextField(
                          label: 'State',
                          controller: _stateController,
                          theme: theme,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildEditableTextField(
                          label: 'Zip Code',
                          controller: _zipCodeController,
                          theme: theme,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildEditableTextField(
                    label: 'Phone Number',
                    controller: _phoneNumberController,
                    theme: theme,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _saving ? null : _handleSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: _saving
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            )
                          : const Text('Save Changes'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    )
    );
  }

  Widget _buildEditableTextField({
    required String label,
    required TextEditingController controller,
    required ThemeData theme,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
          ),
        ),
      ],
    );
  }
}

