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
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 3 / 4,
              ),
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return DoctorCard(
                  doctor: doctor,
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

class DoctorCard extends StatelessWidget {
  final Doctor doctor;
  final VoidCallback onTap;

  const DoctorCard({Key? key, required this.doctor, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultIcon = Icons.person;
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: [
              CircleAvatar(
                radius: 40,
                backgroundColor: Colors.grey.shade200,
                child: Icon(
                  defaultIcon,
                  size: 48,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 12),
              Text(
                doctor.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                doctor.specialty,
                style: TextStyle(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                doctor.experience,
                style: TextStyle(color: Colors.grey.shade700),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                doctor.availableNow ? 'Available Now' : 'Not Available',
                style: TextStyle(
                  color: doctor.availableNow ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
