import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../../services/provider/courses_provider.dart';

class AddCoursePage extends StatefulWidget {
  final String departmentId;
  final String departmentName;
  final List<String> programs;

  const AddCoursePage({
    super.key,
    required this.departmentId,
    required this.departmentName,
    required this.programs,
  });

  @override
  _AddCoursePageState createState() => _AddCoursePageState();
}

class _AddCoursePageState extends State<AddCoursePage> {
  final TextEditingController _courseCodeController = TextEditingController();
  final TextEditingController _courseTitleController = TextEditingController();
  String _selectedUnits = '1';
  String _selectedStatus = 'Required';
  String _selectedLevel = '100 Level';
  String _selectedSemester = 'Alpha';
  List<Map<String, String>> _selectedPrograms = [];
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final List<String> units = ['1', '2', '3', '4', '5'];
  final List<String> statusOptions = ['Required', 'Compulsory', 'Elective'];
  final List<String> levels = ['100 Level', '200 Level', '300 Level', '400 Level', '500 Level'];
  final List<String> semesters = ['Alpha', 'Omega'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Course')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputRow([
                  _buildContainerTextField("Course Code", _courseCodeController, inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9-]'))]),
                  _buildContainerTextField("Course Title", _courseTitleController),
                ]),
               // _buildInputRow([
                //   _buildDropdown("Units", units, _selectedUnits, (value) => setState(() => _selectedUnits = value!)),
                //   _buildDropdown("Status", statusOptions, _selectedStatus, (value) => setState(() => _selectedStatus = value!)),
                // ]),
                _buildInputRow([
                  _buildDropdown("Level", levels, _selectedLevel, (value) => setState(() => _selectedLevel = value!)),
                  _buildDropdown("Semester", semesters, _selectedSemester, (value) => setState(() => _selectedSemester = value!)),
                ]),
                _buildMultiSelectPrograms(), // Updated multi-select program selection
                const SizedBox(height: 16),
                _buildGreyContainer("Faculty: FCAS"),
                _buildGreyContainer("Department: ${widget.departmentName}"),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _previewCourseData,
                      style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16.0)),
                      child: const Text("Submit"),
                    ),
                  ),
                ),
              ],

          ),
        ),
      ),
    ));
  }

  /// Multi-select for programs using checkboxes
  Widget _buildMultiSelectPrograms() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Select Programs & Details", style: TextStyle(fontWeight: FontWeight.bold)),
          ...widget.programs.map((program) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CheckboxListTile(
                  title: Text(program),
                  value: _selectedPrograms.any((p) => p['programName'] == program),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        _selectedPrograms.add({
                          "programName": program,
                          "status": "Required",
                          "units": "1"
                        });
                      } else {
                        _selectedPrograms.removeWhere((p) => p['programName'] == program);
                      }
                    });
                  },
                ),
                if (_selectedPrograms.any((p) => p['programName'] == program))
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        _buildDropdown(
                          "Status for $program",
                          statusOptions,
                          _selectedPrograms.firstWhere((p) => p['programName'] == program)['status'],
                              (value) {
                            setState(() {
                              _selectedPrograms.firstWhere((p) => p['programName'] == program)['status'] = value!;
                            });
                          },
                        ),
                        _buildDropdown(
                          "Units for $program",
                          units,
                          _selectedPrograms.firstWhere((p) => p['programName'] == program)['units'],
                              (value) {
                            setState(() {
                              _selectedPrograms.firstWhere((p) => p['programName'] == program)['units'] = value!;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }


  void _previewCourseData() {
    if (_formKey.currentState!.validate()) {
      if (_selectedPrograms.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please select at least one program")));
        return;
      }

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                title: const Text("Confirm Course Details"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Course Code: ${_courseCodeController.text}"),
                    Text("Course Title: ${_courseTitleController.text}"),
                    Text("Level: $_selectedLevel"),
                    Text("Semester: $_selectedSemester"),
                    Text("Programs: ${_selectedPrograms.map((p) => '${p['programName']} (${p['status']}, ${p['units']} units)').join(', ')}"),
                    Text("Faculty: FCAS"),
                    Text("Department: ${widget.departmentName}"),
                  ],
                ),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context), child: const Text("Edit")),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : TextButton(
                    onPressed: () {
                      setState(() => _isLoading = true);
                      _submitCourse(() {
                        setState(() => _isLoading = false);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      });
                    },
                    child: const Text("Confirm"),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }


  void _submitCourse(VoidCallback onSuccess) {
    final String courseCode = _courseCodeController.text.isNotEmpty ? _courseCodeController.text : "N/A";

    final courseData = {
      "courseCode": courseCode,
      "courseTitle": _courseTitleController.text.isNotEmpty ? _courseTitleController.text : "N/A",
      "department": widget.departmentName,
      "faculty": "FCAS",
      "level": _selectedLevel,
      "semester": _selectedSemester,
      "programs": _selectedPrograms, // Now stores objects with programName, status, and units
      "lecturersAssigned": "N/A",
      "schedule": {},
      "students": [],
      "difficultyRating": {},
      "linkedCourses": [],
    };

    Provider.of<CoursesProvider>(context, listen: false)
        .addCourse(courseData, docId: courseCode)
        .then((_) {
      onSuccess();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Course added successfully!")),
      );
    }).catchError((error) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to add course: $error")),
      );
    });
  }


  Widget _buildInputRow(List<Widget> children) {
    return Row(
      children: children.expand((child) => [Expanded(child: child), const SizedBox(width: 16)]).toList()..removeLast(),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String? selectedValue, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
        onChanged: onChanged,
        validator: (value) => value == null || value.isEmpty ? "$label is required" : null,
      ),
    );
  }

  Widget _buildContainerTextField(String label, TextEditingController controller, {List<TextInputFormatter>? inputFormatters}) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: (value) => value == null || value.isEmpty ? "$label is required" : null,
        inputFormatters: inputFormatters,
      ),
    );
  }

  Widget _buildGreyContainer(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(8)),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}
