import 'package:flutter/material.dart';

import '../../../services/firebase/firestore_service1.dart';

class RandomFacultyDetailsWidget extends StatefulWidget {
  const RandomFacultyDetailsWidget({super.key});

  @override
  _RandomFacultyDetailsWidgetState createState() =>
      _RandomFacultyDetailsWidgetState();
}

class _RandomFacultyDetailsWidgetState
    extends State<RandomFacultyDetailsWidget> {
  String facultyId = 'FCAS'; // Default to 'FCAS' or a fallback faculty
  int programsCount = 0;
  int studentsCount = 0;
  int lecturersCount = 0;
  int coursesCount = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFacultyDetails();
  }

  Future<void> fetchFacultyDetails() async {
    try {
      // Fetch data from Firestore (replace with actual Firestore service calls)
      programsCount = await FirestoreService().getProgramsCount(facultyId);
      studentsCount = await FirestoreService().getStudentsCount(facultyId);
      lecturersCount = await FirestoreService().getLecturersCount(facultyId);
      coursesCount = await FirestoreService().getCoursesCount(facultyId);
    } catch (e) {
      print('Error fetching faculty details: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // FCAS Header
          Text(
            facultyId.isNotEmpty ? facultyId : 'Unknown Faculty', // Fallback value
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Metrics Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricItem('Programs', programsCount.toString(), Colors.purple),
              _buildMetricItem('Students', studentsCount.toString(), Colors.blue),
              _buildMetricItem('Lecturers', lecturersCount.toString(), Colors.green),
              _buildMetricItem('Courses', coursesCount.toString(), Colors.orange),
            ],
          ),
          const SizedBox(height: 20),
          // Upcoming Events Header
          const Text(
            'Upcoming Events:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Upcoming Events List (Placeholder for now)
          _buildEventItem('Faculty Meeting', '10:00 AM', Colors.deepPurple),
          _buildEventItem('Research Seminar', '12:00 PM', Colors.blue),
        ],
      ),
    );
  }

  /// Widget for each metric
  Widget _buildMetricItem(String title, String value, Color color) {
    return Expanded(

      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Widget for each event
  Widget _buildEventItem(String title, String time, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.calendar_month,
            color: color,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                time,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
