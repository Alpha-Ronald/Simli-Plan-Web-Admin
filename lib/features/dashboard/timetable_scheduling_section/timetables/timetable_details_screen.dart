import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_edit_schedule_dialogue.dart';

class TimetableDetailsPage extends StatefulWidget {
  final String timetableName;
  final String timetableId;

  const TimetableDetailsPage({super.key, required this.timetableName,   required this.timetableId,});
  @override
  State<TimetableDetailsPage> createState() => _TimetableDetailsPageState();
}


class _TimetableDetailsPageState extends State<TimetableDetailsPage> {
  // final List<String> timeSlots = [
  //   '08:00 AM',
  //   '10:00 AM',
  //   '12:00 PM',
  //   '01:00 PM',
  //   '03:00 PM',
  // ];
  final List<Map<String, dynamic>> timeSlotRanges = [
    {'label': '08:00 AM', 'start': TimeOfDay(hour: 8, minute: 0), 'end': TimeOfDay(hour: 10, minute: 0)},
    {'label': '10:00 AM', 'start': TimeOfDay(hour: 10, minute: 0), 'end': TimeOfDay(hour: 12, minute: 0)},
    {'label': '12:00 PM', 'start': TimeOfDay(hour: 12, minute: 0), 'end': TimeOfDay(hour: 13, minute: 0)},
    {'label': '01:00 PM', 'start': TimeOfDay(hour: 13, minute: 0), 'end': TimeOfDay(hour: 15, minute: 0)},
    {'label': '03:00 PM', 'start': TimeOfDay(hour: 15, minute: 0), 'end': TimeOfDay(hour: 17, minute: 0)},
  ];

  TimeOfDay? parseTimeOfDay(String timeStr) {
    final format = RegExp(r'(\d+):(\d+)\s*(AM|PM)');
    final match = format.firstMatch(timeStr);
    if (match != null) {
      int hour = int.parse(match.group(1)!);
      final int minute = int.parse(match.group(2)!);
      final period = match.group(3)!;

      if (period == 'PM' && hour != 12) hour += 12;
      if (period == 'AM' && hour == 12) hour = 0;

      return TimeOfDay(hour: hour, minute: minute);
    }
    return null;
  }
  final List<String> days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
  final fullDayMap = {
    'Mon': 'Monday',
    'Tue': 'Tuesday',
    'Wed': 'Wednesday',
    'Thu': 'Thursday',
    'Fri': 'Friday',
  };

  List<Map<String, dynamic>> schedules = [];

  @override
  void initState() {
    super.initState();
    fetchScheduledCourses();
  }

  Future<void> fetchScheduledCourses() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Timetables')
          .doc(widget.timetableId)
          .collection('ScheduledCourses')
          .get();

      final fetchedSchedules = snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'course': data['courseCode'] ?? '',
          'venue': data['venue'] ?? '',
          'day': data['day'] ?? '',
          'start': data['startTime'] ?? '',
          'end': data['endTime'] ?? '',
          'startSlot': data['startTime'] ?? '',
        };
      }).toList();
print(fetchedSchedules);
      setState(() {
        schedules = fetchedSchedules;
      });
    } catch (e) {
      print('Error fetching schedules: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.timetableName)),
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
                  ...timeSlotRanges.map((slot) => _buildHeaderCell(slot['label'] as String)).toList(),
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

    while (timeIndex < timeSlotRanges.length) {
      final currentSlotLabel = timeSlotRanges[timeIndex]['label'] as String;


      final slotSchedules = schedules.where((sch) {
        final fullDayMap = {
          'Mon': 'Monday',
          'Tue': 'Tuesday',
          'Wed': 'Wednesday',
          'Thu': 'Thursday',
          'Fri': 'Friday',
        };
        final schTime = parseTimeOfDay(sch['start'])??  parseTimeOfDay(sch['']);
        final slotStart = timeSlotRanges[timeIndex]['start'] as TimeOfDay;
        final slotEnd = timeSlotRanges[timeIndex]['end'] as TimeOfDay;

        bool isInSlot = sch['day'] == fullDayMap[day] &&
            schTime != null &&
            (schTime.hour > slotStart.hour || (schTime.hour == slotStart.hour && schTime.minute >= slotStart.minute)) &&
            (schTime.hour < slotEnd.hour || (schTime.hour == slotEnd.hour && schTime.minute < slotEnd.minute));

        return isInSlot;

      }).toList();
      cells.add(
        GestureDetector(
          onTap: () async {
            final result = await showDialog(
              context: context,
              builder: (_) => AddEditScheduleDialog(
               // day: day,
                availableSlots: timeSlotRanges.map((slot) => slot['label'] as String).toList(),
                initialDay: fullDayMap[day]!,
                timetableId: widget.timetableId,
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

