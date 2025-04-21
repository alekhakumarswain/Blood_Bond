import 'package:pdf/widgets.dart' as pw;
import 'appointment_model.dart';

class AppointmentCardPdfContent {
  static pw.Widget buildPdfContent(Appointment appointment) {
    final qrCodeData =
        'Booking ID: ${appointment.bookingId}\\nPatient: ${appointment.patientName}\\nDoctor: ${appointment.doctorName}';

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
  }
}
