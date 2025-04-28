import 'package:admin_web_app_sp/features/dashboard/timetable_scheduling_section/timetables/timetable_overview_page.dart';
import 'package:flutter/material.dart';

class TimetableScheduleOverviewPage extends StatelessWidget {
  const TimetableScheduleOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetable and Scheduling'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {

        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.count(
          crossAxisCount: 3,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _buildCard(
              context,
              title: 'Timetables',
              description: 'Manage course timetables for programs and faculties.',
              icon: Icons.schedule,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TimetableOverviewPage(),
                  ),
                );
              },
            ),
            _buildCard(
              context,
              title: 'University Calendar',
              description: 'Manage general university events and activities.',
              icon: Icons.calendar_today,
              onTap: () {
                // TODO: Navigate to University Calendar Page
              },
            ),
            _buildCard(
              context,
              title: 'Department Schedules',
              description: 'Manage department or faculty meetings, seminars, etc.',
              icon: Icons.apartment,
              onTap: () {
                // TODO: Navigate to Department Schedules Page
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
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
            Icon(icon, size: 48, color: Colors.blueAccent),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}