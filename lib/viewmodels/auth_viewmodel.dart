// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4.  Mdolo Kwanele – 223088602 
// 5.  Mchunu Precious  – 222078878
// File: auth_viewmodel.dart
// Description: ViewModel for authentication - handles login, logout, user state.
// ============================================

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  // Private state variables
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _role = '';
  String _errorMessage = '';

  // Public getters for UI to read data
  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get role => _role;
  String get errorMessage => _errorMessage;

  // LOGIN: Authenticate user and get role
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();  // Update UI - show loading indicator

      await _authService.login(email, password);

      _role = await _authService.getUserRole();
      _isLoggedIn = true;

      _isLoading = false;
      notifyListeners();  // Update UI - hide loading, show success

      return true;
    } catch (error) {
      _isLoggedIn = false;
      _role = '';
      _isLoading = false;
      _errorMessage = 'Invalid email or password. Please try again.';
      notifyListeners();  // Update UI - show error message

      return false;
    }
  }

  // LOGOUT: Sign out user and clear state
  Future<void> logout() async {
    await _authService.logout();

    _isLoggedIn = false;
    _role = '';
    _errorMessage = '';

    notifyListeners();  // Update UI - clear user data
  }
}
