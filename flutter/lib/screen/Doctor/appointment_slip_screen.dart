import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:blood_bond/models/appointment_model.dart';
import 'package:provider/provider.dart';
import 'package:blood_bond/providers/appointment_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppointmentSlipScreen extends StatelessWidget {
  const AppointmentSlipScreen({Key? key}) : super(key: key);

  Future<Uint8List> _loadLogo() async {
    final data = await rootBundle.load('assets/images/bloodbond-logo.png');
    return data.buffer.asUint8List();
  }

  Future<void> _generatePdf(
      BuildContext context, Appointment appointment) async {
    final pdf = pw.Document();

    final logoImage = pw.MemoryImage(await _loadLogo());

    final qrCodeData =
        'Booking ID: ${appointment.bookingId}\nPatient: ${appointment.patientName}\nDoctor: ${appointment.doctorName}';
    final barcodeData = appointment.bookingId;

    final currentDate = DateTime.now();
    final formattedDate =
        "${currentDate.month}/${currentDate.day}/${currentDate.year}";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                children: [
                  pw.Image(logoImage, width: 60, height: 60),
                  pw.SizedBox(width: 12),
                  pw.Text('Blood Bond',
                      style: pw.TextStyle(
                          fontSize: 28, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 16),
              pw.Text('Swasthya Setu',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Text('Patient Name: ${appointment.patientName}',
                  style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 12),
              pw.Text('Booking ID: ${appointment.bookingId}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.Text('Patient ID: ${appointment.patientId}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.Text('Email: ${appointment.email}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 12),
              pw.Text('Date of Issue: $formattedDate',
                  style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 20),
              pw.Text('Scan to view meeting link',
                  style: pw.TextStyle(
                      fontSize: 14, fontStyle: pw.FontStyle.italic)),
              pw.SizedBox(height: 20),
              pw.Text('Doctor Appointment Slip',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 12),
              pw.Text('Doctor: ${appointment.doctorName}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.Text('Specialty: ${appointment.specialty}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.Text('Hospital: ${appointment.hospitalName}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.Text('Appointment Date: ${appointment.appointmentDate}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.Text('Appointment Time: ${appointment.appointmentTime}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.Text('Appointment Type: ${appointment.appointmentType}',
                  style: pw.TextStyle(fontSize: 14)),
              pw.SizedBox(height: 12),
              pw.Text('Virtual Meeting URL:',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text(appointment.virtualMeetingUrl ?? 'N/A',
                  style: pw.TextStyle(fontSize: 14, color: PdfColors.blue)),
              pw.SizedBox(height: 12),
              pw.Text('Instructions:',
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.Text(
                'Please arrive 15 minutes early with this slip and any relevant medical records. '
                'For cancellation or rescheduling, contact the hospital at least 24 hours prior. '
                'For virtual appointment, join using the provided link at the scheduled time.',
                style: pw.TextStyle(fontSize: 12),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Booking ID: ${appointment.bookingId}',
                  style: pw.TextStyle(fontSize: 12)),
              pw.SizedBox(height: 12),
              pw.Text(
                  'Generated by Blood Bond on $formattedDate | Confidential Appointment Slip',
                  style: pw.TextStyle(
                      fontSize: 10, fontStyle: pw.FontStyle.italic)),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: qrCodeData,
                    width: 100,
                    height: 100,
                  ),
                  pw.BarcodeWidget(
                    barcode: pw.Barcode.code128(),
                    data: barcodeData,
                    width: 200,
                    height: 80,
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (format) => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    final appointments = Provider.of<AppointmentProvider>(context).appointments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Appointments'),
        backgroundColor: Color(0xFFD32F2F),
      ),
      backgroundColor: Color(0xFFD32F2F),
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
                return Dismissible(
                  key: Key(appointment.bookingId),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    Provider.of<AppointmentProvider>(context, listen: false)
                        .removeAppointment(appointment.bookingId);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Appointment deleted')),
                    );
                  },
                  child: AppointmentCard(
                    appointment: appointment,
                    onDownload: () => _generatePdf(context, appointment),
                  ),
                );
              },
            ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  final Appointment appointment;
  final VoidCallback onDownload;

  const AppointmentCard(
      {Key? key, required this.appointment, required this.onDownload})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle =
        Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white);

    return Card(
      color: Color(0xFFB71C1C),
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
                backgroundColor: Colors.white,
                foregroundColor: Color(0xFFD32F2F),
              ),
              onPressed: onDownload,
              child: const Text('Download Appointment Slip'),
            ),
          ],
        ),
      ),
    );
  }
}
