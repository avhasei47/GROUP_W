import 'package:flutter/material.dart';
import '../models/student_application.dart';

class ApplicationViewModel extends ChangeNotifier {
  StudentApplication? _application;

  // READ access for screens
  StudentApplication? get application => _application;

  bool get hasApplication => _application != null;

  bool get canEditOrDelete {
    return _application != null && _application!.status == 'Pending';
  }

  String get studentName => _application?.studentName ?? '';
  String get status => _application?.status ?? 'No Application';
  String get firstModule => _application?.firstModule ?? '';

  // CREATE operation
  void createApplication(StudentApplication newApplication) {
    if (_application != null) {
      return; // one application only
    }

    _application = newApplication;
    notifyListeners();
  }

  // UPDATE operation
  void updateApplication({
    String? studentName,
    String? yearOfStudy,
    String? firstAcademicLevel,
    String? firstModule,
    String? secondAcademicLevel,
    String? secondModule,
    bool? confirmedEligibility,
  }) {
    if (_application == null) {
      return;
    }

    if (_application!.status != 'Pending') {
      return;
    }

    _application = _application!.copyWith(
      studentName: studentName,
      yearOfStudy: yearOfStudy,
      firstAcademicLevel: firstAcademicLevel,
      firstModule: firstModule,
      secondAcademicLevel: secondAcademicLevel,
      secondModule: secondModule,
      confirmedEligibility: confirmedEligibility,
    );

    notifyListeners();
  }

  // DELETE operation
  void deleteApplication() {
    final application = _application;

    if (application == null) {
      return;
    }

    if (application.status != 'Pending') {
      return;
    }

    _application = null;
    notifyListeners();
  }
}
/*I used private model data inside the ViewModel.
The View accesses the data through public getters.
The View cannot directly edit the model.
When the student submits, updates, or deletes an application, the ViewModel updates the model and calls notifyListeners().
Provider then rebuilds the affected screens.*/