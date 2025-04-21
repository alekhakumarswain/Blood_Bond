import 'package:flutter/material.dart';
import 'package:blood_bond/models/doctor.dart';
import 'package:blood_bond/screen/Doctor/appointment_model.dart';
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
  String appointmentDate = '';
  String appointmentTime = '';
  String appointmentType = '';
  String address = '';
  String latitude = '';
  String longitude = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Book Appointment with ${widget.doctor.name}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) => patientName = value,
                validator: (value) =>
                    value!.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) => email = value,
                validator: (value) =>
                    value!.isEmpty ? 'Email is required' : null,
              ),
              // Add DatePicker, TimePicker, and Dropdown for appointment type
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final appointment = Appointment(
                      patientName: patientName,
                      doctorName: widget.doctor.name,
                      specialty: widget.doctor.specialty,
                      hospitalName: widget.doctor.hospital,
                      appointmentDate: appointmentDate,
                      appointmentTime: appointmentTime,
                      appointmentType: appointmentType,
                      bookingId: 'DOC${DateTime.now().millisecondsSinceEpoch}',
                      patientId: 'PAT${DateTime.now().millisecondsSinceEpoch}',
                      email: email,
                      address: address,
                      latitude: latitude,
                      longitude: longitude,
                    );
                    Provider.of<AppointmentProvider>(context, listen: false)
                        .addAppointment(appointment);
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
