import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/views/scheduling/vehicle_section_input.dart';
import '../../models/tow.dart';
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
            
            // TODO: Extract companyId from companyUrl or add as parameter
            // For now using empty string - this needs to be fixed
            final companyId = widget.companyUrl ?? '';
            
            final calculatedTotal = await SchedulingController.calculateTowPrice(
              pickup: _pickupController.text,
              dropoff: _destinationController.text,
              companyId: companyId,
            );
            
            setState(() {
              total = calculatedTotal;
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
            _goToStep(1);
          },
          onPrimary: () {
            // TODO: Implement confirm and request logic
            debugPrint('Confirm and request pressed');
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
