// ============================================
// TPG316C Group Assignment – Student Assistant App
// Group: GROUP_W
// Members:
// 1. Ramabulana Avhasei – 221007752
// 2. Jokazi Nothabile –  223060076
// 3. Lesego Mochai –  222046558
// 4. Mdolo Kwanele – 223088602 
// 5. Mchunu Precious – 222078878
// File: student_application.dart
// Description: Data model representing a Student Assistant application.
//              Handles serialization (to/from JSON) and immutable updates.
// ============================================


// Represents a complete Student Assistant application submitted by a student.
//
// This model maps to the `applications` table in Supabase. It contains:
// - Student personal information (name, year of study)
class StudentApplication {
  // Unique identifier of the application UUID from Supabase
  final String id;
  // ID of the authenticated user who submitted the application
  final String userId;
  // Full name of the student applicant
  final String studentName;
  // Academic year of study
  final String yearOfStudy;
  // Academic level for the first module
  final String firstAcademicLevel;
  // Name of the first module the student applies to assist with
  final String firstModule;
  // Academic level for the second module
  final String? secondAcademicLevel;
  // Name of the second module
  final String? secondModule;
  // Whether the student confirms they meet the minimum requirements
  final bool confirmedEligibility;
  // Current status of the application: 'Pending', 'Approved', or 'Rejected'
  final String status;
  // URL of any uploaded supporting document
  final String? documentUrl;
  // Timestamp when the application was created (set by Supabase automatically)
  final DateTime? createdAt;

  // Creates a new StudentApplication instance with all required fields
  StudentApplication({
    required this.id,
    required this.userId,
    required this.studentName,
    required this.yearOfStudy,
    required this.firstAcademicLevel,
    required this.firstModule,
    this.secondAcademicLevel,
    this.secondModule,
    required this.confirmedEligibility,
    required this.status,
    this.documentUrl,
    this.createdAt,
  });

  // Creates a StudentApplication instance from a Supabase query result map.
  //
  // Handles type conversions safely (e.g., `id` may be returned as a String).
  // Missing fields default to appropriate values (empty strings, false, or 'Pending').
  factory StudentApplication.fromMap(Map<String, dynamic> map) {
    return StudentApplication(
      id: map['id']?.toString() ?? '',
      userId: map['user_id']?.toString() ?? '',
      studentName: map['student_name']?.toString() ?? '',
      yearOfStudy: map['year_of_study']?.toString() ?? '',
      firstAcademicLevel: map['first_academic_level']?.toString() ?? '',
      firstModule: map['first_module']?.toString() ?? '',
      secondAcademicLevel: map['second_academic_level']?.toString(),
      secondModule: map['second_module']?.toString(),
      confirmedEligibility: map['confirmed_eligibility'] ?? false,
      status: map['status']?.toString() ?? 'Pending',
      documentUrl: map['document_url']?.toString(),
      createdAt: map['created_at'] != null
          ? (map['created_at'] is String
              ? DateTime.tryParse(map['created_at'] as String)
              : map['created_at'] as DateTime)
          : null,
    );
  }

  // Converts the StudentApplication instance into a map for Supabase insertion/update
Map<String, dynamic> toMap(String userId) {
    return {
      'user_id': userId,
      'student_name': studentName,
      'year_of_study': yearOfStudy,
      'first_academic_level': firstAcademicLevel,
      'first_module': firstModule,
      'second_academic_level': secondAcademicLevel,
      'second_module': secondModule,
      'confirmed_eligibility': confirmedEligibility,
      'status': status,
      'document_url': documentUrl,
    };
  }

// Creates a copy of this application with optional new values for any field.
// This is useful for updating an application immutably, especially in
// ViewModels where you want to preserve the original state until save  
StudentApplication copyWith({
    String? id,
    String? userId,
    String? studentName,
    String? yearOfStudy,
    String? firstAcademicLevel,
    String? firstModule,
    String? secondAcademicLevel,
    String? secondModule,
    bool? confirmedEligibility,
    String? status,
    String? documentUrl,
    DateTime? createdAt,
  }) {
    return StudentApplication(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      studentName: studentName ?? this.studentName,
      yearOfStudy: yearOfStudy ?? this.yearOfStudy,
      firstAcademicLevel: firstAcademicLevel ?? this.firstAcademicLevel,
      firstModule: firstModule ?? this.firstModule,
      secondAcademicLevel: secondAcademicLevel ?? this.secondAcademicLevel,
      secondModule: secondModule ?? this.secondModule,
      confirmedEligibility:
          confirmedEligibility ?? this.confirmedEligibility,
      status: status ?? this.status,
      documentUrl: documentUrl ?? this.documentUrl,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
