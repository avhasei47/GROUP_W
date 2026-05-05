import '../config/supabase_config.dart';

class AuthService {
  Future<void> login(String email, String password) async {
    await SupabaseConfig.client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await SupabaseConfig.client.auth.signOut();
  }

  Future<String> getUserRole() async {
    final user = SupabaseConfig.client.auth.currentUser;

    if (user == null) {
      throw Exception('No logged in user found.');
    }

    final response = await SupabaseConfig.client
        .from('profiles')
        .select('role')
        .eq('id', user.id)
        .single();

    return response['role'];
  }
}