import 'package:flutter/material.dart';
import 'package:blood_bond/screen/Doctor/appointment_model.dart';
import 'package:provider/provider.dart';
import 'package:blood_bond/providers/appointment_provider.dart';

class AppointmentSlipScreen extends StatelessWidget {
  const AppointmentSlipScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appointments = Provider.of<AppointmentProvider>(context).appointments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Appointments'),
        backgroundColor: Color(0xFFD32F2F),
      ),
      backgroundColor: Color.fromARGB(255, 249, 218, 218),
      body: appointments.isEmpty
          ? Center(
              child: Text(
                'No appointments booked yet.',
                style: TextStyle(fontSize: 18, color: Colors.white70),
              ),
            )
          : ListView.builder(
              itemCount: appointments.length,
              itemBuilder: (context, index) {
                final appointment = appointments[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: AppointmentCard(appointment: appointment),
                );
              },
            ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;

  const AppointmentCard({Key? key, required this.appointment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: const Color.fromARGB(255, 20, 19, 19));

    return Card(
      color: Color.fromARGB(255, 142, 225, 226),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Patient: ${appointment.patientName}', style: textStyle),
            SizedBox(height: 4),
            Text('Doctor: ${appointment.doctorName}', style: textStyle),
            SizedBox(height: 4),
            Text('Specialty: ${appointment.specialty}', style: textStyle),
            SizedBox(height: 4),
            Text('Hospital: ${appointment.hospitalName}', style: textStyle),
            SizedBox(height: 4),
            Text('Date: ${appointment.appointmentDate}', style: textStyle),
            SizedBox(height: 4),
            Text('Time: ${appointment.appointmentTime}', style: textStyle),
            SizedBox(height: 4),
            Text('Type: ${appointment.appointmentType}', style: textStyle),
            SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 3, 150, 30),
                foregroundColor: Color.fromARGB(255, 136, 21, 88),
              ),
              onPressed: () {
                // Implement PDF generation using a package like `pdf`
              },
              child: const Text('Download Appointment Slip'),
            ),
          ],
        ),
      ),
    );
  }
}
