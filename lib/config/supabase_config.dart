import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseConfig {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://xmexpqhrihtemdelqjnz.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhtZXhwcWhyaWh0ZW1kZWxxam56Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Nzc5NzE3MjAsImV4cCI6MjA5MzU0NzcyMH0.a4cBcKGKy09yv0xbv1ST0trXjRGBoOTqbUYAAIGsCHE',
    );
  }

  static SupabaseClient get client => Supabase.instance.client;
}
