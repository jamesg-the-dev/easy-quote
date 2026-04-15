import 'package:flutter/foundation.dart';

/// SignupStore: Manages signup form state across multiple screens
/// 
/// This is a state management solution that persists signup data
/// when navigating back and forward during the signup flow.
/// 
/// Architecture:
/// - Extends ChangeNotifier for reactive updates via Provider
/// - Stores complete signup form data as a data model
/// - Provides getter/setter methods for clean API
/// - Supports partial form validation at each step
/// - Handles form reset when signup flow completes
class SignupStore extends ChangeNotifier {
  /// Internal state model
  _SignupFormData _formData = _SignupFormData();

  /// Email & Authentication
  String get email => _formData.email;
  set email(String value) {
    _formData.email = value;
    notifyListeners();
  }

  String get password => _formData.password;
  set password(String value) {
    _formData.password = value;
    notifyListeners();
  }

  String get confirmPassword => _formData.confirmPassword;
  set confirmPassword(String value) {
    _formData.confirmPassword = value;
    notifyListeners();
  }

  /// Personal Details
  String get fullName => _formData.fullName;
  set fullName(String value) {
    _formData.fullName = value;
    notifyListeners();
  }

  String get phoneNumber => _formData.phoneNumber;
  set phoneNumber(String value) {
    _formData.phoneNumber = value;
    notifyListeners();
  }

  /// Business Details
  String get businessName => _formData.businessName;
  set businessName(String value) {
    _formData.businessName = value;
    notifyListeners();
  }

  String get postcode => _formData.postcode;
  set postcode(String value) {
    _formData.postcode = value;
    notifyListeners();
  }

  /// Get all form data as a map (useful for debugging/logging)
  Map<String, dynamic> getFormDataSnapshot() {
    return {
      'email': _formData.email,
      'fullName': _formData.fullName,
      'phoneNumber': _formData.phoneNumber,
      'businessName': _formData.businessName,
      'postcode': _formData.postcode,
    };
  }

  /// Clear all signup data when flow is complete or reset is needed
  void clearSignupData() {
    _formData = _SignupFormData();
    notifyListeners();
  }

  /// Validate email & password step
  bool isStep1Valid() {
    return email.isNotEmpty &&
        password.isNotEmpty &&
        confirmPassword.isNotEmpty &&
        password == confirmPassword;
  }

  /// Validate personal details step
  bool isStep2Valid() {
    return fullName.isNotEmpty;
  }

  /// Validate business details step
  bool isStep3Valid() {
    return businessName.isNotEmpty && postcode.isNotEmpty;
  }
}

/// Internal model for signup form data
class _SignupFormData {
  String email = '';
  String password = '';
  String confirmPassword = '';
  String fullName = '';
  String phoneNumber = '';
  String businessName = '';
  String postcode = '';
}
