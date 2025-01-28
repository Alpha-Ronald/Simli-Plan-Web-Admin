import 'package:flutter/material.dart';

// Side Navigation Widget
class SideNav extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemSelected;

  SideNav({required this.selectedIndex, required this.onItemSelected});

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
    return Container(
      width: 250,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF673AB7),
            Color(0xFF0B00E4),
            Color(0xFFFF725E),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
      ),
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
                final isSelected = selectedIndex == index;
                return GestureDetector(
                  onTap: () => onItemSelected(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.white : Colors.transparent,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
