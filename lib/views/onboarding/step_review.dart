import 'package:flutter/material.dart';
import '../../models/account.dart';

class StepReview extends StatelessWidget {
  const StepReview({
    super.key,
    required this.email,
    required this.account,
  });

  final String email;
  final Account? account;

  @override
  Widget build(BuildContext context) {
    if (account == null) {
      return const Text('No account loaded.');
    }

    // Parse "Phone: x | Website: y | Address: z" -> { phone, website, address }
    final parsed = _parseCompanyInfo(account!.companyInformation);

    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Review & Confirm', style: theme.textTheme.titleMedium),
        const SizedBox(height: 12),

        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceVariant,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _row('Email', email.trim().isNotEmpty ? email.trim() : '—'),
                const Divider(height: 20),
                _row('Phone', parsed['phone'] ?? '—'),
                _row('Website', parsed['website'] ?? '—'),
                _row('Address', parsed['address'] ?? '—'),
                const Divider(height: 20),
                _row('Account ID', account!.id),
                _row('Stripe Account', account!.stripeAccountId.isEmpty ? '—' : account!.stripeAccountId),
              ],
            ),
          ),
        ),

        const Spacer(),
      ],
    );
  }

  /// Renders a label/value row with consistent spacing.
  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  /// Converts "Phone: 123 | Website: https://... | Address: City, ST"
  /// into a map { phone, website, address } (lowercased keys).
  Map<String, String> _parseCompanyInfo(String raw) {
    final result = <String, String>{};
    if (raw.isEmpty) return result;
    for (final part in raw.split(' | ')) {
      final idx = part.indexOf(':');
      if (idx <= 0) continue;
      final key = part.substring(0, idx).trim().toLowerCase();   // e.g., "phone"
      final val = part.substring(idx + 1).trim();                // e.g., "123"
      if (key == 'phone') result['phone'] = val;
      if (key == 'website') result['website'] = val;
      if (key == 'address') result['address'] = val;
    }
    return result;
  }
}

