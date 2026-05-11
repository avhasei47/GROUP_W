// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4.  Mdolo Kwanele – 223088602 
// 5.  Mchunu Precious  – 222078878
// File: route_manager.dart
// Description: Centralised navigation - defines all route names and generates routes.
// ============================================

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
 
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
 
  bool _isLoading = false;  //True when loading, false when done
  String _role = '';  //Stores user role
  String _errorMessage = '';  //Stores error message if login fails

 
 //Getters to access private variables from outside
  bool get isLoading => _isLoading;
  String get role => _role;
  String get errorMessage => _errorMessage;

 //Logs in the user ith email and passord
  Future<bool> login(String email, String password) async {
    try {
      _isLoading = true;  //Show loading indicator
      _errorMessage = '';  //Clear any old error message
      notifyListeners();  //Update the screen
       
      await _authService.login(email, password);  //Call the login service
      _role = await _authService.getUserRole();  //Get the user's role a after login
 
      _isLoading = false;
     //Hide loading indicator
      notifyListeners();
     //Update the screen again
      return true;  
     //Login worked
    } catch (error) {
      _isLoading = false;
     
      _errorMessage = error.toString();  //Save the error message
      notifyListeners();
      return false;
    }
  }

 //Logs out the current user
  Future<void> logout() async {
    await _authService.logout();
   //Call the logout service
    _role = '';
    notifyListeners();
  }
}
