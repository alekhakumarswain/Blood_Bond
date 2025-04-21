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
        backgroundColor: Color(0xFFD32F2F),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          color: Color.fromARGB(255, 50, 192, 218),
          elevation: 6,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Specialty',
                    style:
                        textTheme.titleMedium?.copyWith(color: Colors.white)),
                SizedBox(height: 6),
                Text(doctor.specialty,
                    style:
                        textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                SizedBox(height: 16),
                Text('Experience',
                    style:
                        textTheme.titleMedium?.copyWith(color: Colors.white)),
                SizedBox(height: 6),
                Text(doctor.experience,
                    style:
                        textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                SizedBox(height: 16),
                Text('Hospital',
                    style:
                        textTheme.titleMedium?.copyWith(color: Colors.white)),
                SizedBox(height: 6),
                Text(doctor.hospital,
                    style:
                        textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                SizedBox(height: 16),
                Text('Address',
                    style:
                        textTheme.titleMedium?.copyWith(color: Colors.white)),
                SizedBox(height: 6),
                Text(doctor.address,
                    style:
                        textTheme.bodyMedium?.copyWith(color: Colors.white70)),
                SizedBox(height: 16),
                Text('Rating',
                    style:
                        textTheme.titleMedium?.copyWith(color: Colors.white)),
                SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber),
                    SizedBox(width: 6),
                    Text(doctor.rating.toString(),
                        style: textTheme.bodyMedium
                            ?.copyWith(color: Colors.white70)),
                  ],
                ),
                SizedBox(height: 24),
                Center(
                  child: ElevatedButton.icon(
                    icon: Icon(Icons.calendar_today),
                    label: Text('Book Appointment'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 174, 226, 163),
                      foregroundColor: Color.fromARGB(255, 33, 32, 32),
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      textStyle:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DoctorBookingScreen(doctor: doctor),
                        ),
                      );
                    },
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
