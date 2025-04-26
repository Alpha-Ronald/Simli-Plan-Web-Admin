import 'package:cloud_firestore/cloud_firestore.dart';

class LecturerModel {
  final String id;
  final String firstName;
  final String lastName;
  final String role;
  final String title;
  final String email;
  final String department;
  final List<String> coursesAssignedList; // for old data (list)
  final Map<String, dynamic> coursesAssignedMap; // for new data (map)

  LecturerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.title,
    required this.email,
    required this.department,
    required this.coursesAssignedList,
    required this.coursesAssignedMap,
  });

  factory LecturerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final coursesAssignedRaw = data['coursesAssigned'];

    List<String> coursesAssignedList = [];
    Map<String, dynamic> coursesAssignedMap = {};

    if (coursesAssignedRaw is List) {
      coursesAssignedList = List<String>.from(coursesAssignedRaw);
    } else if (coursesAssignedRaw is Map) {
      coursesAssignedMap = Map<String, dynamic>.from(coursesAssignedRaw);
    }

    return LecturerModel(
      id: doc.id,
      firstName: data['firstName'] ?? '',
      lastName: data['lastName'] ?? '',
      role: data['role'] ?? '',
      title: data['title'] ?? '',
      email: data['email'] ?? '',
      department: data['department'] ?? '',
      coursesAssignedList: coursesAssignedList,
      coursesAssignedMap: coursesAssignedMap,
    );
  }
}
