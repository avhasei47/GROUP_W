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
import '../models/student_application.dart';
import '../services/application_service.dart';

class AdminViewModel extends ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();

  List<StudentApplication> _applications = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<StudentApplication> get applications => _applications;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

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

  Future<void> approveApplication(String applicationId) async {
    await _updateStatus(applicationId, 'Approved');
  }

  Future<void> rejectApplication(String applicationId) async {
    await _updateStatus(applicationId, 'Rejected');
  }

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
