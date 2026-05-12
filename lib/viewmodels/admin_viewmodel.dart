// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4.  Mdolo Kwanele – 223088602 
// 5.  Mchunu Precious  – 222078878
// File: admin_viewmodel.dart
// Description: ViewModel for authentication - handles login, logout, user state.
// ============================================

import 'package:flutter/material.dart';
import '../models/student_application.dart';
import '../services/application_service.dart';

// Manages admin‑specific state and business logic for reviewing
// and updating student assistant applications.
//
// Uses the MVVM pattern with Provider. This ViewModel fetches all
// applications, allows approving/rejecting, and updates the UI
// via notifyListeners().

class AdminViewModel extends ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();

  // Internal list of all student applications
  List<StudentApplication> _applications = [];
  bool _isLoading = false;
  String? _errorMessage;

  
  // The current list of applications (read‑only for the UI)
  List<StudentApplication> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Fetches all student assistant applications from Supabase via the service layer.
  // Sets `_isLoading` to `true` while fetching, clears any previous error,
  // and updates the UI before and after the asynchronous call.
  // If an error occurs, `_errorMessage` is set and displayed to the user
  
  Future<void> fetchApplications() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _applications = await _applicationService.getAllApplications();
    } catch (e) {
      _errorMessage = 'Failed to load applications: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Approves the application with the given ID
  Future<void> approveApplication(String applicationId) async {
    await _updateStatus(applicationId, 'Approved');
  }

  // Rejects the application with the given ID
  Future<void> rejectApplication(String applicationId) async {
    await _updateStatus(applicationId, 'Rejected');
  }

  // Internal helper that updates the status of an application both remotely and locally.
  //
  // - Calls `ApplicationService.updateApplicationStatus()` to persist the change.
  // - Updates the local `_applications` list with the new status.
  // - Notifies listeners to refresh the UI.
  Future<void> _updateStatus(String applicationId, String status) async {
    try {
      await _applicationService.updateApplicationStatus(
        applicationId: applicationId,
        status: status,
      );

      final index = _applications.indexWhere(
        (app) => app.id == applicationId,
      );

      if (index != -1) {
        _applications[index] = _applications[index].copyWith(
          status: status,
        );
      }

      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to update status: $e';
      notifyListeners();
    }
  }
}
