class Student {
  final int studentId;
  final String appUserId;
  final int organizationId;
  final String organizationName;
  final String fullName;
  final String email;
  final String rollNumber;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? profileImage;

  Student({
    required this.studentId,
    required this.appUserId,
    required this.organizationId,
    required this.organizationName,
    required this.fullName,
    required this.email,
    required this.rollNumber,
    required this.createdAt,
    required this.updatedAt,
    this.profileImage,
  });

  Student copyWith({
    int? studentId,
    String? appUserId,
    int? organizationId,
    String? organizationName,
    String? fullName,
    String? email,
    String? rollNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profileImage,
  }) {
    return Student(
      studentId: studentId ?? this.studentId,
      appUserId: appUserId ?? this.appUserId,
      organizationId: organizationId ?? this.organizationId,
      organizationName: organizationName ?? this.organizationName,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      rollNumber: rollNumber ?? this.rollNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profileImage: profileImage ?? this.profileImage,
    );
  }
}