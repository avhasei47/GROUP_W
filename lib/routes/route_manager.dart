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
import '../views/login_screen.dart';
import '../views/student_home_screen.dart';
import '../views/application_form_screen.dart';
import '../views/application_detail_screen.dart';
import '../views/edit_application_screen.dart';

class RouteManager {
  // Static route names (constants)
  static const String login = '/';
  static const String studentHome = '/student-home';
  static const String applicationForm = '/application-form';
  static const String applicationDetail = '/application-detail';
  static const String editApplication = '/edit-application';

  // Generate route dynamically based on route name
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
