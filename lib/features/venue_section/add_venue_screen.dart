import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/models/venue_model.dart';


class AddVenuePage extends StatefulWidget {
  const AddVenuePage({super.key});

  @override
  State<AddVenuePage> createState() => _AddVenuePageState();
}

class _AddVenuePageState extends State<AddVenuePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _facultyController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _idController = TextEditingController();
  String selectedFaculty = 'FCAS';
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Venue')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildInputRow([
              _buildContainerTextField("ID", _idController),
                _buildDropdown(
                    "Faculty Enrolled",
                    [
                      "FCAS"
                    ],
                    selectedFaculty,
                        (value) => setState(() => selectedFaculty = value!)),
              ]),
              _buildInputRow([
                _buildContainerTextField("Venue Name", _nameController),
                Container(
                  width: 550,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextFormField(
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly, // This ensures only numbers are allowed
                    ],

                    controller: _capacityController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Capacity",
                      border: InputBorder.none,
                    ),
                    validator: (value) =>
                    value == null || value.isEmpty ? "Capacity is required" : null,

                  ),
                ),
              ]),


        _buildInputRow([
          _buildContainerTextField("Location Description", _locationController),  ]),



              const SizedBox(height: 24),
              Center(
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveVenue,
                    style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16.0)),
                    child: const Text("Submit"),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _saveVenue() async {
    if (_formKey.currentState!.validate()) {
      final newVenue = VenueModel(
        id: _idController.text.trim(), // Now using manually entered ID
        name: _nameController.text.trim(),
        faculty: selectedFaculty,
        capacity: int.parse(_capacityController.text.trim()),
        locationDescription: _locationController.text.trim(),
      );

      final confirm = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm Venue Details'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('ID: ${newVenue.id}'),
                Text('Name: ${newVenue.name}'),
                Text('Faculty: ${newVenue.faculty}'),
                Text('Capacity: ${newVenue.capacity} Students'),
                Text('Location: ${newVenue.locationDescription}'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Confirm'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        // Upload to Firestore
        try {
          await FirebaseFirestore.instance
              .collection('Venues')
              .doc(newVenue.id)
              .set(newVenue.toMap());

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Venue added successfully!')),
          );

          Navigator.pop(context);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to add venue: $e')),
          );
        }
      }
    }
  }

  Widget _buildInputRow(List<Widget> children) {
    return Row(
      children: children
          .expand(
              (child) => [Expanded(child: child), const SizedBox(width: 16)])
          .toList()
        ..removeLast(),
    );
  }


  Widget _buildDropdown(String label, List<String> options,
      String selectedValue, ValueChanged<String?> onChanged) {
    return Container(
      width: 550,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DropdownButtonFormField<String>(
        value: selectedValue,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        items: options
            .map((option) =>
            DropdownMenuItem(value: option, child: Text(option)))
            .toList(),
        onChanged: onChanged,
      ),
    );
  }



  Widget _buildContainerTextField(
      String label,
      TextEditingController controller, {
        bool isUppercase = false,
      }) {
    return Container(
      width: 550,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
        validator: (value) =>
        value == null || value.isEmpty ? "$label is required" : null,
        textCapitalization: isUppercase
            ? TextCapitalization.characters
            : TextCapitalization.none,
        inputFormatters: isUppercase
            ? [FilteringTextInputFormatter.allow(RegExp(r'[A-Z\s]'))]
            : [],
      ),
    );
  }
}
