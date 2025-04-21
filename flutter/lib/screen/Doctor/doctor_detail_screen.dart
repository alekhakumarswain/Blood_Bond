import 'package:flutter/material.dart';
import 'package:blood_bond/models/doctor.dart';
import 'doctor_booking_screen.dart';

class DoctorDetailScreen extends StatelessWidget {
  final Doctor doctor;

  const DoctorDetailScreen({Key? key, required this.doctor}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(doctor.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Specialty', style: textTheme.titleMedium),
            SizedBox(height: 4),
            Text(doctor.specialty, style: textTheme.bodyMedium),
            SizedBox(height: 12),
            Text('Experience', style: textTheme.titleMedium),
            SizedBox(height: 4),
            Text(doctor.experience, style: textTheme.bodyMedium),
            SizedBox(height: 12),
            Text('Hospital', style: textTheme.titleMedium),
            SizedBox(height: 4),
            Text(doctor.hospital, style: textTheme.bodyMedium),
            SizedBox(height: 12),
            Text('Address', style: textTheme.titleMedium),
            SizedBox(height: 4),
            Text(doctor.address, style: textTheme.bodyMedium),
            SizedBox(height: 12),
            Text('Rating', style: textTheme.titleMedium),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                SizedBox(width: 4),
                Text(doctor.rating.toString(), style: textTheme.bodyMedium),
              ],
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.calendar_today),
                label: Text('Book Appointment'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  textStyle: TextStyle(fontSize: 16),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DoctorBookingScreen(doctor: doctor),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
