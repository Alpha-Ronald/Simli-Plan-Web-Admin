import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FacultyProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, String>> _faculties = [];
  bool _isLoading = false;

  List<Map<String, String>> get faculties => _faculties;
  bool get isLoading => _isLoading;

  FacultyProvider() {
    fetchFaculties();
  }

  Future<void> fetchFaculties() async {
    _isLoading = true;
    notifyListeners();

    try {
      QuerySnapshot snapshot = await _firestore.collection('Faculties').get();
      _faculties = snapshot.docs.map((doc) {
        return {
          'id': doc['id'] as String,
          'facultyOf': doc['facultyOf'] as String,
        };
      }).toList();
    } catch (e) {
      print('Error fetching faculties: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
