import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class AddEditScheduleDialog extends StatefulWidget {
  final List<String> availableSlots;
  final String timetableId;
  final String? initialDay; // optional, in case you want to preselect

  const AddEditScheduleDialog({
    required this.availableSlots,
    required this.timetableId,
    this.initialDay,
  });

  @override
  State<AddEditScheduleDialog> createState() => _AddEditScheduleDialogState();
}

class _AddEditScheduleDialogState extends State<AddEditScheduleDialog> {

  List<Map<String, dynamic>> allCourses = [];
  List<String> filteredCourseCodes = [];
  List<String> venues = [];

  final TextEditingController _courseSearchController = TextEditingController();

  final TextEditingController _venueController = TextEditingController();

  String? selectedCourse;
  String? selectedDay;
  TimeOfDay? startTime;
  TimeOfDay? endTime;

  // final List<String> dummyCourses = [
  //   'MTH101 - Calculus I',
  //   'PHY101 - Mechanics',
  //   'CSC101 - Intro to Programming',
  // ];

  final List<String> weekdays = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  // @override
  // void initState() {
  //   super.initState();
  //   startTime = const TimeOfDay(hour: 8, minute: 0);
  //   endTime = const TimeOfDay(hour: 10, minute: 0);
  //   selectedDay = widget.initialDay ?? weekdays.first;
  // }
  @override
  void initState() {
    super.initState();
    startTime = const TimeOfDay(hour: 8, minute: 0);
    endTime = const TimeOfDay(hour: 10, minute: 0);
    selectedDay = widget.initialDay ?? weekdays.first;

    fetchCoursesAndVenues();
  }

  Future<void> fetchCoursesAndVenues() async {
    final coursesSnapshot = await FirebaseFirestore.instance.collection('Courses').get();
    final venuesSnapshot = await FirebaseFirestore.instance.collection('Venues').get();

    final List<Map<String, dynamic>> courseList = coursesSnapshot.docs.map((doc) {
      final data = doc.data();
      final code = data['courseCode'];
      final linked = List<String>.from(data['linkedCourses'] ?? []);
      return {
        'displayCode': ([code, ...linked]..removeWhere((e) => e == null || e.isEmpty)).join('/'),
        'courseCode': code,
      };
    }).toList();

    setState(() {
      allCourses = courseList;
      filteredCourseCodes = allCourses.map((c) => c['displayCode'] as String).toList();
      venues = venuesSnapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add new Schedule'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Day'),
              value: selectedDay,
              items: weekdays
                  .map((day) => DropdownMenuItem(value: day, child: Text(day)))
                  .toList(),
              onChanged: (value) => setState(() => selectedDay = value),
            ),
            const SizedBox(height: 12),

            DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  decoration: const InputDecoration(
                    hintText: 'Search Course',
                    border: OutlineInputBorder(),
                  ),
                ),
                fit: FlexFit.loose,
                itemBuilder: (context, item, isSelected) => ListTile(
                  title: Text(item),
                ),
              ),
              dropdownDecoratorProps: const DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  labelText: 'Select Course',
                  border: OutlineInputBorder(),
                ),
              ),
              items: filteredCourseCodes,
              selectedItem: selectedCourse,
              onChanged: (value) {
                setState(() {
                  selectedCourse = value;
                });
              },
            ),


            const SizedBox(height: 12),

            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: 'Select Venue'),
              value: _venueController.text.isNotEmpty ? _venueController.text : null,
              items: venues
                  .map((venue) => DropdownMenuItem(value: venue, child: Text(venue)))
                  .toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() => _venueController.text = value);
                }
              },
            ),

            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                          context: context, initialTime: startTime!);
                      if (picked != null) setState(() => startTime = picked);
                    },
                    child: Text('Start: ${startTime?.format(context) ?? '--'}'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () async {
                      final picked = await showTimePicker(
                          context: context, initialTime: endTime!);
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
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            if (selectedCourse != null &&
                selectedDay != null &&
                startTime != null &&
                endTime != null) {
              final result = _createScheduleData(context);

              // show loading dialog and hold its context
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (dialogContext) =>
                    const Center(child: CircularProgressIndicator()),
              );

              try {
                await FirebaseFirestore.instance
                    .collection('Timetables')
                    .doc(widget.timetableId)
                    .collection('ScheduledCourses')
                    .add(result);

                Navigator.pop(context); // Close loading dialog
                Navigator.pop(
                    context); // Close schedule dialog with result
              } catch (e) {
                Navigator.pop(context); // Close loading dialog
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error saving: $e')),
                );
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Please select all fields before saving.')),
              );
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
      'day': selectedDay!,
      'courseCode': selectedCourse!,
      'venue': _venueController.text,
      'startTime': startTime!.format(context),
      'endTime': endTime!.format(context),
      // 'startSlot': calculatedSlot,
    };
  }

  String _findTimeSlotForStart(TimeOfDay start) {
    final int startMinutes = start.hour * 60 + start.minute;

    for (final slot in widget.availableSlots) {
      final parts = slot.split('-');
      if (parts.length != 2) {
        debugPrint('Invalid slot format: $slot'); // helpful for debugging
        continue;
      }

      final from = _parseTime(parts[0]);
      final to = _parseTime(parts[1]);

      if (startMinutes >= from && startMinutes < to) {
        return slot;
      }
    }

    return widget.availableSlots.isNotEmpty
        ? widget.availableSlots.first
        : 'Unknown Slot';
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
