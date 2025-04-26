import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../core/models/lecturer_model.dart';
import 'add_lecturer_page.dart';

class LecturerScreen extends StatelessWidget {
  final String departmentId;
  final String departmentName;
  final List<String> programs;

  const LecturerScreen({
    Key? key,
    required this.departmentId,
    required this.departmentName,
    required this.programs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lecturers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Lecturers')
              .where('department', isEqualTo: departmentName)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }

            if (!snapshot.hasData) {
              return const Center(child: Text('No data.'));
            }

            final docs = snapshot.data!.docs;

            print('🔥 Lecturers fetched: ${docs.length}');
            for (var doc in docs) {
              print('Lecturer Doc: ${doc.data()}');
            }

            if (docs.isEmpty) {
              return const Center(child: Text('No lecturers found.'));
            }

            List<LecturerModel> lecturers = docs.map((doc) {
              return LecturerModel.fromFirestore(doc);
            }).toList();


            return GridView.builder(
              itemCount: lecturers.length + 1,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 4 / 2,
              ),
              itemBuilder: (context, index) {
                if (index == lecturers.length) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddLecturerPage(),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: const Center(
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
                              if (lecturer.coursesAssignedList.isNotEmpty)
                                ...lecturer.coursesAssignedList.map((course) => Text('- $course')).toList()
                              else if (lecturer.coursesAssignedMap.isNotEmpty)
                                ...lecturer.coursesAssignedMap.entries.map((entry) {
                                  final course = entry.key;
                                  final linkedCourses = List<String>.from(entry.value ?? []);
                                  return Text('- $course (linked to: ${linkedCourses.join(", ")})');
                                }).toList()
                              else
                                const Text('No courses assigned.'),
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
                          Text('${lecturer.title} ${lecturer.firstName} ${lecturer.lastName}',
                              style: const TextStyle(fontWeight: FontWeight.bold)),
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
            );
          },
        ),
      ),
    );
  }
}
