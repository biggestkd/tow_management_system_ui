/// lib/utilities/validator.dart
///
/// Stateless validation helpers for forms.
/// Return `null` for valid input, or an error message for invalid input.

/// Generic "required" validator.
String? validateNotEmpty(String? value, {String field = 'Field'}) {
  if (value == null || value.trim().isEmpty) {
    return '$field is required';
  }
  return null;
}

/// Email validator (lightweight, practical for UI forms).
String? validateEmail(String? value) {
  if (value == null || value.trim().isEmpty) return 'Email is required';
  final v = value.trim();
  final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  if (!emailRegex.hasMatch(v)) return 'Enter a valid email';
  return null;
}

/// Password validator (min length; extend with symbols/numbers as needed).
String? validatePassword(String? value, {int min = 8}) {
  if (value == null || value.isEmpty) return 'Password is required';
  if (value.length < min) return 'Password must be at least $min characters';
  return null;
}

/// Phone number validator (digits only, 10–15 digits).
String? validatePhone(String? value, {String field = 'Phone'}) {
  if (value == null || value.trim().isEmpty) return '$field is required';
  final digits = value.replaceAll(RegExp(r'\D'), '');
  if (digits.length < 10 || digits.length > 15) {
    return 'Enter a valid $field';
  }
  return null;
}

/// Website/URL validator (optional field by default).
String? validateWebsite(String? value, {bool required = false, String field = 'Website'}) {
  final v = value?.trim() ?? '';
  if (v.isEmpty) return required ? '$field is required' : null;

  final uri = Uri.tryParse(v);
  if (uri == null || !(uri.hasScheme && (uri.isAbsolute))) {
    return 'Enter a valid URL (e.g., https://example.com)';
  }
  return null;
}

/// Address validator (single or multi-line).
String? validateAddress(String? value, {String field = 'Address'}) {
  if (value == null || value.trim().isEmpty) return '$field is required';
  if (value.trim().length < 5) return 'Enter a more complete $field';
  return null;
}

/// Generic numeric validator (e.g., amounts, mileage).
String? validateNumeric(String? value, {String field = 'Value', bool allowNegative = false}) {
  if (value == null || value.trim().isEmpty) return '$field is required';
  final v = double.tryParse(value.trim());
  if (v == null) return '$field must be a number';
  if (!allowNegative && v < 0) return '$field must be ≥ 0';
  return null;
}
