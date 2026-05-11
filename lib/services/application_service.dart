import '../config/supabase_config.dart';
import '../models/student_application.dart';

class ApplicationService {
  //Get the ID of the logged-in user
  String get currentUserId => SupabaseConfig.client.auth.currentUser!.id;
  
//Get the application of the current user
  //Returns the application if found, otherwise returns null
  Future<StudentApplication?> getMyApplication() async {
    final response = await SupabaseConfig.client
        .from('applications')
        .select()
        .eq('user_id', currentUserId)
        .maybeSingle();// Don't throw error if no application found

    if (response == null) return null;

    return StudentApplication.fromMap(response);
  }
  
//Add a new application to the database
  Future<void> createApplication(StudentApplication application) async {
    await SupabaseConfig.client
        .from('applications')
        .insert(application.toMap(currentUserId));
  }
  
//Change an existing application
  //Only the owner can update their own application
  Future<void> updateApplication(StudentApplication application) async {
    await SupabaseConfig.client
        .from('applications')
        .update(application.toMap(currentUserId))
        .eq('id', application.id)
      //Find the right application by its ID
        .eq('user_id', currentUserId);//Make sure it belongs to the current user
  }

  //Remove an application from the database
  //Only the owner can delete their own application
  Future<void> deleteApplication(String applicationId) async {
    await SupabaseConfig.client
        .from('applications')
        .delete()
        .eq('id', applicationId)
        .eq('user_id', currentUserId);
  }
}
    


    










  







