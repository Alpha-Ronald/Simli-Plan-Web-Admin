
import 'package:admin_web_app_sp/features/dashboard/timetable_scheduling_section/timetable_schedule_overview_screen.dart';
import 'package:flutter/material.dart';
import '../../core/models/venue_model.dart';
import '../faculties_and_departments/faculties_and_departments_screen.dart';
import '../venue_section/venue_display_screen.dart';
import 'overview_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;
  int _hoveredIndex = -1;

  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard, 'title': 'Overview'},
    {'icon': Icons.school, 'title': 'Faculties And Departments'},
    {'icon': Icons.calendar_today, 'title': 'Time-Table'},
    {'icon': Icons.class_, 'title': 'Venues'},
    {'icon': Icons.people_alt_outlined, 'title': 'Students'},
    {'icon': Icons.book_outlined, 'title': 'Courses'},
    {'icon': Icons.notifications, 'title': 'Notifications'},
  ];

  final List<Widget> _pages = [
    const OverviewContent(),
    const FacultyTabBarWithDepartments(),
    TimetableScheduleOverviewPage(),
    VenueScreen(
    ),

    Center(child: Text("Students")),
    Center(child: Text("Courses")),
    Center(child: Text("Notifications")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          _buildSidebar(),
          // Main Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: _pages[_selectedIndex],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF673AB7),
              Color(0xFF0B00E4),
              Color(0xFFFF725E),
            ],
            stops: [0.25, 0.57, 1.0],
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        width: 250,
        child: Column(
          children: [
            const SizedBox(height: 50),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'University Logo',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _menuItems.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedIndex == index;
                  final isHovered = _hoveredIndex == index;

                  return MouseRegion(
                    onEnter: (_) => setState(() => _hoveredIndex = index),
                    onExit: (_) => setState(() => _hoveredIndex = -1),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedIndex = index),
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : isHovered
                              ? Colors.white.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ListTile(
                          leading: Icon(
                            _menuItems[index]['icon'],
                            color: isSelected ? Colors.black : Colors.white,
                          ),
                          title: Text(
                            _menuItems[index]['title'],
                            style: TextStyle(
                              color: isSelected ? Colors.black : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



///Todo: MAKE THE DASHBOARD SCREEN THE MAIN PAGE
///tODO: LET THE SIDE NAV BE FIXED, AND THE PSPACE ON THE LINE JUST CHANGES
///