import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class BloodTestPage extends StatefulWidget {
  @override
  _BloodTestPageState createState() => _BloodTestPageState();
}

class _BloodTestPageState extends State<BloodTestPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _age = '';
  String _bloodGroup = 'A+';
  String _testType = 'CBC';
  String _agencyName = '';
  String _location = '';
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Function to handle date picking
  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Function to handle time picking
  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Test and Appointment'),
        backgroundColor: Colors.red[600],
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context); // Navigate back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                // Blood Test Form
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _name = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Age',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _age = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your age';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Blood Group',
                    border: OutlineInputBorder(),
                  ),
                  value: _bloodGroup, // Default value
                  items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                      .map((group) => DropdownMenuItem<String>(
                            value: group,
                            child: Text(group),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _bloodGroup = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a blood group';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Test Type',
                    border: OutlineInputBorder(),
                  ),
                  value: _testType, // Default value
                  items: ['CBC', 'Blood Sugar', 'Cholesterol', 'Platelet Count']
                      .map((test) => DropdownMenuItem<String>(
                            value: test,
                            child: Text(test),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      _testType = value!;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a test type';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                // Appointment Booking Section
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Agency Name',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _agencyName = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter agency name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Location',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _location = value;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                // Date Picker
                ListTile(
                  title: Text(_selectedDate == null
                      ? 'Select Appointment Date'
                      : 'Date: ${DateFormat('dd/MM/yyyy').format(_selectedDate!)}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: () => _pickDate(context),
                ),
                // Time Picker
                ListTile(
                  title: Text(_selectedTime == null
                      ? 'Select Appointment Time'
                      : 'Time: ${_selectedTime!.format(context)}'),
                  trailing: Icon(Icons.access_time),
                  onTap: () => _pickTime(context),
                ),
                SizedBox(height: 32.0),
                ElevatedButton.icon(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Blood test and appointment booked')),
                      );
                    }
                  },
                  icon: Icon(Icons.check_circle),
                  label: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[600],
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 20.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
