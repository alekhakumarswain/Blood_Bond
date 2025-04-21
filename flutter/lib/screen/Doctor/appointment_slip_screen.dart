import 'package:flutter/material.dart';
import 'package:blood_bond/screen/Doctor/appointment_model.dart';
import 'package:provider/provider.dart';
import 'package:blood_bond/providers/appointment_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class AppointmentSlipScreen extends StatelessWidget {
  const AppointmentSlipScreen({Key? key}) : super(key: key);

  Future<void> _generatePdf(
      BuildContext context, Appointment appointment) async {
    final pdf = pw.Document();

    final qrCodeData =
        'Booking ID: ${appointment.bookingId}\\nPatient: ${appointment.patientName}\\nDoctor: ${appointment.doctorName}';

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                flex: 3,
                child: pw.Container(
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
                ),
              ),
              pw.Expanded(
                flex: 1,
                child: pw.Container(
                  padding: pw.EdgeInsets.all(20),
                  child: pw.BarcodeWidget(
                    barcode: pw.Barcode.qrCode(),
                    data: qrCodeData,
                    width: 100,
                    height: 100,
                  ),
                ),
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
