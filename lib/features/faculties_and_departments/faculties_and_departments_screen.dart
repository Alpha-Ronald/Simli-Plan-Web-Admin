
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/provider/department_provider.dart';
import '../../services/provider/faculty_provider.dart';
import 'department_details.dart';

//  Departments list code  is below
class FacultyTabBarWithDepartments extends StatelessWidget {
  const FacultyTabBarWithDepartments({super.key});

  @override
  Widget build(BuildContext context) {
    final facultyProvider = Provider.of<FacultyProvider>(context);

    if (facultyProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: facultyProvider.faculties.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Faculties and Departments'),
          bottom: TabBar(
            isScrollable: true,
            tabs: facultyProvider.faculties.map((faculty) {
              return Tab(text: faculty['facultyOf']);
            }).toList(),
          ),
        ),
        body: TabBarView(
          children: facultyProvider.faculties.map((faculty) {
            return DepartmentsList(facultyId: faculty['id']!);
          }).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Logic to add a new department
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}



class DepartmentsList extends StatelessWidget {
  final String facultyId;

  const DepartmentsList({super.key, required this.facultyId});

  @override
  Widget build(BuildContext context) {
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);
    final departments = departmentsProvider.getDepartments(facultyId);

    return FutureBuilder(
      future: departmentsProvider.fetchDepartments(facultyId),
      builder: (context, snapshot) {
        if (departmentsProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (departments.isEmpty) {
          return const Center(child: Text('No departments found.'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: departments.length,
          itemBuilder: (context, index) {
            final department = departments[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              child: ListTile(
                title: Text('${department['department'] ?? 'Unknown Department'} Department'),
                subtitle: Text( department['id']!),
                trailing: IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DepartmentDetailsPage(
                          departmentId: department['id']!,
                          departmentName: department['department'] ?? 'Unknown Department',
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}


///Todo:Floating action button to give options on click
///Todo: Departments
///Todo: