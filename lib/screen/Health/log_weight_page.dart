import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class LogWeightPage extends StatefulWidget {
  @override
  _LogWeightPageState createState() => _LogWeightPageState();
}

class _LogWeightPageState extends State<LogWeightPage> {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  final Color primaryColor = Color(0xFF6A1B9A);
  final TextEditingController weightController = TextEditingController();
  List<Map<String, dynamic>> weightHistory = [];

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
    return Scaffold(
      appBar: AppBar(
        title: Text('Log Weight'),
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
                            'Current Weight',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${profileData?['healthMetrics']?['weight'] ?? 80} kg',
                            style: TextStyle(
                                fontSize: 16, color: Colors.grey[600]),
                          ),
                          SizedBox(height: 16),
                          TextField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'New Weight (kg)',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                final weight =
                                    double.tryParse(weightController.text);
                                if (weight != null) {
                                  setState(() {
                                    weightHistory.add({
                                      'weight': weight,
                                      'date': DateTime.now().toIso8601String(),
                                    });
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content: Text(
                                            'Weight logged successfully!')),
                                  );
                                  weightController.clear();
                                }
                              },
                              child: Text('Log Weight'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[400],
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
                    'Weight History',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  if (weightHistory.isEmpty)
                    Text(
                      'No weight entries yet.',
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  else
                    ...weightHistory.map((entry) {
                      return ListTile(
                        title: Text('${entry['weight']} kg'),
                        subtitle: Text(entry['date'].split('T')[0]),
                      );
                    }).toList(),
                ],
              ),
            ),
    );
  }
}
