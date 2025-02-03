import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StudentsListProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> _students = [];

  List<Map<String, dynamic>> get students => _students;

  Future<void> fetchStudents(String departmentName) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Students')
          .where('department', isEqualTo: departmentName)
          .get();
      _students = snapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error fetching students: $e");
    }
  }

  Future<bool> checkMatricNoExists(String matricNo) async {
    try {
      DocumentSnapshot doc = await _firestore.collection('Students').doc(matricNo).get();
      return doc.exists;
    } catch (e) {
      debugPrint("Error checking matric number: $e");
      return false;
    }
  }

  Future<void> addStudent(Map<String, dynamic> studentData) async {
    try {
      bool exists = await checkMatricNoExists(studentData['matricNo']);
      if (exists) {
        throw Exception("Matric number already exists");
      }
      await _firestore.collection('Students').doc(studentData['matricNo']).set(studentData);
      _students.add(studentData);
      notifyListeners();
    } catch (e) {
      debugPrint("Error adding student: $e");
    }
  }
}
