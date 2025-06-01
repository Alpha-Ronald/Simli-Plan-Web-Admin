import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddLecturerPage extends StatefulWidget {
  const AddLecturerPage({Key? key}) : super(key: key);

  @override
  State<AddLecturerPage> createState() => _AddLecturerPageState();
}

class _AddLecturerPageState extends State<AddLecturerPage> {
  final _formKey = GlobalKey<FormState>();
  List<String> availableCourses = [];
  String courseSearchQuery = '';
  List<String> filteredAvailableCourses = [];

  @override
  void initState() {
    super.initState();
    fetchCourses();
  }

  void fetchCourses() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Courses')
          .where('department', isEqualTo: selectedDepartment)
          .get();

      setState(() {
        availableCourses = snapshot.docs.map((doc) => doc['courseCode'] as String).toList();
        filteredAvailableCourses = availableCourses; // Initialize filtered list
      });
    } catch (e) {
      print('Error fetching courses: $e');
    }
  }


  Map<String, List<String>> selectedCourses = {}; // key: course, value: linked courses

  bool showCourseDropdown = false;
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

  // void saveLecturer() async {
  //   if (_formKey.currentState!.validate()) {
  //     _formKey.currentState!.save();
  //
  //     // Show confirmation dialog
  //     bool confirm = await showDialog(
  //       context: context,
  //       builder: (context) => AlertDialog(
  //         title: const Text('Confirm Details'),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: [
  //               Text('ID: ${_idController.text}'),
  //               Text('First Name: ${_firstNameController.text}'),
  //               Text('Last Name: ${_lastNameController.text}'),
  //               Text('Email: ${_emailController.text}'),
  //               Text('Title: $selectedTitle'),
  //               Text('Role: $selectedRole'),
  //               Text('Faculty: $selectedFaculty'),
  //               Text('Department: $selectedDepartment'),
  //               Text('Courses Assigned: ${selectedCourses.keys.join(", ")}'),
  //             ],
  //           ),
  //         ),
  //         actions: [
  //           TextButton(
  //             onPressed: () => Navigator.pop(context, false),
  //             child: const Text('Cancel'),
  //           ),
  //           ElevatedButton(
  //             onPressed: () => Navigator.pop(context, true),
  //             child: const Text('Confirm'),
  //           ),
  //         ],
  //       ),
  //     );
  //
  //     if (confirm == true) {
  //       try {
  //         await FirebaseFirestore.instance.collection('Lecturers').doc(_idController.text).set({
  //           'id': _idController.text,
  //           'firstName': _firstNameController.text,
  //           'lastName': _lastNameController.text,
  //           'email': _emailController.text,
  //           'title': selectedTitle,
  //           'role': selectedRole,
  //           'faculty': selectedFaculty,
  //           'department': selectedDepartment,
  //           'coursesAssigned': selectedCourses.map((course, linked) => MapEntry(course, linked)),
  //           'timestamp': FieldValue.serverTimestamp(),
  //         });
  //
  //         final lecturerFullName = '${_firstNameController.text} ${_lastNameController.text}';
  //         final lecturerId = _idController.text;
  //
  //         for (var entry in selectedCourses.entries) {
  //           final courseId = entry.key;
  //           final linkedCourses = entry.value;
  //
  //           // Update the main course: linked courses + lecturerAssigned
  //           final courseRef = FirebaseFirestore.instance.collection('Courses').doc(courseId);
  //           await courseRef.update({
  //             'linkedCourses': FieldValue.arrayUnion(linkedCourses),
  //             'lecturerAssigned': lecturerId, // or lecturerFullName
  //           });
  //
  //           // Update linked courses: back-link + lecturerAssigned
  //           for (var linkedCourseId in linkedCourses) {
  //             final linkedCourseRef = FirebaseFirestore.instance.collection('Courses').doc(linkedCourseId);
  //             await linkedCourseRef.update({
  //               'linkedCourses': FieldValue.arrayUnion([courseId]),
  //               'lecturerAssigned': lecturerId, // or lecturerFullName
  //             });
  //           }
  //         }
  //
  //
  //         if (mounted) {
  //           ScaffoldMessenger.of(context).showSnackBar(
  //             const SnackBar(content: Text('Lecturer saved successfully!')),
  //           );
  //           Navigator.pop(context);
  //         }
  //       } catch (e) {
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(content: Text('Error saving lecturer: $e')),
  //         );
  //       }
  //     }
  //   }
  // }
  void saveLecturer() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Show confirmation dialog
      bool confirm = await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirm Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: [
                Text('ID: ${_idController.text}'),
                Text('First Name: ${_firstNameController.text}'),
                Text('Last Name: ${_lastNameController.text}'),
                Text('Email: ${_emailController.text}'),
                Text('Title: $selectedTitle'),
                Text('Role: $selectedRole'),
                Text('Faculty: $selectedFaculty'),
                Text('Department: $selectedDepartment'),
                Text('Courses Assigned: ${selectedCourses.keys.join(", ")}'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Confirm'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        try {
          final lecturerId = _idController.text;
          final lecturerFullName = '${_firstNameController.text} ${_lastNameController.text}';

          // Save lecturer
          await FirebaseFirestore.instance.collection('Lecturers').doc(lecturerId).set({
            'id': lecturerId,
            'firstName': _firstNameController.text,
            'lastName': _lastNameController.text,
            'email': _emailController.text,
            'title': selectedTitle,
            'role': selectedRole,
            'faculty': selectedFaculty,
            'department': selectedDepartment,
            'coursesAssigned': selectedCourses.map((course, linked) => MapEntry(course, linked)),
            'timestamp': FieldValue.serverTimestamp(),
          });

          // Delete previous lecturerAssigned if exists before assigning
          final allCourseIds = <String>{
            ...selectedCourses.keys,
            for (var list in selectedCourses.values) ...list,
          };

          for (var courseId in allCourseIds) {
            final courseRef = FirebaseFirestore.instance.collection('Courses').doc(courseId);
            await courseRef.update({
              'lecturerAssigned': FieldValue.delete(),
            });
          }

          // Assign new lecturer and update linkedCourses
          for (var entry in selectedCourses.entries) {
            final courseId = entry.key;
            final linkedCourses = entry.value;

            // Update main course
            final courseRef = FirebaseFirestore.instance.collection('Courses').doc(courseId);
            await courseRef.update({
              'linkedCourses': FieldValue.arrayUnion(linkedCourses),
              'lecturerAssigned': lecturerId,
            });

            // Update linked courses
            for (var linkedCourseId in linkedCourses) {
              final linkedCourseRef = FirebaseFirestore.instance.collection('Courses').doc(linkedCourseId);
              await linkedCourseRef.update({
                'linkedCourses': FieldValue.arrayUnion([courseId]),
                'lecturerAssigned': lecturerId,
              });
            }
          }

          if (mounted) {
            Navigator.pop(context); // Close loading dialog
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Lecturer saved successfully!')),
            );
            Navigator.pop(context); // Go back to previous screen
          }
        } catch (e) {
          Navigator.pop(context); // Close loading dialog
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error saving lecturer: $e')),
          );
        }
      }
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
                     "" ,"Dr","Mrs", "Miss", "Mr","Barr."
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
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          hintText: 'Search courses...',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {
                            courseSearchQuery = value;
                            filteredAvailableCourses = availableCourses
                                .where((course) => course.toLowerCase().contains(courseSearchQuery.toLowerCase()))
                                .toList();
                          });
                        },
                      ),
                      const SizedBox(height: 10),
                      ...filteredAvailableCourses.map((course) {
                        if (selectedCourses.containsKey(course)) return Container();
                        return ListTile(
                          title: Text(course),
                          onTap: () {
                            setState(() {
                              selectedCourses[course] = [];
                              showCourseDropdown = false;
                              courseSearchQuery = ''; // Reset search
                              filteredAvailableCourses = availableCourses;
                            });
                          },
                        );
                      }).toList(),
                    ],
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

  void _showLinkedCoursesDropdown(BuildContext context, String mainCourse) {
    String searchQuery = '';
    List<String> filteredCourses = [];

    void updateFilteredCourses() {
      filteredCourses = availableCourses
          .where((c) =>
      c != mainCourse &&
          !selectedCourses[mainCourse]!.contains(c) &&
          c.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    updateFilteredCourses();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'Search courses...',
                        prefixIcon: Icon(Icons.search),
                      ),
                      onChanged: (value) {
                        setModalState(() {
                          searchQuery = value;
                          updateFilteredCourses();
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    filteredCourses.isEmpty
                        ? const Center(child: Text('No courses found'))
                        : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCourses.length,
                      itemBuilder: (context, index) {
                        final linkedCourse = filteredCourses[index];
                        return ListTile(
                          title: Text(linkedCourse),
                          onTap: () {
                            setState(() {
                              selectedCourses[mainCourse]!.add(linkedCourse);
                            });
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

}
///pending isses: i can't scroll the second dialogue, and i need a search for the first drop down