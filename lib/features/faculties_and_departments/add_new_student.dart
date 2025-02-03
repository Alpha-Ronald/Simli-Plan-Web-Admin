import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../services/provider/students_provider.dart';

class AddStudentPage extends StatefulWidget {
  final String departmentId;
  final String departmentName;
  final List<String> programs;

  const AddStudentPage({
    super.key,
    required this.departmentId,
    required this.departmentName,
    required this.programs,
  });

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _matricNoController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  String selectedYear = '2023/2024';
  String selectedMode = 'UTME';
  String selectedProgram = '';
  String selectedLevelEnrolled = '100 Level';
  String selectedCurrentLevel = '100 Level';
  String faculty = 'FCAS';
  String department = 'Computer Science';
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _matricNoController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _emailController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  void _previewStudentData() {
    if (_formKey.currentState!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          bool isSubmitting = false;

          return StatefulBuilder(
            builder: (context, setDialogState) {
              return AlertDialog(
                title: const Text("Confirm Student Details"),
                content: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Matric No: ${_matricNoController.text}"),
                    Text("First Name: ${_firstNameController.text}"),
                    Text("Last Name: ${_lastNameController.text}"),
                    Text("Middle Name: ${_middleNameController.text}"),
                    Text("Email: ${_emailController.text}"),
                    Text("Date of Birth: ${_dobController.text}"),
                    Text("Year Enrolled: $selectedYear"),
                    Text("Mode of Entry: $selectedMode"),
                    Text("Program: $selectedProgram"),
                    Text("Level Enrolled: $selectedLevelEnrolled"),
                    Text("Current Level: $selectedCurrentLevel"),
                    Text("Faculty: $faculty"),
                    Text("Department: $department"),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: isSubmitting ? null : () => Navigator.pop(context),
                    child: const Text("Edit"),
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Column(
                      children: [
                        if (isSubmitting) const CircularProgressIndicator(),
                        TextButton(
                          onPressed: isSubmitting
                              ? null
                              : () async {
                            setDialogState(() => isSubmitting = true);

                            final studentsProvider =
                            Provider.of<StudentsListProvider>(context, listen: false);
                            bool exists = await studentsProvider
                                .checkMatricNoExists(_matricNoController.text);

                            if (exists) {
                              setDialogState(() => isSubmitting = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("Matric number already exists")),
                              );
                              return;
                            }

                            try {
                              await studentsProvider.addStudent({
                                "matricNo": _matricNoController.text,
                                "firstName": _firstNameController.text,
                                "lastName": _lastNameController.text,
                                "middleName": _middleNameController.text,
                                "email": _emailController.text,
                                "dob": _dobController.text,
                                "yearEnrolled": selectedYear,
                                "modeOfEntry": selectedMode,
                                "program": selectedProgram,
                                "levelEnrolled": selectedLevelEnrolled,
                                "currentLevel": selectedCurrentLevel,
                                "faculty": faculty,
                                "department": department,
                                "coursesEnrolled": [],
                              });

                              Navigator.pop(context); // Close dialog
                              Navigator.pop(context); // Go back to the previous screen
                            } catch (e) {
                              setDialogState(() => isSubmitting = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Error adding student: $e")),
                              );
                            }
                          },
                          child: const Text("Submit"),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
    }
  }

  void _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInputRow([
                  _buildContainerTextField("Matric No.", _matricNoController),
                  _buildContainerTextField("First Name", _firstNameController),
                ]),
                _buildInputRow([
                  _buildContainerTextField("Last Name", _lastNameController),
                  _buildContainerTextField(
                      "Middle Name", _middleNameController),
                ]),
                _buildInputRow([
                  _buildDatePicker("Date of Birth"),
                  _buildDropdown(
                      "Year Enrolled",
                      [
                        "2020/2021",
                        "2021/2022",
                        "2022/2023",
                        "2023/2024",
                        "2024/2025",
                        "2025/2026"
                      ],
                      selectedYear,
                          (value) => setState(() => selectedYear = value!)),
                ]),
                _buildInputRow([
                  _buildDropdown(
                      "Mode of Entry",
                      ["UTME", "Direct Entry", "Transfer 200", "Transfer 300"],
                      selectedMode,
                          (value) => setState(() => selectedMode = value!)),
                  _buildDropdown(
                      "Program",
                      ['', ...widget.programs],
                      selectedProgram,
                          (value) => setState(() => selectedProgram = value!)
                  ),
                ]),
                _buildInputRow([
                  _buildDropdown(
                      "Level Enrolled",
                      ["100 Level", "200 Level", "300 Level", "400 Level"],
                      selectedLevelEnrolled,
                          (value) => setState(() => selectedLevelEnrolled = value!)),
                  _buildDropdown(
                      "Current Level",
                      ["100 Level", "200 Level", "300 Level", "400 Level"],
                      selectedCurrentLevel,
                          (value) => setState(() => selectedCurrentLevel = value!)),
                ]),
                _buildContainerTextField("Email", _emailController),
                const SizedBox(height: 16),
                _buildGreyContainer("Faculty: FCAS"),
                _buildGreyContainer("Department: ${widget.departmentName}"),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _previewStudentData,
                      style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16.0)),
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

  Widget _buildInputRow(List<Widget> children) {
    return Row(
      children: children
          .expand(
              (child) => [Expanded(child: child), const SizedBox(width: 16)])
          .toList()
        ..removeLast(),
    );
  }

  Widget _buildDropdown(String label, List<String> options,
      String selectedValue, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        items: options
            .map((option) =>
                DropdownMenuItem(value: option, child: Text(option)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildContainerTextField(
      String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "$label is required" : null,
      ),
    );
  }

  Widget _buildDatePicker(String label) {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: AbsorbPointer(
        child: _buildContainerTextField(label, _dobController),
      ),
    );
  }

  Widget _buildGreyContainer(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
}


//addition of phone number to the data, expected to be collected