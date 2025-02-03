import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  final String departmentId;
  final String departmentName;
  final List<String> programs;

  const CoursesPage({
    super.key,
    required this.departmentId,
    required this.departmentName,
    required this.programs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
