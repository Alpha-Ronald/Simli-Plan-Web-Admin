import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'timetable_details_screen.dart';
import 'new_timetable_dialogue.dart';

class TimetableOverviewPage extends StatefulWidget {
  const TimetableOverviewPage({super.key});

  @override
  State<TimetableOverviewPage> createState() => _TimetableOverviewPageState();
}

class _TimetableOverviewPageState extends State<TimetableOverviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Timetables'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('Timetables').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return const Center(child: Text('No timetables found.'));
            }

            final timetables = snapshot.data!.docs;


            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 4 / 2,
              ),
              itemCount: timetables.length + 1,
              itemBuilder: (context, index) {
                if (index == timetables.length) {
                  return _buildCreateNewCard(context);
                }

                final doc = timetables[index];
                final data = doc.data() as Map<String, dynamic>;

                return _buildTimetableCard(context, data, doc.id);
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildTimetableCard(BuildContext context, Map<String, dynamic> timetable, String docId) {
    final Timestamp startTimestamp = timetable['startDate'];
    final Timestamp endTimestamp = timetable['endDate'];
    final String formattedStart = DateFormat('dd MMM yyyy').format(startTimestamp.toDate());
    final String formattedEnd = DateFormat('dd MMM yyyy').format(endTimestamp.toDate());
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => TimetableDetailsPage(
               timetableId: docId ,
              timetableName: timetable['name'] ?? '',
            ),
          ),
        );
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
              timetable['name'] ?? 'No Name',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              '$formattedStart - $formattedEnd',
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
                color: timetable['active'] == true ? Colors.green[100] : Colors.grey[300],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                timetable['active'] == true ? 'Active' : 'Inactive',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: timetable['active'] == true ? Colors.green : Colors.black54,
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
      onTap: () => showDialog(
        context: context,
        builder: (_) => const CreateTimetableDialog(),
      ),
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
