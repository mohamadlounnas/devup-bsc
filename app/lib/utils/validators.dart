/// Utility class for form validation
class Validators {
  /// Validates a phone number
  /// Returns null if valid, error message if invalid
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }

    // Remove any whitespace and special characters except + and digits
    final cleanPhone = value.replaceAll(RegExp(r'[^\+\d]'), '');

    // Check if the phone number starts with + and has 10-15 digits
    if (!RegExp(r'^\+?\d{10,15}$').hasMatch(cleanPhone)) {
      return 'Please enter a valid phone number';
    }

    return null;
  }

  /// Validates an email address
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return null; // Email is optional
    }

    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Please enter a valid email address';
    }

    return null;
  }

  /// Validates a name (first name or last name)
  /// Returns null if valid, error message if invalid
  static String? validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }

    if (value.length < 2) {
      return 'Name must be at least 2 characters';
    }

    if (!RegExp(r'^[a-zA-Z\s-]+$').hasMatch(value)) {
      return 'Name can only contain letters, spaces, and hyphens';
    }

    return null;
  }
} 