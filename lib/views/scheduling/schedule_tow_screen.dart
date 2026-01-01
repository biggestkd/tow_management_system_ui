import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/views/scheduling/vehicle_section_input.dart';
import '../../models/tow.dart';
import '../../models/vehicle.dart';
import '../../controllers/scheduling_controller.dart';
import 'bottom_bar_input.dart';
import 'locations_section_input.dart';
import 'estimate_section.dart';
import 'driver_input_section.dart';

class ScheduleTowScreen extends StatefulWidget {
  final String? companyUrl;
  final Function(Tow)? onSubmit;
  final Function()? onCancel;

  const ScheduleTowScreen({
    super.key,
    this.companyUrl,
    this.onSubmit,
    this.onCancel,
  });

  @override
  State<ScheduleTowScreen> createState() => _ScheduleTowScreenState();
}

class _ScheduleTowScreenState extends State<ScheduleTowScreen> {

  // location inputs
  late TextEditingController _destinationController;
  late TextEditingController _pickupController;
  // vehicle inputs
  late TextEditingController _yearController;
  late TextEditingController _makeController;
  late TextEditingController _modelController;
  // driver inputs
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  var currentStep = 0;
  int total = 0;
  int? estimate; // Store the estimate value from calculateTowPrice
  
  // Validation error messages
  String? _firstNameError;
  String? _lastNameError;
  String? _phoneError;
  String? _emailError;

  @override
  void initState() {
    super.initState();
    _destinationController = TextEditingController();
    _pickupController = TextEditingController();
    _yearController = TextEditingController();
    _makeController = TextEditingController();
    _modelController = TextEditingController();
    _firstNameController = TextEditingController();
    _lastNameController = TextEditingController();
    _phoneController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _pickupController.dispose();
    _yearController.dispose();
    _makeController.dispose();
    _modelController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery
        .of(context)
        .size;
    final isLargeScreen = screenSize.width >= 768;
    final maxWidth = isLargeScreen ? screenSize.width * 0.32 : screenSize.width;

    return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: const Padding(
            padding: EdgeInsets.only(top: 36, bottom: 42),
            child: Text(
              'Schedule Tow',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxWidth),
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildCurrentStep(),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 16),
                      child: _buildBottomBar()
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }


  Widget _buildCurrentStep() {
    switch (currentStep) {
      case 0:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LocationsSectionInput(
              pickupController: _pickupController,
              destinationController: _destinationController,
            ),
            const SizedBox(height: 16),
            VehicleSectionInput(
              yearController: _yearController,
              makeController: _makeController,
              modelController: _modelController,
            ),
          ],
        );

      case 1:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EstimateSection(total: total),
          ],
        );

      case 2:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DriverInputSection(
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              phoneController: _phoneController,
              emailController: _emailController,
              firstNameError: _firstNameError,
              lastNameError: _lastNameError,
              phoneError: _phoneError,
              emailError: _emailError,
            ),
          ],
        );

      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildBottomBar() {
    switch (currentStep) {
      case 0:
        return BottomBarInput(
          primaryText: 'Next',
          onCancel: () => {},
          onPrimary: () async {
            debugPrint('Validate Location ${_pickupController.text}');
            
            // companyUrl parameter from the route is actually the companyId
            final companyId = widget.companyUrl ?? '';
            
            // Calculate tow price estimate
            final calculatedEstimate = await SchedulingController.calculateTowPrice(
              pickup: _pickupController.text,
              dropoff: _destinationController.text,
              companyId: companyId,
            );
            
            // Store the estimate value
            setState(() {
              estimate = calculatedEstimate;
              total = calculatedEstimate;
            });
            
            _goToStep(1);
          },
        );
      case 1:
        return BottomBarInput(
          cancelText: 'Back',
          primaryText: 'Next',
          onCancel: () {
            _goToStep(0);
          },
          onPrimary: () {
            _goToStep(2);
          },
        );
      case 2:
        return BottomBarInput(
          cancelText: 'Back',
          primaryText: 'Confirm and request',
          onCancel: () {
            // Clear errors when going back
            setState(() {
              _firstNameError = null;
              _lastNameError = null;
              _phoneError = null;
              _emailError = null;
            });
            _goToStep(1);
          },
          onPrimary: () async {
            // Validate all fields have at least 2 characters
            final firstName = _firstNameController.text.trim();
            final lastName = _lastNameController.text.trim();
            final phone = _phoneController.text.trim();
            final email = _emailController.text.trim();
            
            bool isValid = true;
            
            // Clear previous errors
            setState(() {
              _firstNameError = null;
              _lastNameError = null;
              _phoneError = null;
              _emailError = null;
            });
            
            // Validate first name
            if (firstName.length < 2) {
              _firstNameError = 'First name must be at least 2 characters';
              isValid = false;
            }
            
            // Validate last name
            if (lastName.length < 2) {
              _lastNameError = 'Last name must be at least 2 characters';
              isValid = false;
            }
            
            // Validate phone
            if (phone.length < 2) {
              _phoneError = 'Phone must be at least 2 characters';
              isValid = false;
            }
            
            // Validate email (required and at least 2 characters)
            if (email.length < 2) {
              _emailError = 'Email is required and must be at least 2 characters';
              isValid = false;
            }
            
            // Update state to show errors if validation failed
            if (!isValid) {
              setState(() {
                // Errors are already set above
              });
              debugPrint('Validation failed - missing required fields');
              return;
            }
            
            // All validation passed - proceed with controller call
            final companyId = widget.companyUrl ?? '';
            
            // Build vehicle object
            final vehicle = Vehicle(
              year: _yearController.text.trim().isEmpty ? null : _yearController.text.trim(),
              make: _makeController.text.trim().isEmpty ? null : _makeController.text.trim(),
              model: _modelController.text.trim().isEmpty ? null : _modelController.text.trim(),
            );
            
            // Format primary contact (email is required, so use it)
            final primaryContact = email;
            
            // Submit the tow request
            final result = await SchedulingController.submitTowRequest(
              pickup: _pickupController.text.trim(),
              destination: _destinationController.text.trim().isEmpty 
                  ? null 
                  : _destinationController.text.trim(),
              vehicle: vehicle,
              primaryContact: primaryContact,
              companyId: companyId,
            );
            
            if (result != null) {
              debugPrint('Tow request submitted successfully');
              if (widget.onSubmit != null) {
                widget.onSubmit!(result);
              }
            } else {
              debugPrint('Failed to submit tow request');
            }
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  void _goToStep(int step) {
    setState(() {
      currentStep = step;
    });
  }

}
