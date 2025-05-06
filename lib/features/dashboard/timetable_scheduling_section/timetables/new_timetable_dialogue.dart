import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class CreateTimetableDialog extends StatefulWidget {
  const CreateTimetableDialog({super.key});
  @override
  State<CreateTimetableDialog> createState() => _CreateTimetableDialogState();
}

class _CreateTimetableDialogState extends State<CreateTimetableDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create New Timetable'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Timetable Name'),
                validator: (value) => value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _startDate = picked);
                      },
                      child: Text(
                        'Start: ${_startDate != null ? DateFormat('dd MMM yyyy').format(_startDate!) : '--'}',
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: _startDate ?? DateTime.now(),
                          firstDate: DateTime(2022),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) setState(() => _endDate = picked);
                      },
                      child: Text(
                        'End: ${_endDate != null ? DateFormat('dd MMM yyyy').format(_endDate!) : '--'}',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _createTimetable,
          child: const Text('Create'),
        ),
      ],
    );
  }

  Future<void> _createTimetable() async {
    if (!_formKey.currentState!.validate() || _startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    try {
      final timetableDoc = FirebaseFirestore.instance.collection('Timetables').doc();

      await timetableDoc.set({
        'name': _nameController.text.trim(),
        'startDate': _startDate,
        'endDate': _endDate,
        'active': true,
        'createdate': FieldValue.serverTimestamp(),
      });

      // Optionally add an empty 'scheduledCourses' subcollection
      // await timetableDoc.collection('scheduledCourses').add({});

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Timetable created successfully!')),
      );

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}
