import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch faculties from Firestore
  Future<List<Map<String, String>>> getFaculties() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('Faculties').get();

      // Map the results to a List of Maps
      return snapshot.docs.map((doc) {
        return {
          'id': doc['id'] as String, // Faculty ID
          'facultyOf': doc['facultyOf'] as String, // Faculty Name
        };
      }).toList();
    } catch (e) {
      print('Error fetching faculties: $e');
      return [];
    }
  }

  /// Fetches a random faculty from the `faculties` collection.
  Future<Map<String, dynamic>?> getRandomFaculty() async {
    try {
      // Get all faculties
      final facultiesSnapshot = await _firestore.collection('Faculties').get();
      if (facultiesSnapshot.docs.isEmpty) return null;

      // Select a random faculty
      final randomIndex = Random().nextInt(facultiesSnapshot.docs.length);
      final randomFaculty = facultiesSnapshot.docs[randomIndex].data();

      return randomFaculty;
    } catch (e) {
      print('Error fetching random faculty: $e');
      return null;
    }
  }

  /// Fetches the number of programs for a faculty
  Future<int> getProgramsCount(String facultyId) async {
    try {
      final departmentsSnapshot = await _firestore
          .collection('Departments')
          .where('faculty', isEqualTo: facultyId)
          .get();

      int totalPrograms = 0;
      for (var department in departmentsSnapshot.docs) {
        final programs = department.data()['programs'] ?? [];
        totalPrograms += (programs as List).length; // Explicitly cast to List
      }
      return totalPrograms;
    } catch (e) {
      print('Error fetching programs count: $e');
      return 0;
    }
  }

  /// Fetches the number of students for a faculty
  Future<int> getStudentsCount(String facultyId) async {
    try {
      final studentsSnapshot = await _firestore
          .collection('Students')
          .where('faculty', isEqualTo: facultyId)
          .get();
      return studentsSnapshot.docs.length;
    } catch (e) {
      print('Error fetching students count: $e');
      return 0;
    }
  }

  /// Fetches the number of lecturers for a faculty
  Future<int> getLecturersCount(String facultyId) async {
    try {
      final lecturersSnapshot = await _firestore
          .collection('Lecturers')
          .where('faculty', isEqualTo: facultyId)
          .get();
      return lecturersSnapshot.docs.length;
    } catch (e) {
      print('Error fetching lecturers count: $e');
      return 0;
    }
  }

  /// Fetches the number of courses for a faculty
  Future<int> getCoursesCount(String facultyId) async {
    try {
      final coursesSnapshot = await _firestore
          .collection('Courses')
          .where('faculty', isEqualTo: facultyId)
          .get();
      return coursesSnapshot.docs.length;
    } catch (e) {
      print('Error fetching courses count: $e');
      return 0;
    }
  }

}
