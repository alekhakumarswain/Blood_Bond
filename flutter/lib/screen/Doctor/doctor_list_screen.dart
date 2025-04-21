import 'package:flutter/material.dart';
import 'package:blood_bond/models/doctor.dart';
import 'package:blood_bond/screen/Doctor/doctor_detail_screen.dart';
import 'package:blood_bond/screen/Doctor/appointment_slip_screen.dart';
import 'package:provider/provider.dart';
import 'package:blood_bond/providers/appointment_provider.dart';

class DoctorListScreen extends StatefulWidget {
  const DoctorListScreen({Key? key}) : super(key: key);

  @override
  _DoctorListScreenState createState() => _DoctorListScreenState();
}

class _DoctorListScreenState extends State<DoctorListScreen> {
  List<Doctor> doctors = [];
  List<Doctor> filteredDoctors = [];
  String searchQuery = '';
  String? selectedSpecialty;
  bool? availableNowFilter;

  @override
  void initState() {
    super.initState();
    loadDoctors();
  }

  Future<void> loadDoctors() async {
    final loadedDoctors = await Doctor.loadDoctors();
    setState(() {
      doctors = loadedDoctors;
      filteredDoctors = loadedDoctors;
    });
  }

  void filterDoctors() {
    setState(() {
      filteredDoctors = doctors.where((doctor) {
        final matchesSearch =
            doctor.name.toLowerCase().contains(searchQuery.toLowerCase());
        final matchesSpecialty =
            selectedSpecialty == null || doctor.specialty == selectedSpecialty;
        final matchesAvailability = availableNowFilter == null ||
            (availableNowFilter! && doctor.availableNow) ||
            (!availableNowFilter! && !doctor.availableNow);
        return matchesSearch && matchesSpecialty && matchesAvailability;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final appointmentProvider = Provider.of<AppointmentProvider>(context);
    final appointmentCount = appointmentProvider.appointments.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctor Consultation'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.receipt_long),
                tooltip: 'Appointment Slips',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AppointmentSlipScreen()),
                  );
                },
              ),
              if (appointmentCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.orangeAccent,
                    child: Text(
                      appointmentCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search doctors...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                searchQuery = value;
                filterDoctors();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Specialty',
                      border: OutlineInputBorder(),
                    ),
                    value: selectedSpecialty,
                    items: <String>[
                      'Cardiology',
                      'Dermatology',
                      'Neurology',
                      'Pediatrics',
                      'General Medicine',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedSpecialty = newValue;
                        filterDoctors();
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Row(
                    children: [
                      const Text('Available Now'),
                      Switch(
                        value: availableNowFilter ?? false,
                        onChanged: (bool value) {
                          setState(() {
                            availableNowFilter = value;
                            filterDoctors();
                          });
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ListView.separated(
              itemCount: filteredDoctors.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return ListTile(
                  title: Text(doctor.name),
                  subtitle: Text('${doctor.specialty} - ${doctor.experience}'),
                  trailing: Text(doctor.availableNow
                      ? 'Available Now'
                      : 'Next: ${doctor.nextSlot}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DoctorDetailScreen(doctor: doctor),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
