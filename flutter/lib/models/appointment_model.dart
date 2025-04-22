class Appointment {
  final String patientName;
  final String bookingId;
  final String patientId;
  final String email;
  final String appointmentTime;
  final String appointmentType;
  final String? doctorId;
  final String address;
  final String latitude;
  final String longitude;
  final String? virtualMeetingUrl;
  final String doctorName;
  final String specialty;
  final String hospitalName;
  final String appointmentDate;

  Appointment({
    required this.patientName,
    required this.bookingId,
    required this.patientId,
    required this.email,
    required this.appointmentTime,
    required this.appointmentType,
    this.doctorId,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.virtualMeetingUrl,
    required this.doctorName,
    required this.specialty,
    required this.hospitalName,
    required this.appointmentDate,
  });

  factory Appointment.fromJson(Map<String, dynamic> json) {
    return Appointment(
      patientName: json['patientName'] as String,
      doctorName: json['doctorName'] as String,
      specialty: json['specialty'] as String,
      hospitalName: json['hospitalName'] as String,
      appointmentDate: json['appointmentDate'] as String,
      appointmentTime: json['appointmentTime'] as String,
      appointmentType: json['appointmentType'] as String,
      bookingId: json['bookingId'] as String,
      patientId: json['patientId'] as String,
      email: json['email'] as String,
      address: json['address'] as String,
      latitude: json['latitude'] as String,
      longitude: json['longitude'] as String,
      doctorId: json['doctorId'] != null ? json['doctorId'].toString() : null,
      virtualMeetingUrl: json['virtualMeetingUrl'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'patientName': patientName,
      'doctorName': doctorName,
      'specialty': specialty,
      'hospitalName': hospitalName,
      'appointmentDate': appointmentDate,
      'appointmentTime': appointmentTime,
      'appointmentType': appointmentType,
      'bookingId': bookingId,
      'patientId': patientId,
      'email': email,
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'doctorId': doctorId,
      'virtualMeetingUrl': virtualMeetingUrl,
    };
  }
}
