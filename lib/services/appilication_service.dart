// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4. Mdolo Kwanele – 223088602 
// 5. Mchunu Precious – 222078878
// File: application_service.dart
// Description: Service class for Supabase CRUD operations on student applications.
//              Handles fetching, creating, updating, and deleting applications.
// ============================================
import 'package:flutter/material.dart';
import '../services/auth_service.dart';

// Service that manages all Supabase interactions for Student Assistant applications.
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = false;
  String _role = '';
  String _errorMessage = '';

  bool get isLoading => _isLoading;
  String get role => _role;
  String get errorMessage => _errorMessage;

  // Authenticates the user with email and password.
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      await _authService.login(email, password);
      _role = await _authService.getUserRole();

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoading = false;
      _role = '';
      _errorMessage = 'Invalid email or password. Please try again.';
      notifyListeners();

      return false;
    }
  }

  // Logs out the current user and clears local authentication state
  Future<void> logout() async {
    await _authService.logout();

    _role = '';
    _errorMessage = '';

    notifyListeners();
  }
}
