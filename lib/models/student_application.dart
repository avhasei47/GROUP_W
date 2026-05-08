class StudentApplication {
  final String id;
  final String userId;
  final String studentName;
  final String yearOfStudy;
  final String firstAcademicLevel;
  final String firstModule;
  final String? secondAcademicLevel;
  final String? secondModule;
  final bool confirmedEligibility;
  final String status;
  final String? documentUrl;
  final DateTime? createdAt;

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

  factory StudentApplication.fromMap(Map<String, dynamic> map) {
    return StudentApplication(
      id: map['id'].toString(),
      userId: map['user_id'].toString(),
      studentName: map['student_name'] ?? '',
      yearOfStudy: map['year_of_study'] ?? '',
      firstAcademicLevel: map['first_academic_level'] ?? '',
      firstModule: map['first_module'] ?? '',
      secondAcademicLevel: map['second_academic_level'],
      secondModule: map['second_module'],
      confirmedEligibility: map['confirmed_eligibility'] ?? false,
      status: map['status'] ?? 'Pending',
      documentUrl: map['document_url'],
      createdAt: map['created_at'] != null
          ? DateTime.tryParse(map['created_at'])
          : null,
    );
  }

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