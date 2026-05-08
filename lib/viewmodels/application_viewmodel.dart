import 'package:flutter/material.dart';

import '../models/student_application.dart';
import '../services/application_service.dart';

class ApplicationViewModel extends ChangeNotifier {
  final ApplicationService _applicationService = ApplicationService();

  StudentApplication? _application;
  bool _isLoading = false;
  String? _errorMessage;

  StudentApplication? get application => _application;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  bool get hasApplication => _application != null;

  bool get canEditOrDelete {
    return _application != null && _application!.status == 'Pending';
  }

  String get studentName => _application?.studentName ?? '';
  String get status => _application?.status ?? 'No Application';
  String get firstModule => _application?.firstModule ?? '';

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

  Future<void> createApplication(StudentApplication newApplication) async {
    if (_application != null) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _applicationService.createApplication(newApplication);

      _application = newApplication;
    } catch (e) {
      _errorMessage = 'Failed to submit application: $e';
    }

    _isLoading = false;
    notifyListeners();
  }

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