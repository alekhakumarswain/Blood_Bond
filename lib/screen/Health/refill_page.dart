import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class RefillPage extends StatefulWidget {
  @override
  _RefillPageState createState() => _RefillPageState();
}

class _RefillPageState extends State<RefillPage> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  final Color primaryColor = Color(0xFF6A1B9A);
  String? selectedMedicine;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    try {
      String jsonString =
          await rootBundle.loadString('assets/Data/profile.json');
      setState(() {
        profileData = json.decode(jsonString);
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load profile data')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final medicines = profileData?['medicinePurchases'] ?? [];
    return Scaffold(
      appBar: AppBar(
        title: Text('Request Refill'),
        backgroundColor: primaryColor,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Select Medication',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: selectedMedicine,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Medication',
                            ),
                            items:
                                medicines.map<DropdownMenuItem<String>>((med) {
                              return DropdownMenuItem<String>(
                                value: med['name'],
                                child: Text(med['name'] ?? 'Medication'),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedMedicine = value;
                              });
                            },
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: selectedMedicine != null
                                  ? () {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Refill request for $selectedMedicine sent!')),
                                      );
                                    }
                                  : null,
                              child: Text('Request Refill'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[400],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Recent Purchases',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  if (medicines.isEmpty)
                    Text(
                      'No medication purchases.',
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  else
                    ...medicines.map<Widget>((med) {
                      return ListTile(
                        title: Text(med['name'] ?? 'Medication'),
                        subtitle: Text('Purchased on ${med['purchaseDate']}'),
                      );
                    }).toList(),
                ],
              ),
            ),
    );
  }
}
