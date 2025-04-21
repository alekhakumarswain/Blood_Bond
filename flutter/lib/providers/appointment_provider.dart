import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:blood_bond/screen/Doctor/appointment_model.dart';

class AppointmentProvider with ChangeNotifier {
  List<Appointment> _appointments = [];

  List<Appointment> get appointments => _appointments;

  AppointmentProvider() {
    loadAppointments();
  }

  Future<void> loadAppointments() async {
    final prefs = await SharedPreferences.getInstance();
    final String? appointmentsJson = prefs.getString('appointments');
    if (appointmentsJson != null) {
      final List<dynamic> decoded = jsonDecode(appointmentsJson);
      _appointments =
          decoded.map((json) => Appointment.fromJson(json)).toList();
      notifyListeners();
    }
  }

  Future<void> addAppointment(Appointment appointment) async {
    _appointments.add(appointment);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('appointments',
        jsonEncode(_appointments.map((e) => e.toJson()).toList()));
    notifyListeners();
  }
}
