import 'package:admin_web_app_sp/features/faculties_and_departments/students_display_screen.dart';
import 'package:admin_web_app_sp/features/faculties_and_departments/widgets/buttom_navigation_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/provider/department_provider.dart';
import "package:admin_web_app_sp/features/faculties_and_departments/lecturers_display_screen.dart";


class DepartmentDetailsPage extends StatelessWidget {
  final String departmentId;
  final String departmentName;

  const DepartmentDetailsPage({
    super.key,
    required this.departmentId,
    required this.departmentName,
  });

  @override
  Widget build(BuildContext context) {
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('$departmentName Department'),
      ),
      body: FutureBuilder(
        future: departmentsProvider.fetchPrograms(departmentId),
        builder: (context, snapshot) {
          final programs = departmentsProvider.getPrograms(departmentId);

          if (departmentsProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (programs.isEmpty) {
            return const Center(child: Text('No programs found.'));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Programs',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 3,
                    ),
                    itemCount: programs.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.blue.shade100,
                        child: Center(
                          child: Text(
                            programs[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      NavigationButton(
                        label: 'Lecturers',
                        icon: Icons.person,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const LecturersPage(),
                            ),
                          );
                        },
                      ),

                      NavigationButton(
                        label: 'Students',
                        icon: Icons.school,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StudentsPage(),
                            ),
                          );
                        },
                      ),
                      NavigationButton(
                        label: 'Courses',
                        icon: Icons.book,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const StudentsPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

