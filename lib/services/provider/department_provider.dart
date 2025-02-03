import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';





class DepartmentsProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, List<Map<String, String>>> _departmentsByFaculty = {};
  Map<String, List<String>> _programsByDepartment = {};
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<Map<String, String>> getDepartments(String facultyId) {
    return _departmentsByFaculty[facultyId] ?? [];
  }

  List<String> getPrograms(String departmentId) {
    return _programsByDepartment[departmentId] ?? [];
  }

  Future<void> fetchDepartments(String id) async {
    if (_departmentsByFaculty.containsKey(id)) {
      return; // Avoid fetching again if already loaded
    }

    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('Departments')
          .where('faculty', isEqualTo: id)
          .get();

      final departments = snapshot.docs.map((doc) {
        return {
          'id': doc.id, // Use doc.id for document ID
          'department': doc['department'] as String,
        };
      }).toList();

      _departmentsByFaculty[id] = departments;
    } catch (e) {
      print('Error fetching departments: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchPrograms(String departmentId) async {
    if (_programsByDepartment.containsKey(departmentId)) {
      return; // Avoid fetching again if already loaded
    }

    _isLoading = true;
    notifyListeners();

    try {
      DocumentSnapshot departmentDoc =
      await _firestore.collection('Departments').doc(departmentId).get();

      final programs = List<String>.from(departmentDoc['programs'] ?? []);

      _programsByDepartment[departmentId] = programs;
    } catch (e) {
      print('Error fetching programs: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
