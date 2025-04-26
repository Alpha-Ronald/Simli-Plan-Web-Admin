import 'package:admin_web_app_sp/features/faculties_and_departments/students_display_screen.dart';
import 'package:admin_web_app_sp/features/faculties_and_departments/widgets/buttom_navigation_buttons.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/provider/department_provider.dart';
import 'package:admin_web_app_sp/features/faculties_and_departments/lecturers_display_screen.dart';
import 'courses_display_screen.dart';

class DepartmentDetailsPage extends StatefulWidget {
  final String departmentId;
  final String departmentName;

  const DepartmentDetailsPage({
    super.key,
    required this.departmentId,
    required this.departmentName,
  });

  @override
  _DepartmentDetailsPageState createState() => _DepartmentDetailsPageState();
}

class _DepartmentDetailsPageState extends State<DepartmentDetailsPage> {
  late Future<void> _fetchProgramsFuture;

  @override
  void initState() {
    super.initState();
    _fetchProgramsFuture = _fetchPrograms();
  }

  Future<void> _fetchPrograms() async {
    await context.read<DepartmentsProvider>().fetchPrograms(widget.departmentId);
  }

  @override
  Widget build(BuildContext context) {
    final departmentsProvider = Provider.of<DepartmentsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.departmentName} Department'),
      ),
      body: FutureBuilder(
        future: _fetchProgramsFuture,
        builder: (context, snapshot) {
          final programs = departmentsProvider.getPrograms(widget.departmentId);

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
                              builder: (context) => LecturerScreen( departmentId: widget.departmentId,
                                departmentName: widget.departmentName,
                                programs: programs, lecturers: demoLecturers),
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
                              builder: (context) => StudentsPage( departmentId: widget.departmentId,
                                departmentName: widget.departmentName,
                                programs: programs,),
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
                              builder: (context) => CoursesPage(
                                departmentId: widget.departmentId,
                                departmentName: widget.departmentName,
                                programs: programs,
                              ),
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
