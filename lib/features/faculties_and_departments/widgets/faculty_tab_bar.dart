import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../services/provider/faculty_provider.dart';

class FacultyTabBar extends StatelessWidget {
  const FacultyTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    final facultyProvider = Provider.of<FacultyProvider>(context);

    if (facultyProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return DefaultTabController(
      length: facultyProvider.faculties.length,
      child: Column(
        children: [
          TabBar(
            isScrollable: true,
            tabs: facultyProvider.faculties.map((faculty) {
              return Tab(text: faculty['facultyOf']);
            }).toList(),
          ),
          Expanded(
            child: TabBarView(
              children: facultyProvider.faculties.map((faculty) {
                return Center(
                  child: Text('Content for ${faculty['facultyOf']}'),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
