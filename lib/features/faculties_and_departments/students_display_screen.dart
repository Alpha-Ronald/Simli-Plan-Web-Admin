import 'package:flutter/material.dart';

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
  List<Map<String, String>> students = [
    {'name': 'John Doe', 'level': '100', 'email': 'john@example.com', 'phone': '+123456789', 'year_of_entry': '2022', 'mode_of_entry': 'UTME', 'program': 'Computer Science'},
    {'name': 'Jane Smith', 'level': '400', 'email': 'jane@example.com', 'phone': '+987654321', 'year_of_entry': '2022', 'mode_of_entry': 'Direct Entry', 'program': 'Software Engineering'},
    {'name': 'Alice Brown', 'level': '200', 'email': 'alice@example.com', 'phone': '+1122334455', 'year_of_entry': '2021', 'mode_of_entry': 'UTME', 'program': 'Information Systems'},
    {'name': 'Bob White', 'level': '300', 'email': 'bob@example.com', 'phone': '+5566778899', 'year_of_entry': '2020', 'mode_of_entry': 'UTME', 'program': 'Computer Science'},
  ];

  String searchQuery = '';
  String selectedProgram = 'All';

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
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredStudents = students.where((student) {
      bool matchesSearch = student['name']!.toLowerCase().contains(searchQuery);
      bool matchesProgram = selectedProgram == 'All' || student['program'] == selectedProgram;
      return matchesSearch && matchesProgram;
    }).toList();

    Map<String, List<Map<String, String>>> groupedByLevel = {};
    for (var student in filteredStudents) {
      groupedByLevel.putIfAbsent(student['level']!, () => []).add(student);
    }

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
                      hintText: 'Search by name...',
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
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 1.2,
                    child: DataTable(
                      columns: const [
                        DataColumn(label: Text('No.')),
                        DataColumn(label: Text('Level No.')),
                        DataColumn(label: Text('Name')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Phone')),
                        DataColumn(label: Text('Year of Entry')),
                        DataColumn(label: Text('Mode of Entry')),
                        DataColumn(label: Text('Program')),
                      ],
                      rows: groupedByLevel.entries.expand((entry) {
                        List<DataRow> rows = [];
                        rows.add(
                          DataRow(cells: [
                            DataCell(Text('${entry.key} level', style: const TextStyle(fontWeight: FontWeight.bold))),
                            ...List.filled(7, const DataCell(Text(''))),
                          ]),
                        );
                        int levelIndex = 1;
                        rows.addAll(entry.value.map((student) {
                          return DataRow(cells: [
                            DataCell(Text((globalIndex++).toString())),
                            DataCell(Text((levelIndex++).toString())),
                            DataCell(Text(student['name']!)),
                            DataCell(Text(student['email']!)),
                            DataCell(Text(student['phone']!)),
                            DataCell(Text(student['year_of_entry'] ?? 'N/A')),
                            DataCell(Text(student['mode_of_entry'] ?? 'N/A')),
                            DataCell(Text(student['program'] ?? 'N/A')),
                          ]);
                        }));
                        return rows;
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddStudent,
        child: const Icon(Icons.add),
      ),
    );
  }
}