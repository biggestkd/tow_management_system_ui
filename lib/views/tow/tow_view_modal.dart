import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tow_management_system_ui/colors.dart';
import 'package:tow_management_system_ui/views/tow/summary_section.dart';
import 'package:tow_management_system_ui/views/tow/top_bar.dart';

import '../../models/tow.dart';
import '../../controllers/tow_controller.dart';
import 'bottom_bar.dart';
import 'history_section.dart';
import 'locations_section.dart';
import 'vehicle_section.dart';
import 'driver_section.dart';
import 'attachments_section.dart';
import 'notes_section.dart';

class TowViewModal extends StatefulWidget {
  const TowViewModal({
    super.key,
    required this.tow,
    required this.towStatus,
    this.onCancel,
    this.onProceed,
    this.onSave,
  });

  final Tow tow;
  final String towStatus;
  final VoidCallback? onCancel;
  final VoidCallback? onProceed;
  final VoidCallback? onSave;

  @override
  State<TowViewModal> createState() => _TowViewModalState();
}

class _TowViewModalState extends State<TowViewModal> {
  Tow? _tow;
  bool _isLoading = true;
  String? _error;

  // Text controllers for all string fields
  late TextEditingController _destinationController;
  late TextEditingController _pickupController;
  late TextEditingController _vehicleYearController;
  late TextEditingController _vehicleMakeController;
  late TextEditingController _vehicleModelController;
  late TextEditingController _vehicleStateController;
  late TextEditingController _vehiclePlateNumberController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with empty values - will be updated when tow loads
    _destinationController = TextEditingController();
    _pickupController = TextEditingController();
    _vehicleYearController = TextEditingController();
    _vehicleMakeController = TextEditingController();
    _vehicleModelController = TextEditingController();
    _vehicleStateController = TextEditingController();
    _vehiclePlateNumberController = TextEditingController();
    _notesController = TextEditingController();
    _bootstrap();
  }

  @override
  void dispose() {
    _destinationController.dispose();
    _pickupController.dispose();
    _vehicleYearController.dispose();
    _vehicleMakeController.dispose();
    _vehicleModelController.dispose();
    _vehicleStateController.dispose();
    _vehiclePlateNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _initializeControllers(Tow tow) {
    _destinationController.text = tow.destination ?? '';
    _pickupController.text = tow.pickup ?? '';
    _vehicleYearController.text = tow.vehicle?.year ?? '';
    _vehicleMakeController.text = tow.vehicle?.make ?? '';
    _vehicleModelController.text = tow.vehicle?.model ?? '';
    _vehicleStateController.text = tow.vehicle?.state ?? '';
    _vehiclePlateNumberController.text = tow.vehicle?.plateNumber ?? '';
    _notesController.text = tow.notes ?? '';
  }

  void _bootstrap() {
    // Load the latest tow data on init using the controller, then render sections with a single shared instance
    final incomingTow = widget.tow;
    final incomingId = incomingTow.id;
    
    // Initialize controllers with initial tow data
    _initializeControllers(incomingTow);
    
    if (incomingId == null || incomingId.isEmpty) {
      setState(() {
        _tow = incomingTow;
        _isLoading = false;
      });
      return;
    }

    TowController.loadTowData(incomingId).then((loaded) {
      final towToUse = loaded ?? incomingTow;
      _initializeControllers(towToUse);
      setState(() {
        _tow = towToUse;
        _isLoading = false;
      });
    }).catchError((e) {
      setState(() {
        _tow = incomingTow;
        _isLoading = false;
        _error = 'Failed to load tow';
      });
    });
  }

  void _updateTowNotes(String value) {
    final current = _tow ?? widget.tow;
    _tow = Tow(
      id: current.id,
      destination: current.destination,
      pickup: current.pickup,
      vehicle: current.vehicle,
      primaryContact: current.primaryContact,
      attachments: current.attachments,
      notes: value,
      history: current.history,
      status: current.status,
      companyId: current.companyId,
      createdAt: current.createdAt,
      price: current.price,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    // Use 32% width and 90% height on large screens (>= 768px width), 90% width on smaller screens
    final isLargeScreen = screenSize.width >= 768;
    final maxWidth = isLargeScreen ? screenSize.width * 0.30 : screenSize.width * 0.9;
    final maxHeight = screenSize.height * 0.9;
    final minHeight = maxHeight;

    // Centered dialog with max constraints
    return Center(
      child: Container(
        constraints: BoxConstraints(
          maxWidth: maxWidth,
          maxHeight: maxHeight,
          minHeight: minHeight,
        ),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(blurRadius: 18, offset: Offset(0, 6), color: Colors.black26),
          ],
        ),
        child: Column(
          mainAxisSize: isLargeScreen ? MainAxisSize.max : MainAxisSize.min,
          children: [
            // ===== Top Section =====
            TopBar(
              status: widget.towStatus,
              onClose: () => Navigator.of(context).maybePop(),
            ),

            const Divider(height: 1),

            // ===== Middle Section (scrollable content area) =====
            Flexible(
              child: _isLoading
                  ? const Center(child: Padding(padding: EdgeInsets.all(24), child: CircularProgressIndicator()))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (_error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: Text(_error!, style: theme.textTheme.bodySmall?.copyWith(color: Colors.red)),
                            ),
                          LocationsSection(
                            pickupController: _pickupController,
                            destinationController: _destinationController,
                          ),
                          const SizedBox(height: 20),
                          VehicleSection(
                            yearController: _vehicleYearController,
                            makeController: _vehicleMakeController,
                            modelController: _vehicleModelController,
                            stateController: _vehicleStateController,
                            plateNumberController: _vehiclePlateNumberController,
                          ),
                          const SizedBox(height: 20),
                          DriverSection(tow: _tow ?? widget.tow),
                          const SizedBox(height: 20),
                          // AttachmentsSection(tow: _tow ?? widget.tow),
                          // const SizedBox(height: 20),
                          // NotesSection(
                          //   controller: _notesController,
                          //   onChanged: _updateTowNotes,
                          // ),
                          // const SizedBox(height: 20),
                          SummarySection(tow: _tow ?? widget.tow),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
            ),

            const Divider(height: 1),

            // ===== Bottom Section (buttons) =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: BottomBar(
                status: widget.towStatus ?? 'pending',
                onStatusChange: (newStatus) async {
                  final towId = widget.tow.id;
                  if (towId != null && towId.isNotEmpty) {
                    final success = await TowController.updateTowStatus(towId, newStatus);
                    if (success) {
                      // Close modal and return true to indicate status change
                      Navigator.of(context).pop(true);
                    } else {
                      // Show error but still close modal
                      Navigator.of(context).pop(true);
                    }
                  } else {
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
