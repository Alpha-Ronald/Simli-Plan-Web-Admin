import 'package:flutter/material.dart';

class AddEditScheduleDialog extends StatefulWidget {
  final String day;
  final List<String> availableSlots; // 👈 pass all available slots

  const AddEditScheduleDialog({required this.day, required this.availableSlots});

  @override
  State<AddEditScheduleDialog> createState() => _AddEditScheduleDialogState();
}

class _AddEditScheduleDialogState extends State<AddEditScheduleDialog> {
  final TextEditingController _venueController = TextEditingController();
  String? selectedCourse;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  final List<String> dummyCourses = [
    'MTH101 - Calculus I',
    'PHY101 - Mechanics',
    'CSC101 - Intro to Programming',
  ];

  @override
  void initState() {
    super.initState();
    startTime = const TimeOfDay(hour: 8, minute: 0);
    endTime = const TimeOfDay(hour: 10, minute: 0);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Schedule - ${widget.day}'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Course'),
              items: dummyCourses.map((course) => DropdownMenuItem(value: course, child: Text(course))).toList(),
              onChanged: (value) => setState(() => selectedCourse = value),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _venueController,
              decoration: const InputDecoration(labelText: 'Venue'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(context: context, initialTime: startTime!);
                      if (picked != null) setState(() => startTime = picked);
                    },
                    child: Text('Start: ${startTime?.format(context) ?? '--'}'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(context: context, initialTime: endTime!);
                      if (picked != null) setState(() => endTime = picked);
                    },
                    child: Text('End: ${endTime?.format(context) ?? '--'}'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (selectedCourse != null && startTime != null && endTime != null) {
              final result = _createScheduleData(context);
              Navigator.pop(context, result);
            }
          },
          child: const Text('Save'),
        ),
      ],
    );
  }

  Map<String, dynamic> _createScheduleData(BuildContext context) {
    String calculatedSlot = _findTimeSlotForStart(startTime!);

    return {
      'day': widget.day,
      'course': selectedCourse!,
      'venue': _venueController.text,
      'start': startTime!.format(context),
      'end': endTime!.format(context),
      'startSlot': calculatedSlot,
      'span': 1,
    };
  }

  String _findTimeSlotForStart(TimeOfDay start) {
    final int startMinutes = start.hour * 60 + start.minute;

    for (final slot in widget.availableSlots) {
      final parts = slot.split('-');
      final from = _parseTime(parts[0]);
      final to = _parseTime(parts[1]);

      if (startMinutes >= from && startMinutes < to) {
        return slot;
      }
    }

    return widget.availableSlots.first; // fallback
  }

  int _parseTime(String timeStr) {
    timeStr = timeStr.toUpperCase();
    bool isPM = timeStr.contains('PM');
    final parts = timeStr.replaceAll('AM', '').replaceAll('PM', '').split(':');
    int hour = int.parse(parts[0].trim());
    if (isPM && hour != 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;
    return hour * 60;
  }
}
