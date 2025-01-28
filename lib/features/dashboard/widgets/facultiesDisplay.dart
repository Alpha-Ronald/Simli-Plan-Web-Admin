import 'package:flutter/material.dart';
import '../../../services/firebase/firestore_service1.dart';

import 'package:provider/provider.dart';

import '../../../services/provider/faculty_provider.dart';

class FacultyDisplayWidget extends StatelessWidget {
  const FacultyDisplayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final facultyProvider = Provider.of<FacultyProvider>(context);

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
          const Text(
            'FACULTIES',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: facultyProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 2.5,
              ),
              itemCount: facultyProvider.faculties.length + 1,
              itemBuilder: (context, index) {
                if (index == facultyProvider.faculties.length) {
                  return GestureDetector(
                    onTap: () {
                      // Add new faculty logic
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey.withOpacity(0.5)),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.add,
                          size: 24,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                }

                final faculty = facultyProvider.faculties[index];
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              faculty['facultyOf'] ?? 'Unknown',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Text(
                            faculty['id'] ?? 'Unknown',
                            style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
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
