class LecturerModel {
  final String id;
  final String firstName;
  final String lastName;
  final String role;
  final String title;
  final String email;
  final String department;
  final List<String> coursesAssigned;

  LecturerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.title,
    required this.email,
    required this.department,
    required this.coursesAssigned,
  });

  // For converting from Firestore
  factory LecturerModel.fromMap(Map<String, dynamic> map, String docId) {
    return LecturerModel(
      id: docId,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      role: map['role'] ?? '',
      title: map['title'] ?? '',
      email: map['email'] ?? '',
      department: map['department'] ?? '',
      coursesAssigned: List<String>.from(map['coursesAssigned'] ?? []),
    );
  }

  // For converting to Firestore
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'role': role,
      'title': title,
      'email': email,
      'department': department,
      'coursesAssigned': coursesAssigned,
    };
  }
}
