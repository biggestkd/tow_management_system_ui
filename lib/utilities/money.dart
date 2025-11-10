/// Converts a dollar amount string (e.g. "12.34") into an integer number of cents (e.g. 1234).
int dollarsToCents(String amount) {
  // Remove any non-numeric characters except the decimal point
  final sanitized = amount.replaceAll(RegExp(r'[^0-9.]'), '');

  if (sanitized.isEmpty) return 0;

  // Parse as double and convert to cents
  final doubleValue = double.tryParse(sanitized) ?? 0.0;

  // Round to handle cases like 12.345 -> 1235
  return (doubleValue * 100).round();
}

/// Converts an integer number of cents (e.g. 1234) into a formatted dollar string (e.g. "$12.34").
String centsToDollars(int cents) {
  // Ensure positive and round to two decimal places
  final dollars = (cents / 100).toStringAsFixed(2);
  return '\$$dollars';
}
