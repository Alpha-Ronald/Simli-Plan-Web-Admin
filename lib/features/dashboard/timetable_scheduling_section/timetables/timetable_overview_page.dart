import 'package:flutter/material.dart';

import 'create_timetable_screen.dart';

class TimetableOverviewPage extends StatelessWidget {
  const TimetableOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample dummy data
    final List<Map<String, dynamic>> timetables = [

      {
        'name': 'First Semester 2024/2025',
        'isActive': true,
        'startDate': 'Oct 2024',
        'endDate': 'Feb 2025',
      },
      {
        'name': 'Second Semester 2024/2025',
        'isActive': false,
        'startDate': 'Mar 2025',
        'endDate': 'Jul 2025',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetables'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 4 / 2,
          ),
          itemCount: timetables.length + 1, // +1 for the "Create New" card
          itemBuilder: (context, index) {
            if (index == timetables.length) {
              // Create New Timetable Card
              return _buildCreateNewCard(context);
            }

            final timetable = timetables[index];
            return _buildTimetableCard(context, timetable);
          },
        ),
      ),
    );
  }

  Widget _buildTimetableCard(BuildContext context, Map<String, dynamic> timetable) {
    return GestureDetector(
      onTap: () {
        // TODO: Navigate to view/manage this specific timetable
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              timetable['name'],
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '${timetable['startDate']} - ${timetable['endDate']}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: timetable['isActive'] ? Colors.green[100] : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                timetable['isActive'] ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: timetable['isActive'] ? Colors.green : Colors.black54,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCreateNewCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
      Navigator.push(context, MaterialPageRoute(builder: (_) => CreateTimetablePage()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.blueAccent),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.add, size: 48, color: Colors.blueAccent),
              SizedBox(height: 8),
              Text(
                'Create New Timetable',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}
