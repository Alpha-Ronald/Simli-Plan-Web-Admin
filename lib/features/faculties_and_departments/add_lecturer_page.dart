import 'package:flutter/material.dart';

class AddLecturerPage extends StatefulWidget {
  const AddLecturerPage({Key? key}) : super(key: key);

  @override
  State<AddLecturerPage> createState() => _AddLecturerPageState();
}

class _AddLecturerPageState extends State<AddLecturerPage> {
  final _formKey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  String title = 'Dr'; // default
  String role = '';
  String email = '';
  String department = '';
  List<String> coursesAssigned = [];

  final courseController = TextEditingController();

  @override
  void dispose() {
    courseController.dispose();
    super.dispose();
  }

  void addCourse() {
    final course = courseController.text.trim();
    if (course.isNotEmpty) {
      setState(() {
        coursesAssigned.add(course);
      });
      courseController.clear();
    }
  }

  void saveLecturer() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Save Lecturer to Database
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Lecturer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'First Name'),
                onSaved: (value) => firstName = value!.trim(),
                validator: (value) => value!.isEmpty ? 'Enter first name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Last Name'),
                onSaved: (value) => lastName = value!.trim(),
                validator: (value) => value!.isEmpty ? 'Enter last name' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Title'),
                value: title,
                items: ['Mr', 'Mrs', 'Dr', 'Prof'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (value) => setState(() => title = value!),
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => email = value!.trim(),
                validator: (value) => value!.isEmpty ? 'Enter email' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Department'),
                onSaved: (value) => department = value!.trim(),
                validator: (value) => value!.isEmpty ? 'Enter department' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Role (e.g. Lecturer, HOD)'),
                onSaved: (value) => role = value!.trim(),
                validator: (value) => value!.isEmpty ? 'Enter role' : null,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: courseController,
                      decoration: const InputDecoration(labelText: 'Course Code (e.g. CSC101)'),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: addCourse,
                  ),
                ],
              ),
              Wrap(
                spacing: 6,
                children: coursesAssigned
                    .map((course) => Chip(
                  label: Text(course),
                  onDeleted: () => setState(() => coursesAssigned.remove(course)),
                ))
                    .toList(),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: saveLecturer,
                child: const Text('Save Lecturer'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
