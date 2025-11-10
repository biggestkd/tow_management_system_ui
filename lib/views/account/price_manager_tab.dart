import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../colors.dart';
import '../../models/pricing.dart';
import '../../utilities/money.dart';

class PriceManagerTab extends StatefulWidget {
  const PriceManagerTab({
    super.key,
    required this.pricingList,
    required this.accountId,
    required this.onSave,
  });

  final List<Pricing> pricingList;
  final String? accountId;
  final Future<void> Function(List<Pricing> prices) onSave;

  @override
  State<PriceManagerTab> createState() => _PriceManagerTabState();
}

class _PriceManagerTabState extends State<PriceManagerTab> {
  late TextEditingController _hookUpFeeController;
  late TextEditingController _perMileAmountController;
  bool _saving = false;
  
  // Use consistent keys for controllers
  static const String hookUpKey = 'hook-up-fee';
  static const String perMileKey = 'per-mile-amount';

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    // Get Hook Up Fee
    final hookUpFee = widget.pricingList.firstWhere(
      (p) => p.itemName.toLowerCase().contains('hook'),
      orElse: () => Pricing(
        id: '',
        itemName: 'Hook Up Fee',
        amount: 0,
        companyId: widget.accountId ?? '',
      ),
    );

    // Get Per Mile Amount
    final perMileAmount = widget.pricingList.firstWhere(
      (p) => p.itemName.toLowerCase().contains('mile') || p.itemName.toLowerCase().contains('per mile'),
      orElse: () => Pricing(
        id: '',
        itemName: 'Per Mile Amount',
        amount: 0,
        companyId: widget.accountId ?? '',
      ),
    );

    _hookUpFeeController = TextEditingController(
      text: '${(hookUpFee.amount / 100).toStringAsFixed(2)}',
    );
    _perMileAmountController = TextEditingController(
      text: '${(perMileAmount.amount / 100).toStringAsFixed(2)}',
    );
  }

  @override
  void didUpdateWidget(PriceManagerTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Always reset controllers when widget updates (tab switch) to discard unsaved edits
    // This ensures that switching tabs always shows the saved data from AccountInformationScreen
    _initializeControllers();
  }

  @override
  void dispose() {
    _hookUpFeeController.dispose();
    _perMileAmountController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (widget.accountId == null || widget.accountId!.isEmpty) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      // Build updated pricing list
      final List<Pricing> updatedPricingList = [];

      // Get existing Hook Up Fee or create placeholder
      final existingHookUp = widget.pricingList.firstWhere(
        (p) => p.itemName.toLowerCase().contains('hook'),
        orElse: () => Pricing(
          id: '',
          itemName: 'Hook Up Fee',
          amount: 0,
          companyId: widget.accountId!,
        ),
      );

      final hookUpAmount = dollarsToCents(_hookUpFeeController.text) ?? existingHookUp.amount;
      updatedPricingList.add(Pricing(
        id: existingHookUp.id,
        itemName: 'Hook Up Fee',
        amount: hookUpAmount,
        companyId: widget.accountId!,
      ));

      // Get existing Per Mile Amount or create placeholder
      final existingPerMile = widget.pricingList.firstWhere(
        (p) => p.itemName.toLowerCase().contains('mile') || p.itemName.toLowerCase().contains('per mile'),
        orElse: () => Pricing(
          id: '',
          itemName: 'Per Mile Amount',
          amount: 0,
          companyId: widget.accountId!,
        ),
      );

      final perMileAmount = dollarsToCents(_perMileAmountController.text) ?? existingPerMile.amount;
      updatedPricingList.add(Pricing(
        id: existingPerMile.id,
        itemName: 'Per Mile Amount',
        amount: perMileAmount,
        companyId: widget.accountId!,
      ));

      // Call onSave with the updated pricing list
      await widget.onSave(updatedPricingList);
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
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
                    'Pricing Information',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildPricingTable(theme),
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

  Widget _buildPricingTable(ThemeData theme) {
    return Table(
      border: TableBorder.all(
        color: AppColors.border,
        width: 1,
      ),
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: AppColors.gray100,
          ),
          children: [
            _buildTableCell('Item Name', theme, isHeader: true),
            _buildTableCell('Amount', theme, isHeader: true),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Hook Up Fee', theme),
            _buildEditableTableCell(
              _hookUpFeeController,
              theme,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Per Mile Amount', theme),
            _buildEditableTableCell(
              _perMileAmountController,
              theme,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTableCell(String text, ThemeData theme, {bool isHeader = false}) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
          color: isHeader ? AppColors.textPrimary : AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildEditableTableCell(TextEditingController controller, ThemeData theme, {TextInputType? keyboardType}) {
    return Container(
      padding: const EdgeInsets.all(8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: AppColors.textPrimary,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: AppColors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 8,
          ),
        ),
      ),
    );
  }
}

