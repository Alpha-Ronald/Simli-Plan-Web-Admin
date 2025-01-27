import 'package:admin_web_app_sp/features/dashboard/widgets/facultiesDisplay.dart';
import 'package:admin_web_app_sp/features/dashboard/widgets/randomFacultyDetails.dart';
import 'package:flutter/material.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // Tracks the currently selected menu item
  int _selectedIndex = 0;

  int _hoveredIndex = -1;

  // List of menu items
  final List<Map<String, dynamic>> _menuItems = [
    {'icon': Icons.dashboard, 'title': 'Overview'},
    {'icon': Icons.school, 'title': 'Faculties And Departments'},
    {'icon': Icons.calendar_today, 'title': 'Time-Table'},
    {'icon': Icons.class_, 'title': 'Lecturers'},
    {'icon': Icons.people_alt_outlined, 'title': 'Students'},
    {'icon': Icons.book_outlined, 'title': 'Courses'},
    {'icon': Icons.notifications, 'title': 'Notifications'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar Menu
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF673AB7), // #673AB7
                    Color(0xFF0B00E4), // #0B00E4
                    Color(0xFFFF725E), // #FF725E
                  ],
                  stops: [0.25, 0.57, 1.0],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              width: 250,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 50),
                  // Logo or Header
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
                  // Menu Items
                  Expanded(
                    child: ListView.builder(
                      itemCount: _menuItems.length,
                      itemBuilder: (context, index) {
                        final isSelected = _selectedIndex == index;
                        final isHovered = _hoveredIndex == index;

                        return MouseRegion(
                          onEnter: (_) {
                            setState(() => _hoveredIndex = index);
                          },
                          onExit: (_) {
                            setState(() => _hoveredIndex = -1);
                          },
                          child: GestureDetector(
                            onTap: () {
                              setState(() => _selectedIndex = index);
                              // Navigate to the appropriate section
                              // Example: Navigator.push(...);
                            },
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
                                  color: isSelected
                                      ? Colors.black
                                      : Colors.white,
                                ),
                                title: Text(
                                  _menuItems[index]['title'],
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.black
                                        : Colors.white,
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
          ),
          // Main Content Area
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Header
                  Text(
                    'Welcome, ADMIN!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  // Content Grid
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      children: [
                        // Classes for the Day
                        FacultyDisplayWidget(),
                        RandomFacultyDetailsWidget(),

                        // My Calendar
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'My Calendar',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              // Example calendar placeholder
                              Expanded(
                                child: Center(
                                  child: Text('Calendar Widget Here'),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // News & Updates
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Updates and Upcoming Events',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              Text('New semester starts on Jan 20th.'),
                              Text('Upcoming event: Science Fair.'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
