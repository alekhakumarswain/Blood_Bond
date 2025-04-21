import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'appointment_model.dart';

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onDownload;

  const AppointmentCard(
      {Key? key, required this.appointment, required this.onDownload})
      : super(key: key);

  Future<void> _generatePdf(BuildContext context) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Container(
            padding: pw.EdgeInsets.all(20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Appointment Slip',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('Patient: ${appointment.patientName}'),
                pw.Text('Doctor: ${appointment.doctorName}'),
                pw.Text('Specialty: ${appointment.specialty}'),
                pw.Text('Hospital: ${appointment.hospitalName}'),
                pw.Text('Date: ${appointment.appointmentDate}'),
                pw.Text('Time: ${appointment.appointmentTime}'),
                pw.Text('Type: ${appointment.appointmentType}'),
                pw.SizedBox(height: 20),
                pw.Text('Booking ID: ${appointment.bookingId}'),
                pw.Text('Patient ID: ${appointment.patientId}'),
                pw.Text('Email: ${appointment.email}'),
                pw.Text('Address: ${appointment.address}'),
                pw.Text('Latitude: ${appointment.latitude}'),
                pw.Text('Longitude: ${appointment.longitude}'),
              ],
            ),
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFFD32F2F),
      ),
      onPressed: () => _generatePdf(context),
      child: const Text('Download Appointment Slip'),
    );
  }
}
