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

import 'dart:io';
import 'dart:typed_data';
import 'package:path/path.dart' as path;
import 'package:supabase_flutter/supabase_flutter.dart';

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
        .maybeSingle(); // Don't throw error if no application found

    if (response == null) return null;

    return StudentApplication.fromMap(response);
  }

  //Add a new application to the database
  Future<void> createApplication(
    StudentApplication application,
    File? documentFile, {
    Uint8List? documentBytes,
    String? filename,
  }) async {
    String? publicUrl;
    const bucket = 'supporting-document';

    try {
      if (documentBytes != null) {
        final name = _safeStorageName(
          filename ?? 'upload_${DateTime.now().millisecondsSinceEpoch}',
        );
        final storagePath = _storagePath(name);
        await SupabaseConfig.client.storage
            .from(bucket)
            .uploadBinary(
              storagePath,
              documentBytes,
              fileOptions: FileOptions(contentType: _contentType(name)),
            );
        publicUrl = SupabaseConfig.client.storage
            .from(bucket)
            .getPublicUrl(storagePath);
      } else if (documentFile != null) {
        final name = _safeStorageName(
          filename ?? path.basename(documentFile.path),
        );
        final storagePath = _storagePath(name);
        await SupabaseConfig.client.storage
            .from(bucket)
            .upload(
              storagePath,
              documentFile,
              fileOptions: FileOptions(contentType: _contentType(name)),
            );
        publicUrl = SupabaseConfig.client.storage
            .from(bucket)
            .getPublicUrl(storagePath);
      }
    } on StorageException catch (e) {
      throw DocumentUploadException(
        _storageErrorMessage(e),
        statusCode: e.statusCode,
      );
    } on SocketException catch (e) {
      throw DocumentUploadException(
        'Network connection failed while uploading the document: ${e.message}',
      );
    } catch (e) {
      throw DocumentUploadException('Document upload failed: $e');
    }

    final map = application.toMap(currentUserId);
    if (publicUrl != null) map['document_url'] = publicUrl;

    await SupabaseConfig.client.from('applications').insert(map);
  }

  //Change an existing application
  //Only the owner can update their own application
  Future<void> updateApplication(StudentApplication application) async {
    await SupabaseConfig.client
        .from('applications')
        .update(application.toMap(currentUserId))
        .eq('id', application.id)
        //Find the right application by its ID
        .eq(
          'user_id',
          currentUserId,
        ); //Make sure it belongs to the current user
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

  Future<List<StudentApplication>> getAllApplications() async {
    final response = await SupabaseConfig.client
        .from('applications')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((item) => StudentApplication.fromMap(item))
        .toList();
  }

  Future<void> updateApplicationStatus({
    required String applicationId,
    required String status,
  }) async {
    await SupabaseConfig.client
        .from('applications')
        .update({'status': status})
        .eq('id', applicationId);
  }

  String _storagePath(String filename) {
    return 'applications/$currentUserId/${DateTime.now().millisecondsSinceEpoch}_$filename';
  }

  String _safeStorageName(String filename) {
    final extension = path.extension(filename).toLowerCase();
    final baseName = path.basenameWithoutExtension(filename);
    final safeBaseName = baseName
        .replaceAll(RegExp(r'[^A-Za-z0-9_-]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    return '${safeBaseName.isEmpty ? 'document' : safeBaseName}$extension';
  }

  String _contentType(String filename) {
    switch (path.extension(filename).toLowerCase()) {
      case '.pdf':
        return 'application/pdf';
      case '.doc':
        return 'application/msword';
      case '.docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }

  String _storageErrorMessage(StorageException error) {
    final parts = <String>[
      error.message,
      if (error.statusCode != null) 'status ${error.statusCode}',
      if (error.error != null) error.error!,
    ];

    return 'Supabase Storage upload failed: ${parts.join(' - ')}';
  }
}

class DocumentUploadException implements Exception {
  const DocumentUploadException(this.message, {this.statusCode});

  final String message;
  final String? statusCode;

  @override
  String toString() => message;
}
