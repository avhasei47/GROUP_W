// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4.  Mdolo Kwanele – 223088602
// 5.  Mchunu Precious  – 222078878
// File: application_viewmodel.dart
// Description: ViewModel for managing student applications - create, read, update, delete.
// ============================================

import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';

import '../models/student_application.dart';
import '../services/application_service.dart';

// Manages the student's own application state (create, read, update, delete).
//
// Follows MVVM pattern with Provider. This ViewModel is responsible for:
// - Fetching the student's existing application (if any)
// - Submitting a new application (only one per student)
// - Updating a pending application
// - Deleting a pending application
// - Exposing computed properties like `canEditOrDelete` based on application status
class ApplicationViewModel extends ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();

  // The student's current application, or `null` if none exists
  StudentApplication? _application;

  // Indicates whether a network operation (fetch, create, update, delete) is in progress
  bool _isLoading = false;
  bool _isUploading = false;

  // Stores an error message from the last failed operation; otherwise `null`
  String? _errorMessage;
  String? _uploadError;

  // The current application read‑only for the UI
  StudentApplication? get application => _application;

  // Whether a background operation is active (used to show a loading indicator)
  bool get isLoading => _isLoading;

  bool get isUploading => _isUploading;

  // The most recent error message, or `null` if no error occurred
  String? get errorMessage => _errorMessage;
  String? get uploadError => _uploadError;

  // Returns `true` if the student has already submitted an application
  bool get hasApplication => _application != null;

  // Returns `true` if the application exists and is still 'Pending'
  bool get canEditOrDelete {
    return _application != null && _application!.status == 'Pending';
  }

  // The student's name (empty string if no application)
  String get studentName => _application?.studentName ?? '';

  // The current status of the application (e.g., 'Pending', 'Approved', 'Rejected')
  String get status => _application?.status ?? 'No Application';

  // The name of the first module the student applied for
  String get firstModule => _application?.firstModule ?? '';

  // Fetches the logged‑in student's application from Supabase
  Future<void> fetchMyApplication() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _application = await _applicationService.getMyApplication();
    } catch (e) {
      _errorMessage = 'Failed to load application: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Submits a new student assistant application
  Future<void> createApplication(
    StudentApplication newApplication, {
    File? documentFile,
    Uint8List? documentBytes,
    String? filename,
  }) async {
    if (_application != null) {
      return;
    }

    _isLoading = true;
    _isUploading = documentFile != null || documentBytes != null;
    _errorMessage = null;
    _uploadError = null;
    notifyListeners();

    try {
      await _applicationService.createApplication(
        newApplication,
        documentFile,
        documentBytes: documentBytes,
        filename: filename,
      );
      _application = newApplication;
    } catch (e) {
      _errorMessage = 'Failed to submit application: $e';
      _uploadError = e.toString();
    }

    _isLoading = false;
    _isUploading = false;
    notifyListeners();
  }

  // Updates an existing application, but only if its status is 'Pending'.
  //
  // All parameters are optional; only provided fields will be updated.
  // The method creates an updated copy of the application and persists it
  // via the service layer. If the update succeeds, the local copy is replaced.
  //
  Future<void> updateApplication({
    String? studentName,
    String? yearOfStudy,
    String? firstAcademicLevel,
    String? firstModule,
    String? secondAcademicLevel,
    String? secondModule,
    bool? confirmedEligibility,
  }) async {
    if (_application == null) {
      return;
    }

    if (_application!.status != 'Pending') {
      return;
    }

    final updatedApplication = _application!.copyWith(
      studentName: studentName,
      yearOfStudy: yearOfStudy,
      firstAcademicLevel: firstAcademicLevel,
      firstModule: firstModule,
      secondAcademicLevel: secondAcademicLevel,
      secondModule: secondModule,
      confirmedEligibility: confirmedEligibility,
    );

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _applicationService.updateApplication(updatedApplication);
      _application = updatedApplication;
    } catch (e) {
      _errorMessage = 'Failed to update application: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Deletes the student's application, but only if its status is 'Pending'.
  //
  // After a successful deletion, `_application` is set to `null` and the UI
  // reflects that no application exists
  Future<void> deleteApplication() async {
    final application = _application;

    if (application == null) {
      return;
    }

    if (application.status != 'Pending') {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _applicationService.deleteApplication(application.id);
      _application = null;
    } catch (e) {
      _errorMessage = 'Failed to delete application: $e';
    }

    _isLoading = false;
    notifyListeners();
  }
}

/*I used private model data inside the ViewModel.
The View accesses the data through public getters.
The View cannot directly edit the model.
When the student submits, updates, or deletes an application, the ViewModel updates the model and calls notifyListeners().
Provider then rebuilds the affected screens.*/
