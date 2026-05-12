// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4.  Mdolo Kwanele – 223088602 
// 5.  Mchunu Precious  – 222078878
// File: auth_service.dart
// Description: Handles authentication - login, logout, and getting user role from Supabase.
// ============================================

import '../config/supabase_config.dart';

class AuthService {
  // Login user with email and password using Supabase Auth
  Future<void> login(String email, String password) async {
    await SupabaseConfig.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  // Logout current user
  Future<void> logout() async {
    await SupabaseConfig.client.auth.signOut();
  }

  // Get the role of the logged-in user from the 'profiles' table
  Future<String> getUserRole() async {
    final user = SupabaseConfig.client.auth.currentUser;

    // Throw error if no user is logged in
    if (user == null) {
      throw Exception('No logged in user found.');
    }

    // Query the profiles table to get the user's role
    final response = await SupabaseConfig.client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .single();

    return response['role'];  // Returns 'student' or 'admin'
  }
}
