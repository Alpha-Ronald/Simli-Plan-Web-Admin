import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../services/provider/students_provider.dart';
import 'add_new_student.dart';

class StudentsPage extends StatefulWidget {
  final String departmentId;
  final String departmentName;
  final List<String> programs;

  const StudentsPage({
    super.key,
    required this.departmentId,
    required this.departmentName,
    required this.programs,
  });

  @override
  State<StudentsPage> createState() => _StudentsPageState();
}

class _StudentsPageState extends State<StudentsPage> {


  // List<Map<String, String>> students = [
  //   {'name': 'John Doe', 'level': '100', 'email': 'john@example.com', 'phone': '+123456789', 'year_of_entry': '2022', 'mode_of_entry': 'UTME', 'program': 'Computer Science'},
  //   {'name': 'Jane Smith', 'level': '400', 'email': 'jane@example.com', 'phone': '+987654321', 'year_of_entry': '2022', 'mode_of_entry': 'Direct Entry', 'program': 'Software Engineering'},
  //   {'name': 'Alice Brown', 'level': '200', 'email': 'alice@example.com', 'phone': '+1122334455', 'year_of_entry': '2021', 'mode_of_entry': 'UTME', 'program': 'Information Systems'},
  //   {'name': 'Bob White', 'level': '300', 'email': 'bob@example.com', 'phone': '+5566778899', 'year_of_entry': '2020', 'mode_of_entry': 'UTME', 'program': 'Computer Science'},
  // ];

  String searchQuery = '';
  String selectedProgram = 'All';

  final ScrollController _horizontalController = ScrollController();
  ///////
  @override
  void initState() {
    super.initState();
    // Fetch students when the page loads
    Future.microtask(() {
      Provider.of<StudentsListProvider>(context, listen: false)
          .fetchStudents(widget.departmentName);
    });
  }


  void _filterStudents(String query) {
    setState(() {
      searchQuery = query.toLowerCase();
    });
  }

  void _selectProgram(String? program) {
    setState(() {
      selectedProgram = program ?? 'All';
    });
  }

  void _navigateToAddStudent() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Student"),
        content: const Text("Do you want to add a new student?"),
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
                MaterialPageRoute(builder: (context) => AddStudentPage( departmentId: widget.departmentId,
                  departmentName: widget.departmentName,
                  programs: widget.programs,)),
              );
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final studentsProvider = Provider.of<StudentsListProvider>(context);
    final students = studentsProvider.students;

    debugPrint("Number of students in provider: ${studentsProvider.students.length}");

    // List<Map<String, String>> filteredStudents = students.where((student) {
    //   bool matchesSearch = student['name']!.toLowerCase().contains(searchQuery);
    //   bool matchesProgram = selectedProgram == 'All' || student['program'] == selectedProgram;
    //   return matchesSearch && matchesProgram;
    // }).toList();

    List<Map<String, dynamic>> filteredStudents = students.where((student) {
      bool matchesSearch = student['lastName']
          ?.toLowerCase()
          .contains(searchQuery) ==
          true;
      bool matchesProgram =
          selectedProgram == 'All' || student['program'] == selectedProgram;
      return matchesSearch && matchesProgram;
    }).toList();

    debugPrint("Filtered students count: ${filteredStudents.length}");
    ///////

    filteredStudents.sort((a, b) =>
        (a['level']?.toString() ?? '').compareTo(b['level']?.toString() ?? ''));

    Map<String, List<Map<String, dynamic>>> groupedByLevel = {};
    for (var student in filteredStudents) {
      String level = student['currentLevel']?.toString() ?? 'N/A';
      groupedByLevel.putIfAbsent(level, () => []).add(student);
    }



    // filteredStudents.sort((a, b) => a['level']!.compareTo(b['level']!));
    //
    // Map<String, List<Map<String, String>>> groupedByLevel = {};
    // for (var student in filteredStudents) {
    //   groupedByLevel.putIfAbsent(student['level']!, () => []).add(student);
    // }

    int globalIndex = 1;

    return Scaffold(
      appBar: AppBar(title:  Text('Students List: ${widget.departmentName} Department')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: TextField(
                    onChanged: _filterStudents,
                    decoration: const InputDecoration(
                      hintText: 'Search by lastname...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
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
              ],
            ),
            const SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Scrollbar(
                  controller: _horizontalController,
                  child: SingleChildScrollView(
                    controller: _horizontalController,
                    scrollDirection: Axis.horizontal,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 1.8,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text('No.')),
                          DataColumn(label: Text('Level No.')),
                          DataColumn(label: Text('Matric No.')),
                          DataColumn(label: Text('Lastname')),
                          DataColumn(label: Text('Other Names')),
                          DataColumn(label: Text('Program')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Phone')),
                          DataColumn(label: Text('Current Level')),
                          DataColumn(label: Text('Courses Enrolled')),
                          DataColumn(label: Text('Mode of Entry')),
                          DataColumn(label: Text('Enrolled Level & Year')),
                          DataColumn(label: Text('DOB')),
                          DataColumn(label: Text('Options')),
                        ],
                        rows: groupedByLevel.entries.expand((entry) {
                          List<DataRow> rows = [];

                          rows.add(DataRow(
                              color: WidgetStateProperty.all(Colors.blueGrey.shade100), cells: [
                            DataCell(Text(entry.key, //level
                                style: const TextStyle(fontWeight: FontWeight.bold))),
                            ...List.generate(13, (index) => const DataCell(Text(''))), // Ensure 14 cells in total
                          ]));

                          int levelIndex = 1;

                          rows.addAll(entry.value.asMap().entries.map((entry) {
                            final student = entry.value;
                            final rowIndex = entry.key;
                            final rowColor = rowIndex.isEven ? Colors.white : Colors.purple.shade50;
                            return DataRow(
                                color: WidgetStateProperty.all(rowColor),
                                cells: [
                              DataCell(Text((globalIndex++).toString())),
                              DataCell(Text((levelIndex++).toString())),
                              DataCell(Text(student['matricNo'] ?? 'N/A')),
                              DataCell(Text(student['lastName'] ?? 'N/A')),
                              DataCell(
                                  Text('${student['firstName'] ?? 'N/A'} ${student['middleName'] ?? ''}')
                              ),
                              DataCell(Text(student['program'] ?? 'N/A')),
                              DataCell(Text(student['email'] ?? 'N/A')),
                              DataCell(Text(student['phone'] ?? 'N/A')),
                              DataCell(Text(student['currentLevel'] ?? 'N/A')),
                              DataCell(GestureDetector(
                                onTap: () {
                                  List<dynamic> courses =
                                  (student['coursesEnrolled'] as List<dynamic>? ?? []);
                                  _showCoursesDialog(context, courses);
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(
                                    '${(student['coursesEnrolled'] as List<dynamic>?)?.length ?? 0}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ),
                              )),
                              DataCell(Text(student['modeOfEntry'] ?? 'N/A')),
                              DataCell(Text(
                                  '${student['levelEnrolled']} (${student['yearEnrolled']})')),
                              DataCell(Text(student['dob'] ?? 'N/A')),
                              DataCell(PopupMenuButton<String>(
                                itemBuilder: (context) => [
                                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                                  const PopupMenuItem(value: 'copy', child: Text('Copy')),
                                  const PopupMenuItem(value: 'email', child: Text('Email')),
                                ],
                              )),
                            ]);
                          }));
                          return rows;
                        }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // SizedBox(height: 25,)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddStudent,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCoursesDialog(BuildContext context, List<dynamic> courses) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Courses Enrolled"),
        content: SizedBox(
          height: 200,
          width: 300,
          child: ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(courses[index]),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}
