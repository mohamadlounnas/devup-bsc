/// Utility class for form validation
class Validators {
  /// Validates a phone number
  /// Returns null if valid, error message if invalid
  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Phone number is required';
    }

    // Remove any whitespace and special characters except + and digits
    final cleanPhone = value.replaceAll(RegExp(r'[^\+\d]'), '');

    // Check if the phone number starts with + and has 10-15 digits
    if (!RegExp(r'^\+?\d{10,15}$').hasMatch(cleanPhone)) {
      return 'Please enter a valid phone number (e.g., +213XXXXXXXXX)';
    }

    return null;
  }

  /// Validates an email address
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
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

  /// Validates a national ID
  /// Returns null if valid, error message if invalid
  static String? validateNationalId(String? value) {
    if (value == null || value.isEmpty) {
      return 'National ID is required';
    }

    // Add your specific national ID validation rules here
    if (value.length < 5) {
      return 'National ID must be at least 5 characters';
    }

    return null;
  }

  /// Validates a place of birth
  /// Returns null if valid, error message if invalid
  static String? validatePlaceOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Place of birth is required';
    }

    if (value.length < 2) {
      return 'Place of birth must be at least 2 characters';
    }

    return null;
  }

  /// Validates a date of birth
  /// Returns null if valid, error message if invalid
  static String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Date of birth is required';
    }

    return null;
  }
} 