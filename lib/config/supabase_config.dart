// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4. Mdolo Kwanele – 223088602 
// 5. Mchunu Precious – 222078878
// File: supabase_config.dart
// Description: Centralized Supabase initialization and configuration.
//              Provides a singleton client for database and auth operations.
// ============================================
import 'package:supabase_flutter/supabase_flutter.dart';

// Handles the initialization and configuration of Supabase for the app
class SupabaseConfig {

  // Initializes the Supabase SDK with the project's credentials.
  //
  // Must be called before any Supabase operations (e.g., in `main()`).
  // Uses the project URL and anonymous key from the Supabase dashboard.
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://xmexpqhrihtemdelqjnz.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhtZXhwcWhyaWh0ZW1kZWxxam56Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc5NzE3MjAsImV4cCI6MjA5MzU0NzcyMH0.a4cBcKGKy09yv0xbv1ST0trXjRGBoOTqbUYAAIGsCHE',
    );
  }

  // Provides a global Supabase client instance for database and auth operations
  static SupabaseClient get client => Supabase.instance.client;
}
