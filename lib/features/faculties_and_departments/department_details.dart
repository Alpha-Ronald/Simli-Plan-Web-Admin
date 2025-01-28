import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DepartmentDetailsScreen extends StatelessWidget {
  final String departmentId;
  final String departmentName;

  const DepartmentDetailsScreen({
    super.key,
    required this.departmentId,
    required this.departmentName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(departmentName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Courses',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5, // Replace with dynamic course count
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Course $index'),
                    subtitle: Text('Course ID: $index'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Lecturers',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 3, // Replace with dynamic lecturer count
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Lecturer $index'),
                    subtitle: Text('Lecturer ID: $index'),
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Students',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // Replace with dynamic student count
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Student $index'),
                    subtitle: Text('Student ID: $index'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
