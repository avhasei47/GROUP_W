import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'config/supabase_config.dart';
import 'routes/route_manager.dart';
import 'theme/app_theme.dart';

import 'viewmodels/auth_viewmodel.dart';
import 'viewmodels/application_viewmodel.dart';
import 'viewmodels/admin_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SupabaseConfig.initialize();

  runApp(const StudentAssistantApp());
}

class StudentAssistantApp extends StatelessWidget {
  const StudentAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => AuthViewModel()),

        ChangeNotifierProvider<ApplicationViewModel>(
          create: (_) => ApplicationViewModel(),
        ),

        ChangeNotifierProvider<AdminViewModel>(create: (_) => AdminViewModel()),
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
