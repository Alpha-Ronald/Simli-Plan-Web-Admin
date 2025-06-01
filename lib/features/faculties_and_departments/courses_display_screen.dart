import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/provider/courses_provider.dart';
import 'add_new_course.dart';

class CoursesPage extends StatefulWidget {
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
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  String selectedProgram = 'All';
  String selectedLevel = 'All';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<CoursesProvider>(context, listen: false)
          .fetchCourses(widget.departmentName);
    });
  }

  void _selectProgram(String? program) {
    setState(() {
      selectedProgram = program ?? 'All';
    });
  }

  void _selectLevel(String? level) {
    setState(() {
      selectedLevel = level ?? 'All';
    });
  }

  void _showAddCourseDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Course"),
        content: const Text("Are you sure you want to add a new course?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddCoursePage(
                    departmentId: widget.departmentId,
                    departmentName: widget.departmentName,
                    programs: widget.programs,
                  ),
                ),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Courses: ${widget.departmentName} Department')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildFilters(),
            const SizedBox(height: 10),
            Expanded(child: _buildCoursesTable()),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCourseDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  /// Filters for Program & Level
  Widget _buildFilters() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        DropdownButton<String>(
          value: selectedProgram,
          items: ['All', ...widget.programs]
              .map((program) => DropdownMenuItem(
            value: program,
            child: Text(program),
          ))
              .toList(),
          onChanged: _selectProgram,
        ),
        const SizedBox(width: 10),
        DropdownButton<String>(
          value: selectedLevel,
          items: ['All', '100 Level', '200 Level', '300 Level', '400 Level', '500 Level']
              .map((level) => DropdownMenuItem(
            value: level,
            child: Text('$level'),
          ))
              .toList(),
          onChanged: _selectLevel,
        ),
      ],
    );
  }

  /// Display Courses Table
  Widget _buildCoursesTable() {
    return Consumer<CoursesProvider>(
      builder: (context, provider, child) {
        if (provider.courses.isEmpty) {
          return const Center(child: Text("No courses found."));
        }

        List<Map<String, dynamic>> filteredCourses = provider.courses.where((course) {
          final programs = course['programs'] as List<dynamic>? ?? [];

          bool matchesProgram = selectedProgram == 'All' ||
              programs.any((p) =>
              p is Map<String, dynamic> &&
                  p['programName']?.toString() == selectedProgram);

          bool matchesLevel = selectedLevel == 'All' ||
              course['level']?.toString() == selectedLevel;

          return matchesProgram && matchesLevel;
        }).toList();

        if (filteredCourses.isEmpty) {
          return const Center(child: Text("No courses match the selected filters."));
        }

        // Group by program for display
        Map<String, List<Map<String, dynamic>>> groupedByProgram = {};
        for (var course in filteredCourses) {
          final programs = course['programs'] as List<dynamic>? ?? [];
          for (var program in programs) {
            if (program is! Map<String, dynamic>) continue;
            String programName = program['programName'] ?? 'Unknown Program';
            groupedByProgram.putIfAbsent(programName, () => []).add(course);
          }
        }

        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              columns: const [
                DataColumn(label: Text('No.')),
                DataColumn(label: Text('Course Code')),
                DataColumn(label: Text('Title')),
                DataColumn(label: Text('Units')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Level')),
                DataColumn(label: Text('Lecturer')),
                DataColumn(label: Text('Semester')),
                DataColumn(label: Text('Schedule')),
                DataColumn(label: Text('Options')),
              ],
              rows: groupedByProgram.entries.expand((entry) {
                List<DataRow> rows = [];

                // Program heading row
                rows.add(
                  DataRow(
                    cells: [
                      DataCell(Text(
                        entry.key,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      )),
                      ...List.filled(9, const DataCell(Text(''))),
                    ],
                  ),
                );

                int index = 1;
                rows.addAll(entry.value.map((course) {
                  var programDetails = (course['programs'] as List)
                      .firstWhere(
                        (p) =>
                    p is Map<String, dynamic> &&
                        p['programName'] == entry.key,
                    orElse: () => {'status': 'Unknown', 'units': '0'},
                  );

                  return DataRow(
                    cells: [
                      DataCell(Text((index++).toString())),
                      DataCell(Text(course['courseCode'] ?? 'N/A')),
                      DataCell(Text(course['courseTitle'] ?? 'N/A')),
                      DataCell(Text(programDetails['units'].toString())),
                      DataCell(Text(programDetails['status'].toString())),
                      DataCell(Text('${course['level']}')),
                      DataCell(Text(course['lecturerAssigned'] ?? 'N/A')),
                      DataCell(Text(course['semester'] ?? 'N/A')),
                      DataCell(Text(_formatSchedule(course['schedule']))),
                      DataCell(_buildOptionsMenu(course)),
                    ],
                  );
                }));
                return rows;
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  /// Format Course Schedule
  String _formatSchedule(Map<String, dynamic>? schedule) {
    if (schedule == null || schedule.isEmpty) return 'N/A';
    return schedule.entries.map((e) => "${e.key}: ${e.value}").join("\n");
  }

  /// Options Menu
  Widget _buildOptionsMenu(Map<String, dynamic> course) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        if (value == 'edit') {
          // Edit logic
        } else if (value == 'copy') {
          // Copy logic
        } else if (value == 'delete') {
          // Delete logic
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'edit', child: Text('Edit')),
        PopupMenuItem(value: 'copy', child: Text('Copy')),
        PopupMenuItem(value: 'delete', child: Text('Delete')),
      ],
    );
  }
}






// import 'package:flutter/material.dart';
//
// import 'add_new_course.dart';
//
// class CoursesPage extends StatefulWidget {
//   final String departmentId;
//   final String departmentName;
//   final List<String> programs;
//
//   const CoursesPage({
//     super.key,
//     required this.departmentId,
//     required this.departmentName,
//     required this.programs,
//   });
//
//   @override
//   State<CoursesPage> createState() => _CoursesPageState();
// }
//
// class _CoursesPageState extends State<CoursesPage> {
//   List<Map<String, String>> courses = [
//     {'program': 'Computer Science', 'code': 'CSC101', 'title': 'Intro to CS', 'units': '3', 'status': 'Core', 'level': '100', 'lecturer': 'Dr. Smith', 'semester': 'Alpha', 'schedule': 'Mon 8am-10am\nWed 10am-12pm'},
//     {'program': 'Computer Science', 'code': 'CSC202', 'title': 'Data Structures', 'units': '3', 'status': 'Core', 'level': '200', 'lecturer': 'Dr. Brown', 'semester': 'Omega', 'schedule': 'Tue 8am-10am\nThu 2pm-4pm'},
//     {'program': 'Software Engineering', 'code': 'SWE101', 'title': 'Software Dev', 'units': '3', 'status': 'Core', 'level': '100', 'lecturer': 'Dr. White', 'semester': 'Alpha', 'schedule': 'Mon 10am-12pm\nFri 8am-10am'},
//     {'program': 'Information Systems', 'code': 'INF301', 'title': 'Database Systems', 'units': '3', 'status': 'Core', 'level': '300', 'lecturer': 'Dr. Green', 'semester': 'Omega', 'schedule': 'Wed 2pm-4pm\nFri 10am-12pm'},
//   ];
//
//   String selectedProgram = 'All';
//   String selectedLevel = 'All';
//
//   void _selectProgram(String? program) {
//     setState(() {
//       selectedProgram = program ?? 'All';
//     });
//   }
//
//   void _selectLevel(String? level) {
//     setState(() {
//       selectedLevel = level ?? 'All';
//     });
//   }
//
//   void _showAddCourseDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: const Text("Add New Course"),
//         content: const Text("Are you sure you want to add a new course?"),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text("Cancel"),
//           ),
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context);
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(builder: (context) => AddCoursePage(departmentId: widget.departmentId,
//                   departmentName: widget.departmentName,
//                   programs: widget.programs,)),
//               );
//             },
//             child: const Text("Yes"),
//           ),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     List<Map<String, String>> filteredCourses = courses.where((course) {
//       bool matchesProgram = selectedProgram == 'All' || course['program'] == selectedProgram;
//       bool matchesLevel = selectedLevel == 'All' || course['level'] == selectedLevel;
//       return matchesProgram && matchesLevel;
//     }).toList();
//
//     Map<String, List<Map<String, String>>> groupedByProgram = {};
//     for (var course in filteredCourses) {
//       groupedByProgram.putIfAbsent(course['program']!, () => []).add(course);
//     }
//
//     return Scaffold(
//       appBar: AppBar(title: Text('Courses: ${widget.departmentName} Department')),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 DropdownButton<String>(
//                   value: selectedProgram,
//                   items: ['All', ...widget.programs].map((program) => DropdownMenuItem(
//                     value: program,
//                     child: Text(program),
//                   )).toList(),
//                   onChanged: _selectProgram,
//                 ),
//                 const SizedBox(width: 10),
//                 DropdownButton<String>(
//                   value: selectedLevel,
//                   items: ['All', '100', '200', '300', '400'].map((level) => DropdownMenuItem(
//                     value: level,
//                     child: Text('$level Level'),
//                   )).toList(),
//                   onChanged: _selectLevel,
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: DataTable(
//                   columns: const [
//                     DataColumn(label: Text('No.')),
//                     DataColumn(label: Text('Course Code')),
//                     DataColumn(label: Text('Title')),
//                     DataColumn(label: Text('Units')),
//                     DataColumn(label: Text('Status')),
//                     DataColumn(label: Text('Level')),
//                     DataColumn(label: Text('Lecturer')),
//                     DataColumn(label: Text('Semester')),
//                     DataColumn(label: Text('Schedule')),
//                     DataColumn(label: Text('Options')),
//                   ],
//                   rows: groupedByProgram.entries.expand((entry) {
//                     List<DataRow> rows = [];
//                     rows.add(
//                       DataRow(cells: [
//                         DataCell(Text('${entry.key}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue))),
//                         ...List.filled(9, const DataCell(Text(''))),
//                       ]),
//                     );
//                     int index = 1;
//                     rows.addAll(entry.value.map((course) {
//                       return DataRow(cells: [
//                         DataCell(Text((index++).toString())),
//                         DataCell(Text(course['code']!)),
//                         DataCell(Text(course['title']!)),
//                         DataCell(Text(course['units']!)),
//                         DataCell(Text(course['status']!)),
//                         DataCell(Text('${course['level']} Level')),
//                         DataCell(Text(course['lecturer']!)),
//                         DataCell(Text(course['semester']!)),
//                         DataCell(Text(course['schedule']!)),
//                         DataCell(PopupMenuButton<String>(
//                           onSelected: (value) {
//                             if (value == 'edit') {
//                               // Handle edit
//                             } else if (value == 'copy') {
//                               // Handle copy
//                             }
//                           },
//                           itemBuilder: (context) => [
//                             const PopupMenuItem(value: 'edit', child: Text('Edit')),
//                             const PopupMenuItem(value: 'copy', child: Text('Copy')),
//                             const PopupMenuItem(value: 'delete', child: Text('delete')),
//                           ],
//                         )),
//                       ]);
//                     }));
//                     return rows;
//                   }).toList(),
//                 ),
//               ),
//             ),
//           ],
//         ),
//
//       ),
//             floatingActionButton: FloatingActionButton(
//     onPressed: _showAddCourseDialog,
//     child: const Icon(Icons.add),
//     ));
//   }
// }
