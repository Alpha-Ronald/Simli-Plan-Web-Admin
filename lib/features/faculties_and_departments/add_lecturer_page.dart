import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AddLecturerPage extends StatefulWidget {
  const AddLecturerPage({Key? key}) : super(key: key);

  @override
  State<AddLecturerPage> createState() => _AddLecturerPageState();
}

class _AddLecturerPageState extends State<AddLecturerPage> {
  final _formKey = GlobalKey<FormState>();

  final List<String> demoCourses = [
    'CSC101', 'CSC202', 'CSC303',
    'CYB201', 'CYB301', 'SEN101', 'SEN203',
  ];

  Map<String, List<String>> selectedCourses = {}; // key: course, value: linked courses

  bool showCourseDropdown = false;
  //
  // String firstName = '';
  // String lastName = '';
  // String title = '';
  // String role = '';
  // String email = '';
  // String department = '';
  List<String> coursesAssigned = [];

  final courseController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  String selectedRole = "";
  String selectedTitle = "";
  String selectedFaculty = 'FCAS';
  String selectedDepartment = 'Computer Science';
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInputRow([
                _buildContainerTextField("ID", _idController),
              _buildContainerTextField("First Name", _firstNameController),

              ]),

        _buildInputRow([
          _buildContainerTextField("Last Name", _lastNameController),
          _buildContainerTextField("Email", _emailController),

        ]),

              _buildInputRow([
                _buildDropdown(
                    "Title",
                    [
                     "" ,"Dr","Mrs", "Miss", "Mr"
                    ],
                    selectedTitle,
                        (value) => setState(() => selectedTitle
                    = value!)),
                _buildDropdown(
                    "Role",
                    ["",
                      "admin","lecturer"," assistant lecturer"
                    ],
                    selectedRole,
                        (value) => setState(() => selectedRole
                        = value!)),
              ]),

              _buildDropdown(
                  "Department",
                  [
                    "Computer Science"
                  ],
                  selectedDepartment,
                      (value) => setState(() => selectedDepartment = value!)),

              const SizedBox(height: 20),
              Text(
                "Courses Assigned",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),

              GestureDetector(
                onTap: () {
                  setState(() {
                    showCourseDropdown = !showCourseDropdown;
                  });
                },
                child: Container(
                  width: double.infinity,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (selectedCourses.isEmpty)
                        const Text(
                          "Select assigned courses...",
                          style: TextStyle(color: Colors.grey),
                        ),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: selectedCourses.entries.map((entry) {
                          final course = entry.key;
                          final linked = entry.value;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  course +
                                      (linked.isNotEmpty ? ' (${linked.join(", ")})' : ''),
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    _showLinkedCoursesDropdown(context, course);
                                  },
                                  child: const Icon(Icons.add, size: 18),
                                ),
                                const SizedBox(width: 4),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedCourses.remove(course);
                                    });
                                  },
                                  child: const Icon(Icons.close, size: 18, color: Colors.red),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),

              if (showCourseDropdown)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  child: Column(
                    children: demoCourses.map((course) {
                      if (selectedCourses.containsKey(course)) return Container();
                      return ListTile(
                        title: Text(course),
                        onTap: () {
                          setState(() {
                            selectedCourses[course] = [];
                            showCourseDropdown = false;
                          });
                        },
                      );
                    }).toList(),
                  ),
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



              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: saveLecturer,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0)),
                    child: const Text("Save Lecturer"),
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
      width: 550,
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
      String label,
      TextEditingController controller, {
        bool isUppercase = false,
      }) {
    return Container(
      width: 550,
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
        textCapitalization: isUppercase
            ? TextCapitalization.characters
            : TextCapitalization.none,
        inputFormatters: isUppercase
            ? [FilteringTextInputFormatter.allow(RegExp(r'[A-Z\s]'))]
            : [],
      ),
    );
  }

  void _showLinkedCoursesDropdown(BuildContext context, String course) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        final availableCourses = demoCourses
            .where((c) => c != course && !selectedCourses[course]!.contains(c))
            .toList();
        return Container(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: availableCourses.map((linkedCourse) {
              return ListTile(
                title: Text(linkedCourse),
                onTap: () {
                  setState(() {
                    selectedCourses[course]!.add(linkedCourse);
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

}
