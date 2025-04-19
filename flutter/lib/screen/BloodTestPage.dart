import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:blood_bond/screen/Home.dart';

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

  void _handleBack() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => HomeScreen()),
    );
  }

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
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        if (!didPop) {
          _handleBack();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Blood Test and Appointment'),
          backgroundColor: Colors.red[600],
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: _handleBack,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter your name'
                        : null,
                    onChanged: (value) => setState(() => _name = value),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Age',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.calendar_today),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter your age' : null,
                    onChanged: (value) => setState(() => _age = value),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _bloodGroup,
                    decoration: InputDecoration(
                      labelText: 'Blood Group',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.bloodtype),
                    ),
                    items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                        .map((group) => DropdownMenuItem(
                              value: group,
                              child: Text(group),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _bloodGroup = value!),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _testType,
                    decoration: InputDecoration(
                      labelText: 'Test Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.medical_services),
                    ),
                    items: [
                      'CBC',
                      'Blood Sugar',
                      'Cholesterol',
                      'Platelet Count',
                      'Hemoglobin'
                    ]
                        .map((test) => DropdownMenuItem(
                              value: test,
                              child: Text(test),
                            ))
                        .toList(),
                    onChanged: (value) => setState(() => _testType = value!),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Agency/Hospital Name',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.local_hospital),
                    ),
                    validator: (value) => value?.isEmpty ?? true
                        ? 'Please enter agency name'
                        : null,
                    onChanged: (value) => setState(() => _agencyName = value),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    decoration: InputDecoration(
                      labelText: 'Location',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.location_on),
                    ),
                    validator: (value) =>
                        value?.isEmpty ?? true ? 'Please enter location' : null,
                    onChanged: (value) => setState(() => _location = value),
                  ),
                  SizedBox(height: 16),
                  _buildDatePickerTile(),
                  SizedBox(height: 16),
                  _buildTimePickerTile(),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        _showConfirmationDialog(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[700],
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'BOOK APPOINTMENT',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerTile() {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          _selectedDate == null
              ? 'Select Appointment Date'
              : 'Date: ${DateFormat('MMMM dd, yyyy').format(_selectedDate!)}',
        ),
        trailing: Icon(Icons.calendar_today, color: Colors.red),
        onTap: () => _pickDate(context),
      ),
    );
  }

  Widget _buildTimePickerTile() {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          _selectedTime == null
              ? 'Select Appointment Time'
              : 'Time: ${_selectedTime!.format(context)}',
        ),
        trailing: Icon(Icons.access_time, color: Colors.red),
        onTap: () => _pickTime(context),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm Appointment'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Name: $_name'),
            Text('Age: $_age'),
            Text('Blood Group: $_bloodGroup'),
            Text('Test Type: $_testType'),
            if (_selectedDate != null)
              Text(
                  'Date: ${DateFormat('MMMM dd, yyyy').format(_selectedDate!)}'),
            if (_selectedTime != null)
              Text('Time: ${_selectedTime!.format(context)}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Appointment booked successfully!'),
                  duration: Duration(seconds: 3),
                ),
              );
              _handleBack();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('Confirm'),
          ),
        ],
      ),
    );
  }
}
