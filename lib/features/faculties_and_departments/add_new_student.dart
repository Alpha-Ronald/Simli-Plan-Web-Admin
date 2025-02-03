import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddStudentPage extends StatefulWidget {
  const AddStudentPage({super.key});

  @override
  State<AddStudentPage> createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddStudentPage> {
  final TextEditingController _dobController = TextEditingController();
  String selectedYear = '2023/2024';
  String selectedMode = 'UTME';
  String selectedProgram = 'Computer Science';

  @override
  void dispose() {
    _dobController.dispose();
    super.dispose();
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

  void _previewStudentData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm Student Details"),
        contentPadding: const EdgeInsets.all(24.0),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Matric No: XXXXX"),
              Text("First Name: John"),
              Text("Last Name: Doe"),
              Text("Date of Birth: ${_dobController.text}"),
              Text("Year Enrolled: $selectedYear"),
              Text("Mode of Entry: $selectedMode"),
              Text("Program: $selectedProgram"),
              const Text("Faculty: FCAS"),
              const Text("Department: Computer Science"),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Edit"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Proceed with submission logic
            },
            child: const Text("Submit"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Student")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputRow([
                _buildContainerTextField("Matric No."),
                _buildContainerTextField("First Name"),
              ]),
              _buildInputRow([
                _buildContainerTextField("Last Name"),
                _buildContainerTextField("Middle Name"),
              ]),
              _buildInputRow([
                _buildDatePicker("Date of Birth"),
                _buildDropdown("Year Enrolled", ["2020/2021", "2021/2022", "2022/2023", "2023/2024", "2024/2025", "2025/2026"], selectedYear, (value) => setState(() => selectedYear = value!)),
              ]),
              _buildInputRow([
                _buildDropdown("Mode of Entry", ["UTME", "Direct Entry"], selectedMode, (value) => setState(() => selectedMode = value!)),
                _buildDropdown("Program", ["Computer Science", "Software Engineering", "Information Systems"], selectedProgram, (value) => setState(() => selectedProgram = value!)),
              ]),
              _buildContainerTextField("Email"),
              const SizedBox(height: 16),
              _buildGreyContainer("Faculty: FCAS"),
              _buildGreyContainer("Department: Computer Science"),
              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _previewStudentData,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16.0)),
                    child: const Text("Submit"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputRow(List<Widget> children) {
    return Row(
      children: children.expand((child) => [Expanded(child: child), const SizedBox(width: 16)]).toList()..removeLast(),
    );
  }

  Widget _buildContainerTextField(String label) {
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
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> options, String selectedValue, ValueChanged<String?> onChanged) {
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
        items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDatePicker(String label) {
    return _buildContainerTextField(label);
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
