// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4.  Mdolo Kwanele – 223088602 
// 5.  Mchunu Precious  – 222078878 
// File: main.dart
// Description: App entry point. Initializes Supabase and sets up providers.
// ============================================

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/supabase_config.dart';
import 'routes/route_manager.dart';
import 'theme/app_theme.dart';
import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/application_viewmodel.dart';

void main() async {
  // Ensure Flutter binding is initialized before calling async functions
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase connection
  await SupabaseConfig.initialize();

  // Start the app
  runApp(const StudentAssistantApp());
}

class StudentAssistantApp extends StatelessWidget {
  const StudentAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider provides multiple ViewModels to the entire app
    return MultiProvider(
      providers: [
        // Provider for authentication (login, logout, user role)
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),
        // Provider for application data (create, read, update, delete)
        ChangeNotifierProvider<ApplicationViewModel>(
          create: (_) => ApplicationViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Student Assistant Application System',
        theme: AppTheme.lightTheme,
        initialRoute: RouteManager.login,
        onGenerateRoute: RouteManager.generateRoute,
      ),
    );
  }
}
