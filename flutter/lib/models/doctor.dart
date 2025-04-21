import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class Doctor {
  final int id;
  final String name;
  final String specialty;
  final String experience;
  final String hospital;
  final String address;
  final double rating;
  final bool availableNow;
  final String? nextSlot;
  final double lat;
  final double lng;

  Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.hospital,
    required this.address,
    required this.rating,
    required this.availableNow,
    this.nextSlot,
    required this.lat,
    required this.lng,
  });

  factory Doctor.fromJson(Map<String, dynamic> json) {
    return Doctor(
      id: json['id'] as int,
      name: json['name'] as String,
      specialty: json['specialty'] as String,
      experience: json['experience'] as String,
      hospital: json['hospital'] as String,
      address: json['address'] as String,
      rating: (json['rating'] as num).toDouble(),
      availableNow: json['availableNow'] as bool,
      nextSlot: json['nextSlot'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'specialty': specialty,
      'experience': experience,
      'hospital': hospital,
      'address': address,
      'rating': rating,
      'availableNow': availableNow,
      'nextSlot': nextSlot,
      'lat': lat,
      'lng': lng,
    };
  }

  // Method to load doctors from JSON file
  static Future<List<Doctor>> loadDoctors() async {
    final String response =
        await rootBundle.loadString('assets/Data/doctors.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((json) => Doctor.fromJson(json)).toList();
  }
}
