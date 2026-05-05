import '../config/supabase_config.dart';
import '../models/student_application.dart';

class ApplicationService {
  String get currentUserId => SupabaseConfig.client.auth.currentUser!.id;

  Future<StudentApplication?> getMyApplication() async {
    final response = await SupabaseConfig.client
        .from('applications')
        .select()
        .eq('user_id', currentUserId)
        .maybeSingle();

    if (response == null) return null;

    return StudentApplication.fromMap(response);
  }

  Future<void> createApplication(StudentApplication application) async {
    await SupabaseConfig.client
        .from('applications')
        .insert(application.toMap(currentUserId));
  }

  Future<void> updateApplication(StudentApplication application) async {
    await SupabaseConfig.client
        .from('applications')
        .update(application.toMap(currentUserId))
        .eq('id', application.id)
        .eq('user_id', currentUserId);
  }

  Future<void> deleteApplication(String applicationId) async {
    await SupabaseConfig.client
        .from('applications')
        .delete()
        .eq('id', applicationId)
        .eq('user_id', currentUserId);
  }
}
    


    










  







