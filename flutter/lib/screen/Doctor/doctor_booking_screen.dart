import 'package:flutter/material.dart';
import 'package:blood_bond/models/doctor.dart';
import 'package:blood_bond/models/appointment_model.dart';
import 'package:provider/provider.dart';
import 'package:blood_bond/providers/appointment_provider.dart';

class DoctorBookingScreen extends StatefulWidget {
  final Doctor doctor;

  const DoctorBookingScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  _DoctorBookingScreenState createState() => _DoctorBookingScreenState();
}

class _DoctorBookingScreenState extends State<DoctorBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  String patientName = '';
  String email = '';
  String mobileNumber = '';
  String appointmentDate = '';
  String appointmentTime = '';
  String? appointmentType;
  String address = '';
  String latitude = '';
  String longitude = '';

  final List<String> appointmentTypes = ['Virtual', 'In-person'];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        appointmentDate = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked =
        await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        appointmentTime = picked.format(context);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    appointmentType = appointmentTypes[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment with ${widget.doctor.name}'),
        backgroundColor: Color.fromARGB(255, 7, 160, 53),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 23, 23, 23)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(179, 22, 22, 22)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 19, 18, 18)),
                  ),
                ),
                style: TextStyle(color: const Color.fromARGB(255, 31, 31, 31)),
                onChanged: (value) => patientName = value,
                validator: (value) =>
                    value!.isEmpty ? 'Name is required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 30, 29, 29)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(179, 22, 22, 22)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 20, 20, 20)),
                  ),
                ),
                style: TextStyle(color: const Color.fromARGB(255, 31, 31, 31)),
                onChanged: (value) => email = value,
                validator: (value) =>
                    value!.isEmpty ? 'Email is required' : null,
              ),
              SizedBox(height: 12),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Mobile Number',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 36, 35, 35)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(179, 20, 16, 16)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color.fromARGB(255, 8, 8, 8)),
                  ),
                ),
                style: TextStyle(color: const Color.fromARGB(255, 31, 31, 31)),
                keyboardType: TextInputType.phone,
                onChanged: (value) => mobileNumber = value,
                validator: (value) =>
                    value!.isEmpty ? 'Mobile number is required' : null,
              ),
              SizedBox(height: 12, width: 1),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Appointment Type',
                  labelStyle: TextStyle(color: Color.fromARGB(255, 17, 17, 17)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(179, 20, 20, 20)),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(255, 14, 13, 13)),
                  ),
                ),
                dropdownColor: Color.fromARGB(255, 167, 162, 162),
                value: appointmentType,
                items: appointmentTypes
                    .map((type) => DropdownMenuItem<String>(
                          value: type,
                          child: Text(type,
                              style: TextStyle(
                                  color:
                                      const Color.fromARGB(255, 12, 11, 11))),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    appointmentType = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select appointment type' : null,
                style: TextStyle(color: const Color.fromARGB(255, 26, 25, 25)),
              ),
              SizedBox(height: 12),
              ListTile(
                title: Text(
                  appointmentDate.isEmpty
                      ? 'Select Appointment Date'
                      : appointmentDate,
                  style:
                      TextStyle(color: const Color.fromARGB(255, 20, 18, 18)),
                ),
                trailing: Icon(Icons.calendar_today,
                    color: const Color.fromARGB(255, 15, 11, 11)),
                onTap: () => _selectDate(context),
              ),
              ListTile(
                title: Text(
                  appointmentTime.isEmpty
                      ? 'Select Appointment Time'
                      : appointmentTime,
                  style:
                      TextStyle(color: const Color.fromARGB(255, 19, 14, 14)),
                ),
                trailing: Icon(Icons.access_time,
                    color: const Color.fromARGB(255, 15, 12, 12)),
                onTap: () => _selectTime(context),
              ),
              SizedBox(height: 24),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 74, 185, 104),
                  foregroundColor: Color(0xFFD32F2F),
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    if (appointmentDate.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please select appointment date')),
                      );
                      return;
                    }
                    if (appointmentTime.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text('Please select appointment time')),
                      );
                      return;
                    }
                    final appointment = Appointment(
                      patientName: patientName,
                      doctorName: widget.doctor.name,
                      specialty: widget.doctor.specialty,
                      hospitalName: widget.doctor.hospital,
                      appointmentDate: appointmentDate,
                      appointmentTime: appointmentTime,
                      appointmentType: appointmentType ?? '',
                      bookingId: 'DOC${DateTime.now().millisecondsSinceEpoch}',
                      patientId: 'PAT${DateTime.now().millisecondsSinceEpoch}',
                      email: email,
                      address: widget.doctor.address,
                      latitude: widget.doctor.lat.toString(),
                      longitude: widget.doctor.lng.toString(),
                      doctorId: widget.doctor.id != null
                          ? widget.doctor.id.toString()
                          : null,
                      virtualMeetingUrl:
                          'https://alekhakumarswain.github.io/OnlineAppointment-/#bhfhvy',
                    );
                    Provider.of<AppointmentProvider>(context, listen: false)
                        .addAppointment(appointment);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Appointment booked successfully!')),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Book Appointment'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
