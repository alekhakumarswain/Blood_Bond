import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:blood_bond/screen/Home.dart';
import 'package:blood_bond/widgets/Navbar.dart';
import 'package:firebase_database/firebase_database.dart' show FirebaseDatabase;

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
  bool _isLoading = false;
  String _userPhone = '+918018226416'; // Default mobile number
  late FirebaseDatabase _database;
  List<Map<dynamic, dynamic>> _bookingHistory = [];

  @override
  void initState() {
    super.initState();
    _database = FirebaseDatabase.instance;
    _fetchBookingHistory();
  }

  String getSafePath(String? phone) {
    if (phone == null) return '';
    return phone.replaceAll(RegExp(r'[.#$/[\]]'), '_');
  }

  Future<void> _fetchBookingHistory() async {
    try {
      final safePhone = getSafePath(_userPhone);
      final snapshot = await _database
          .ref()
          .child('users/$safePhone/bloodTestHistory')
          .get();
      if (snapshot.exists) {
        final history = snapshot.value as Map<dynamic, dynamic>;
        final List<Map<dynamic, dynamic>> historyList = [];
        history.forEach((key, value) {
          final booking = Map<dynamic, dynamic>.from(value);
          booking['bookingId'] = key;
          historyList.add(booking);
        });
        // Sort by timestamp (newest first)
        historyList.sort((a, b) => b['timestamp'].compareTo(a['timestamp']));
        setState(() {
          _bookingHistory = historyList;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to fetch booking history')),
      );
    }
  }

  Future<void> _submitBloodTestBooking() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _selectedTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select both date and time')),
        );
        return;
      }

      final appointmentDateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      if (appointmentDateTime.isBefore(DateTime.now())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please select a future date and time')),
        );
        return;
      }

      setState(() => _isLoading = true);
      try {
        final safePhone = getSafePath(_userPhone);
        final bookingData = {
          'name': _name,
          'age': _age,
          'bloodGroup': _bloodGroup,
          'testType': _testType,
          'agencyName': _agencyName,
          'location': _location,
          'appointmentDateTime': appointmentDateTime.toIso8601String(),
          'timestamp': DateTime.now().toIso8601String(),
          'userPhone': _userPhone,
        };

        final summaryData = {
          'name': _name,
          'bloodGroup': _bloodGroup,
          'testType': _testType,
          'agencyName': _agencyName,
          'location': _location,
          'lastBookingDate': DateTime.now().toIso8601String(),
        };

        // Store in bloodTestBookings
        await _database
            .ref()
            .child('bloodTestBookings/bookings')
            .push()
            .set(bookingData);
        await _database
            .ref()
            .child('bloodTestBookings/summary')
            .set(summaryData);

        // Store in user's history
        await _database
            .ref()
            .child('users/$safePhone/bloodTestHistory')
            .push()
            .set(bookingData);

        // Refresh booking history
        await _fetchBookingHistory();

        setState(() => _isLoading = false);
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Appointment Booked!'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: 60),
                SizedBox(height: 20),
                Text(
                  'Your blood test has been scheduled successfully\n'
                  'Name: $_name\n'
                  'Age: $_age\n'
                  'Blood Group: $_bloodGroup\n'
                  'Test Type: $_testType\n'
                  'Hospital: $_agencyName\n'
                  'Location: $_location',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Text('OK'),
              ),
            ],
          ),
        );
      } catch (e) {
        setState(() => _isLoading = false);
        String errorMessage = 'Failed to book appointment';
        if (e.toString().contains('PERMISSION_DENIED')) {
          errorMessage = 'Permission denied. Check database rules.';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Test Booking'),
        backgroundColor: Color(0xFFBE179A),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NavScreen()));
          },
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.only(top: 20, left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Book Your Blood Test",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 20),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildPersonalInfoCard(),
                        SizedBox(height: 20),
                        _buildTestInfoCard(),
                        SizedBox(height: 20),
                        _buildAppointmentCard(),
                        SizedBox(height: 30),
                        _buildSubmitCard(context),
                        SizedBox(height: 20),
                        _buildBookingHistorySection(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildBookingHistorySection() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFFBE179A),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.history, color: Colors.white, size: 30),
              ),
              SizedBox(width: 10),
              Text(
                'Booking History',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          _bookingHistory.isEmpty
              ? Text('No bookings found.')
              : ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _bookingHistory.length,
                  itemBuilder: (context, index) {
                    final booking = _bookingHistory[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(booking['name'] ?? 'Unknown'),
                        subtitle: Text(
                          'Test Type: ${booking['testType'] ?? 'N/A'}\n'
                          'Blood Group: ${booking['bloodGroup'] ?? 'N/A'}\n'
                          'Hospital: ${booking['agencyName'] ?? 'N/A'}\n'
                          'Location: ${booking['location'] ?? 'N/A'}\n'
                          'Date: ${booking['appointmentDateTime'] != null ? DateFormat('dd MMM yyyy HH:mm').format(DateTime.parse(booking['appointmentDateTime'])) : 'N/A'}',
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFFBE179A),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.person, color: Colors.white, size: 30),
              ),
              SizedBox(width: 10),
              Text(
                'Personal Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Full Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            style: TextStyle(color: Colors.black),
            validator: (value) =>
                value!.isEmpty ? 'Please enter your name' : null,
            onChanged: (value) => _name = value,
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.calendar_today),
            ),
            style: TextStyle(color: Colors.black),
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value!.isEmpty) return 'Please enter your age';
              if (int.tryParse(value) == null) return 'Enter valid age';
              if (int.parse(value) <= 0) return 'Age must be positive';
              return null;
            },
            onChanged: (value) => _age = value,
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _bloodGroup,
            decoration: InputDecoration(
              labelText: 'Blood Group',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.bloodtype),
            ),
            dropdownColor:
                Colors.grey[200], // Background color of dropdown menu
            style: TextStyle(color: Colors.black), // Selected item text color
            items: ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-']
                .map((group) => DropdownMenuItem(
                      value: group,
                      child: Text(
                        group,
                        style: TextStyle(
                            color: Colors.black), // Dropdown item text color
                      ),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _bloodGroup = value!),
          ),
        ],
      ),
    );
  }

  Widget _buildTestInfoCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFF085D2D),
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.medical_services, color: Colors.white, size: 30),
              ),
              SizedBox(width: 10),
              Text(
                'Test Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _testType,
            decoration: InputDecoration(
              labelText: 'Test Type',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.medical_services),
            ),
            dropdownColor:
                Colors.grey[200], // Background color of dropdown menu
            style: TextStyle(color: Colors.black), // Selected item text color
            items: [
              'CBC',
              'Blood Sugar',
              'Cholesterol',
              'Platelet Count',
              'Hemoglobin'
            ]
                .map((test) => DropdownMenuItem(
                      value: test,
                      child: Text(
                        test,
                        style: TextStyle(
                            color: Colors.black), // Dropdown item text color
                      ),
                    ))
                .toList(),
            onChanged: (value) => setState(() => _testType = value!),
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Hospital/Clinic Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.local_hospital),
            ),
            style: TextStyle(color: Colors.black),
            validator: (value) =>
                value!.isEmpty ? 'Please enter hospital name' : null,
            onChanged: (value) => _agencyName = value,
          ),
          SizedBox(height: 16),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Location',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.location_on),
            ),
            style: TextStyle(color: Colors.black),
            validator: (value) =>
                value!.isEmpty ? 'Please enter location' : null,
            onChanged: (value) => _location = value,
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Color(0xFFBE179A),
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.calendar_today, color: Colors.white, size: 30),
              ),
              SizedBox(width: 10),
              Text(
                'Appointment Details',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          ListTile(
            title: Text(_selectedDate == null
                ? 'Select Date'
                : 'Date: ${DateFormat('dd MMM yyyy').format(_selectedDate!)}'),
            trailing: Icon(Icons.calendar_today, color: Color(0xFFBE179A)),
            onTap: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(Duration(days: 365)),
              );
              if (picked != null) {
                setState(() => _selectedDate = picked);
              }
            },
          ),
          Divider(),
          ListTile(
            title: Text(_selectedTime == null
                ? 'Select Time'
                : 'Time: ${_selectedTime!.format(context)}'),
            trailing: Icon(Icons.access_time, color: Color(0xFFBE179A)),
            onTap: () async {
              final TimeOfDay? picked = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (picked != null) {
                setState(() => _selectedTime = picked);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitCard(BuildContext context) {
    return InkWell(
      onTap: _submitBloodTestBooking,
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(0xFFBE179A),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child:
                  Icon(Icons.check_circle, color: Color(0xFFBE179A), size: 30),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Book Appointment',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 5,
                  width: 2,
                ),
                Text(
                  'Submit your booking details',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
