import 'package:flutter/material.dart';
import '../../core/models/lecturer_model.dart';
import 'add_lecturer_page.dart';


class LecturerScreen extends StatelessWidget {
  final List<LecturerModel> lecturers;
  final String departmentId;
  final String departmentName;
  final List<String> programs;

  const LecturerScreen({Key? key, required this.lecturers, required this.departmentId,
    required this.departmentName,
    required this.programs,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecturers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: lecturers.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 4 / 2,
          ),
          itemBuilder: (context, index) {
            if (index == lecturers.length) {
              // Last card: ADD new Lecturer
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddLecturerPage()),
                  );
                },
                child: Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Center(
                    child: Icon(Icons.add, size: 40, color: Colors.blue),
                  ),
                ),
              );
            }

            final lecturer = lecturers[index];
            return GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('${lecturer.title} ${lecturer.firstName} ${lecturer.lastName}'),
                    content: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Email: ${lecturer.email}'),
                          Text('Department: ${lecturer.department}'),
                          Text('Role: ${lecturer.role}'),
                          const SizedBox(height: 10),
                          Text('Courses Assigned:', style: const TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 5),
                          ...lecturer.coursesAssigned.map((course) => Text('- $course')).toList(),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close'))
                    ],
                  ),
                );
              },
              child: Card(
                elevation: 3,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${lecturer.title} ${lecturer.firstName} ${lecturer.lastName}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(lecturer.email, style: TextStyle(color: Colors.grey[700], fontSize: 12)),
                      const Spacer(),
                      Text('Dept: ${lecturer.department}', style: const TextStyle(fontSize: 12)),
                      Text('Role: ${lecturer.role}', style: const TextStyle(fontSize: 12)),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

final List<LecturerModel> demoLecturers = [
  LecturerModel(
    id: '1',
    firstName: 'John',
    lastName: 'Doe',
    role: 'Lecturer',
    title: 'Dr',
    email: 'john.doe@example.com',
    department: 'Computer Science',
    coursesAssigned: ['CSC101', 'CSC202', 'CSC303'],
  ),
  LecturerModel(
    id: '2',
    firstName: 'Jane',
    lastName: 'Smith',
    role: 'Head of Department',
    title: 'Prof',
    email: 'jane.smith@example.com',
    department: 'Cybersecurity',
    coursesAssigned: ['CYB201', 'CYB301'],
  ),
  LecturerModel(
    id: '3',
    firstName: 'Michael',
    lastName: 'Johnson',
    role: 'Lecturer',
    title: 'Mr',
    email: 'michael.johnson@example.com',
    department: 'Software Engineering',
    coursesAssigned: ['SEN101', 'SEN203'],
  ),
  LecturerModel(
    id: '4',
    firstName: 'Emily',
    lastName: 'Brown',
    role: 'Lecturer',
    title: 'Mrs',
    email: 'emily.brown@example.com',
    department: 'Information Technology',
    coursesAssigned: ['ITC101', 'ITC204', 'ITC305'],
  ),
];