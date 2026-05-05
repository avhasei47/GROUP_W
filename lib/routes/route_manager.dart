import 'package:flutter/material.dart';
import '../views/login_screen.dart';
import '../views/student_home_screen.dart';
import '../views/application_form_screen.dart';
import '../views/application_detail_screen.dart';
import '../views/edit_application_screen.dart';

class RouteManager {
  static const String login = '/';
  static const String studentHome = '/student-home';
  static const String applicationForm = '/application-form';
  static const String applicationDetail = '/application-detail';
  static const String editApplication = '/edit-application';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case studentHome:
        return MaterialPageRoute(builder: (_) => const StudentHomeScreen());
      case applicationForm:
        return MaterialPageRoute(builder: (_) => const ApplicationFormScreen());
      case applicationDetail:
        return MaterialPageRoute(
          builder: (_) => const ApplicationDetailScreen(),
        );
      case editApplication:
        return MaterialPageRoute(builder: (_) => const EditApplicationScreen());
      default:
        throw Exception('Route not found');
    }
  }
}
