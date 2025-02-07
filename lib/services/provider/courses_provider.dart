import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CoursesProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _courses = [];

  List<Map<String, dynamic>> get courses => _courses;

  Future<void> fetchCourses(String departmentName) async {
    try {
      debugPrint("Fetching courses for department: $departmentName");

      QuerySnapshot snapshot = await _firestore
          .collection('Courses')
          .where('department', isEqualTo: departmentName)
          .get();

      debugPrint("Firestore returned ${snapshot.docs.length} documents");

      _courses = snapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Store the document ID
        return data;
      }).toList();

      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching courses: $e");
    }
  }

  Future<bool> checkCourseCodeExists(String courseCode) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('Courses').doc(courseCode).get();
      return doc.exists;
    } catch (e) {
      debugPrint("Error checking course code: $e");
      return false;
    }
  }

  Future<void> addCourse(Map<String, dynamic> courseData, {required String docId}) async {
    try {
      bool exists = await checkCourseCodeExists(docId);
      if (exists) {
        throw Exception("Course code already exists");
      }

      await _firestore.collection('Courses').doc(docId).set(courseData);
      _courses.add(courseData);
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding course: $e");
      throw e;
    }
  }
}
