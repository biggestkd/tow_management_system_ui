import 'package:flutter/material.dart';
import '../../colors.dart';
import '../../models/pricing.dart';
import '../../models/rule.dart';

class PriceManagerTab extends StatelessWidget {
  const PriceManagerTab({
    super.key,
    required this.pricingList,
    required this.pricingControllers,
    required this.onSave,
  });

  final List<Pricing> pricingList;
  final Map<String, TextEditingController> pricingControllers;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filter for Hook Up Fee and Per Mile Amount
    final hookUpFee = pricingList.firstWhere(
      (p) => p.itemName.toLowerCase().contains('hook'),
      orElse: () => Pricing(
        id: '', // Placeholder - will be created if doesn't exist
        itemName: 'Hook Up Fee',
        amount: 0.0,
        rule: Rule(unit: '', condition: ''),
        accountId: '',
      ),
    );

    final perMileAmount = pricingList.firstWhere(
      (p) => p.itemName.toLowerCase().contains('mile') || p.itemName.toLowerCase().contains('per mile'),
      orElse: () => Pricing(
        id: '', // Placeholder - will be created if doesn't exist
        itemName: 'Per Mile Amount',
        amount: 0.0,
        rule: Rule(unit: '', condition: ''),
        accountId: '',
      ),
    );

    // Use consistent keys for controllers
    const String hookUpKey = 'hook-up-fee';
    const String perMileKey = 'per-mile-amount';
    
    // Ensure controllers exist for these pricing items
    if (!pricingControllers.containsKey(hookUpKey)) {
      pricingControllers[hookUpKey] = TextEditingController(
        text: hookUpFee.amount.toStringAsFixed(2),
      );
    }
    if (!pricingControllers.containsKey(perMileKey)) {
      pricingControllers[perMileKey] = TextEditingController(
        text: perMileAmount.amount.toStringAsFixed(2),
      );
    }

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
                      onPressed: onSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Save Changes'),
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
    const String hookUpKey = 'hook-up-fee';
    const String perMileKey = 'per-mile-amount';
    
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
              hookUpKey,
              theme,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
            ),
          ],
        ),
        TableRow(
          children: [
            _buildTableCell('Per Mile Amount', theme),
            _buildEditableTableCell(
              perMileKey,
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

  Widget _buildEditableTableCell(String pricingId, ThemeData theme, {TextInputType? keyboardType}) {
    final controller = pricingControllers[pricingId];
    if (controller == null) {
      return _buildTableCell('', theme);
    }

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

