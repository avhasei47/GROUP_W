// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4. Mdolo Kwanele – 223088602 
// 5. Mchunu Precious – 222078878
// File: main.dart
// Description: Entry point of the application. Initializes Supabase,
//              sets up MVVM providers, and configures routing.
// ============================================
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/supabase_config.dart';
import 'routes/route_manager.dart';
import 'theme/app_theme.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/application_viewmodel.dart';
import 'viewmodels/admin_viewmodel.dart';

// The application's entry point.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseConfig.initialize();

  runApp(const StudentAssistantApp());
}

// The root widget of the application
class StudentAssistantApp extends StatelessWidget {
  const StudentAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      // Registers all ViewModels with Provider so they can be accessed anywhere
      providers: [
        // Manages authentication state
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),

        ChangeNotifierProvider<ApplicationViewModel>(
          create: (_) => ApplicationViewModel(),
        ),

        ChangeNotifierProvider<AdminViewModel>(create: (_) => AdminViewModel()),
      ],
      child: MaterialApp(
        // Removes the "DEBUG" banner in the top‑right corner
        debugShowCheckedModeBanner: false,
        title: 'Student Assistant Application System',
        // Applies the custom light theme (defined in AppTheme)
        theme: AppTheme.lightTheme,
        // The first screen shown when the app launches (login screen).
        initialRoute: RouteManager.login,
        // Uses named routes defined in RouteManager to handle navigation
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}
