import 'package:flutter/material.dart';
import 'add_edit_schedule_dialogue.dart';

class CreateTimetablePage extends StatefulWidget {
  @override
  State<CreateTimetablePage> createState() => _CreateTimetablePageState();
}

class _CreateTimetablePageState extends State<CreateTimetablePage> {
  final List<String> timeSlots = [
    '8 AM - 10 AM',
    '10 AM - 12 PM',
    '12 PM - 1 PM',
    '1 PM - 3 PM',
    '3 PM - 4 PM',
  ];

  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  List<Map<String, dynamic>> schedules = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Timetable')),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            children: [
              // Time slot headers
              Row(
                children: [
                  const SizedBox(width: 100), // Empty top-left
                  ...timeSlots.map((time) => _buildHeaderCell(time)).toList(),
                ],
              ),
              // Day rows
              ...days.map((day) => Row(
                children: [
                  _buildDayCell(day),
                  ..._buildRowCells(context, day),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCell(String time) {
    return Container(
      width: 200,
      height: 50,
      alignment: Alignment.center,
      color: Colors.grey[300],
      child: Text(time, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildDayCell(String day) {
    return Container(
      width: 100,
      height: 120,
      alignment: Alignment.center,
      color: Colors.grey[200],
      child: Text(day, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
    );
  }

  List<Widget> _buildRowCells(BuildContext context, String day) {
    List<Widget> cells = [];
    int timeIndex = 0;

    while (timeIndex < timeSlots.length) {
      final currentSlot = timeSlots[timeIndex];
      final slotSchedules = schedules.where((sch) => sch['day'] == day && sch['startSlot'] == currentSlot).toList();

      cells.add(
        GestureDetector(
          onTap: () async {
            final result = await showDialog(
              context: context,
              builder: (_) => AddEditScheduleDialog(
                day: day,
                availableSlots: timeSlots,
              ),
            );
            if (result != null) {
              setState(() {
                schedules.add(result);
              });
            }
          },
          child: Container(
            width: 200,
            height: 120,
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black12),
              color: slotSchedules.isNotEmpty ? Colors.blue[50] : null,
            ),
            child: slotSchedules.isEmpty
                ? const Center(child: Text('Add'))
                : ListView.builder(
              padding: const EdgeInsets.all(4),
              itemCount: slotSchedules.length,
              itemBuilder: (context, index) {
                final schedule = slotSchedules[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 2),
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.blue[100],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(schedule['course'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      Text(schedule['venue'], style: const TextStyle(fontSize: 10)),
                      Text('${schedule['start']} - ${schedule['end']}', style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      );

      timeIndex++;
    }

    return cells;
  }
}

