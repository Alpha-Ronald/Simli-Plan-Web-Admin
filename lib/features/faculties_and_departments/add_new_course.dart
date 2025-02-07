import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

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
  String _selectedSemester = 'Alpha Semester';
  String? _selectedProgram;
  final _formKey = GlobalKey<FormState>();

  final List<String> units = ['1', '2', '3', '4', '5'];
  final List<String> statusOptions = ['Required', 'Compulsory', 'Elective'];
  final List<String> levels = ['100 Level', '200 Level', '300 Level', '400 Level', '500 Level'];
  final List<String> semesters = ['Alpha Semester', 'Omega Semester'];

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
                _buildInputRow([
                  _buildDropdown("Units", units, _selectedUnits, (value) => setState(() => _selectedUnits = value!)),
                  _buildDropdown("Status", statusOptions, _selectedStatus, (value) => setState(() => _selectedStatus = value!)),
                ]),
                _buildInputRow([
                  _buildDropdown("Level", levels, _selectedLevel, (value) => setState(() => _selectedLevel = value!)),
                  _buildDropdown("Semester", semesters, _selectedSemester, (value) => setState(() => _selectedSemester = value!)),
                ]),
                _buildDropdown("Program", ['', ...widget.programs], _selectedProgram, (value) => setState(() => _selectedProgram = value)),
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
      ),
    );
  }

  void _previewCourseData() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirm Course Details"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Course Code: ${_courseCodeController.text}"),
                Text("Course Title: ${_courseTitleController.text}"),
                Text("Units: $_selectedUnits"),
                Text("Status: $_selectedStatus"),
                Text("Level: $_selectedLevel"),
                Text("Semester: $_selectedSemester"),
                Text("Program: $_selectedProgram"),
                Text("Faculty: FCAS"),
                Text("Department: ${widget.departmentName}"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Edit"),
              ),
              TextButton(
                onPressed: () {
                  // Handle submission logic
                  Navigator.pop(context);
                },
                child: const Text("Confirm"),
              ),
            ],
          );
        },
      );
    }
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
