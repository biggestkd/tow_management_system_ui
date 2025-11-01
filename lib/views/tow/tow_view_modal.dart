import 'package:flutter/material.dart';
import 'package:tow_management_system_ui/colors.dart';
import 'package:tow_management_system_ui/views/tow/summary_section.dart';
import 'package:tow_management_system_ui/views/tow/top_bar.dart';

import '../../models/tow.dart';
import 'bottom_bar.dart';
import 'locations_section.dart';
import 'vehicle_driver_section.dart';
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
  late List<Widget> _sections;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  void _bootstrap() {
    // Build sections using the separate widget files
    _sections = [
      LocationsSection(tow: widget.tow),
      VehicleDriverSection(tow: widget.tow),
      SummarySection(tow: widget.tow),
      AttachmentsSection(tow: widget.tow),
      NotesSection(tow: widget.tow),
    ];
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
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: 
                  [
                    LocationsSection(tow: widget.tow),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    VehicleDriverSection(tow: widget.tow),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    SummarySection(tow: widget.tow),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    AttachmentsSection(tow: widget.tow),
                    const SizedBox(height: 20),
                    const Divider(height: 1),
                    const SizedBox(height: 20),
                    NotesSection(tow: widget.tow),
                  ],
                ),
              ),
            ),

            const Divider(height: 1),

            // ===== Bottom Section (buttons) =====
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: BottomBar(
                onCancel: widget.onCancel,
                onProceed: widget.onProceed,
                onSave: widget.onSave,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
