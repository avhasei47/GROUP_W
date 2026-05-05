import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoggedIn = false;
  bool _isLoading = false;
  String _role = '';
  String _errorMessage = '';

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String get role => _role;
  String get errorMessage => _errorMessage;

  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;
      _errorMessage = '';
      notifyListeners();

      await _authService.login(email, password);

      _role = await _authService.getUserRole();
      _isLoggedIn = true;

      _isLoading = false;
      notifyListeners();

      return true;
    } catch (error) {
      _isLoggedIn = false;
      _role = '';
      _isLoading = false;
      _errorMessage = 'Invalid email or password. Please try again.';
      notifyListeners();

      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();

    _isLoggedIn = false;
    _role = '';
    _errorMessage = '';

    notifyListeners();
  }
}
