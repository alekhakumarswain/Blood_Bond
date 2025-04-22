import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:blood_bond/models/appointment_model.dart';
import 'package:provider/provider.dart';
import 'package:blood_bond/providers/appointment_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:qr_flutter/qr_flutter.dart';

String jsonData(Appointment appointment) {
  return '''
{
  "patientName": "${appointment.patientName}",
  "bookingId": "${appointment.bookingId}",
  "patientId": "${appointment.patientId}",
  "email": "${appointment.email}",
  "dateOfIssue": "${DateTime.now().month}/${DateTime.now().day}/${DateTime.now().year}",
  "appointmentTime": "${appointment.appointmentTime}",
  "appointmentType": "${appointment.appointmentType}",
  "doctorId": "${appointment.doctorId}",
  "hospitalAddress": "${appointment.address}",
  "latitude": "${appointment.latitude}",
  "longitude": "${appointment.longitude}",
  "virtualMeetingUrl": "${appointment.virtualMeetingUrl ?? ''}"
}
''';
}

class AppointmentSlipScreen extends StatelessWidget {
  const AppointmentSlipScreen({Key? key}) : super(key: key);

  Future<Uint8List> _loadLogo() async {
    final data = await rootBundle.load('assets/images/icon.png');
    return data.buffer.asUint8List();
  }

  Future<void> _generatePdf(
      BuildContext context, Appointment appointment) async {
    final pdf = pw.Document();

    final logoImage = pw.MemoryImage(await _loadLogo());
    final qrCodeData = jsonData(appointment);
    final barcodeData = appointment.bookingId;

    final currentDate = DateTime.now();
    final formattedDate =
        "${currentDate.month}/${currentDate.day}/${currentDate.year}";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned.fill(
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    gradient: pw.LinearGradient(
                      colors: [
                        PdfColor.fromInt(0xFF0077BE),
                        PdfColor.fromInt(0xFFB2D8D8),
                        PdfColor.fromInt(0xFFFAD6A5),
                      ],
                      begin: pw.Alignment.topLeft,
                      end: pw.Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.Container(
                          decoration: pw.BoxDecoration(
                            shape: pw.BoxShape.circle,
                            color: PdfColors.white,
                          ),
                          padding: pw.EdgeInsets.all(8),
                          child: pw.Image(logoImage, width: 80, height: 80),
                        ),
                        pw.SizedBox(height: 16),
                        pw.Row(
                          mainAxisAlignment: pw.MainAxisAlignment.center,
                          crossAxisAlignment: pw.CrossAxisAlignment.center,
                          children: [
                            pw.Image(logoImage, width: 60, height: 60),
                            pw.SizedBox(width: 12),
                            pw.Text('Blood Bond',
                                style: pw.TextStyle(
                                    fontSize: 28,
                                    fontWeight: pw.FontWeight.bold)),
                          ],
                        ),
                        pw.SizedBox(height: 16),
                        pw.Text('Patient Appointment Confirmation',
                            style: pw.TextStyle(
                                fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      ],
                    ),
                  ),
                  pw.SizedBox(height: 24),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Patient Name: ${appointment.patientName}',
                              style: pw.TextStyle(
                                fontSize: 16,
                                color: PdfColors.green800,
                              ),
                            ),
                            pw.SizedBox(height: 12),
                            pw.Text(
                              'Booking ID: ${appointment.bookingId}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Patient ID: ${appointment.patientId}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Doctor ID: ${appointment.doctorId}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Email: ${appointment.email}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.SizedBox(height: 12),
                            pw.Text(
                              'Hospital Address: ${appointment.address}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Latitude: ${appointment.latitude}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Longitude: ${appointment.longitude}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.SizedBox(height: 12),
                            pw.Text(
                              'Date of Issue: $formattedDate',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 24),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                          children: [
                            pw.BarcodeWidget(
                              barcode: pw.Barcode.qrCode(),
                              data: qrCodeData,
                              width: 100,
                              height: 100,
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              'Scan to view meeting link',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontStyle: pw.FontStyle.italic,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    height: 1,
                    color: PdfColors.green800,
                    margin: pw.EdgeInsets.symmetric(vertical: 20),
                  ),
                  pw.Center(
                    child: pw.Text(
                      'DOCTOR APPOINTMENT SLIP',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.white,
                      ),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Text(
                              'Patient Name: ${appointment.patientName}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.SizedBox(height: 10),
                            pw.Text(
                              'Booking ID: ${appointment.bookingId}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Patient ID: ${appointment.patientId}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Doctor ID: ${appointment.doctorId}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Email: ${appointment.email}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Hospital Address: ${appointment.address}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Latitude: ${appointment.latitude}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Longitude: ${appointment.longitude}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Appointment Time: ${appointment.appointmentTime}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Appointment Type: ${appointment.appointmentType}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                            pw.Text(
                              'Virtual Meeting URL: ${appointment.virtualMeetingUrl ?? ''}',
                              style: pw.TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ),
                      pw.SizedBox(width: 24),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Column(
                          children: [
                            pw.BarcodeWidget(
                              barcode: pw.Barcode.qrCode(),
                              data: qrCodeData,
                              width: 100,
                              height: 100,
                            ),
                            pw.SizedBox(height: 8),
                            pw.Text(
                              'Scan to view meeting link',
                              style: pw.TextStyle(
                                fontSize: 12,
                                fontStyle: pw.FontStyle.italic,
                              ),
                              textAlign: pw.TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 20),
                  pw.Container(
                    padding: pw.EdgeInsets.all(8),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.green800),
                    ),
                    child: pw.Text(
                      'Instructions: Please arrive 15 minutes early with this slip and any relevant medical records. For cancellation or rescheduling, contact the hospital at least 24 hours prior. For virtual appointment, join using the provided link at the scheduled time.',
                      style: pw.TextStyle(fontSize: 12),
                    ),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Center(
                    child: pw.Column(
                      children: [
                        pw.BarcodeWidget(
                          barcode: pw.Barcode.code128(),
                          data: barcodeData,
                          width: 200,
                          height: 80,
                        ),
                        pw.SizedBox(height: 8),
                        pw.Text(
                          'Generated by Swasthya Setu on $formattedDate | Confidential Appointment Slip',
                          style: pw.TextStyle(
                            fontSize: 10,
                            fontStyle: pw.FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
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
        backgroundColor: Color.fromARGB(255, 251, 105, 105),
      ),
      backgroundColor: Color.fromARGB(255, 234, 245, 247),
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
                    color: const Color.fromARGB(255, 251, 213, 213),
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Icon(Icons.delete,
                        color: const Color.fromARGB(255, 216, 6, 6)),
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
    final textStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: const Color.fromARGB(255, 22, 20, 20));

    return Card(
      color: Color.fromARGB(255, 191, 236, 107),
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Content on the left
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Patient: ${appointment.patientName}',
                          style: textStyle),
                      SizedBox(height: 4),
                      Text('Doctor: ${appointment.doctorName}',
                          style: textStyle),
                      SizedBox(height: 4),
                      Text('Specialty: ${appointment.specialty}',
                          style: textStyle),
                      SizedBox(height: 4),
                      Text('Hospital: ${appointment.hospitalName}',
                          style: textStyle),
                      SizedBox(height: 4),
                      Text('Date: ${appointment.appointmentDate}',
                          style: textStyle),
                      SizedBox(height: 4),
                      Text('Time: ${appointment.appointmentTime}',
                          style: textStyle),
                      SizedBox(height: 4),
                      Text('Type: ${appointment.appointmentType}',
                          style: textStyle),
                      SizedBox(height: 4),
                      Text('Doctor ID: ${appointment.doctorId}',
                          style: textStyle),
                      SizedBox(height: 4),
                      Text('Hospital Address: ${appointment.address}',
                          style: textStyle),
                      SizedBox(height: 4),
                      Text('Latitude: ${appointment.latitude}',
                          style: textStyle),
                      SizedBox(height: 4),
                      Text('Longitude: ${appointment.longitude}',
                          style: textStyle),
                    ],
                  ),
                ),
                // QR code on the right
                Expanded(
                  flex: 2,
                  child: Center(
                    child: QrImageView(
                      data: jsonData(appointment),
                      size: 150.0,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Download button below
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  foregroundColor: Color(0xFFD32F2F),
                ),
                onPressed: onDownload,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Download Appointment Slip'),
                    SizedBox(width: 8),
                    Icon(Icons.download, size: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
