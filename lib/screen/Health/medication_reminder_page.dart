import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class MedicationHealthMonitor extends StatefulWidget {
  @override
  _MedicationHealthMonitorState createState() =>
      _MedicationHealthMonitorState();
}

class _MedicationHealthMonitorState extends State<MedicationHealthMonitor>
    with SingleTickerProviderStateMixin {
  Map<String, dynamic>? profileData;
  bool isLoading = true;
  final Color primaryColor = Colors.green[700]!;
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        SnackBar(content: Text('Failed to load medication data')),
      );
    }
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.medication, color: Colors.white),
            SizedBox(width: 8),
            Text('Medications'),
          ],
        ),
        backgroundColor: primaryColor,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: 'Today'),
            Tab(text: 'History'),
          ],
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showLogMedicationDialog(context),
        backgroundColor: primaryColor,
        child: Icon(Icons.add),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                _buildTodaysMedications(),
                _buildMedicationHistory(),
              ],
            ),
    );
  }

  Widget _buildTodaysMedications() {
    final medicationReminders =
        profileData?['healthReminders']?['medicationReminders'] ?? [];
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 6,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[100]!, Colors.green[300]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Today\'s Medications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.green[900],
                      ),
                    ),
                    SizedBox(height: 8),
                    if (medicationReminders.isEmpty)
                      Text(
                        'No medications scheduled for today.',
                        style: TextStyle(color: Colors.grey[600]),
                      )
                    else
                      ...medicationReminders.map<Widget>((reminder) {
                        return ListTile(
                          leading:
                              Icon(Icons.medication, color: Colors.green[400]),
                          title:
                              Text(reminder['medicationName'] ?? 'Medication'),
                          subtitle: Text(
                              '${reminder['dosage']} at ${(reminder['times'] as List).join(', ')}'),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.check_circle,
                              color: reminder['taken'] == true
                                  ? Colors.green
                                  : Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                reminder['taken'] =
                                    !(reminder['taken'] ?? false);
                              });
                            },
                          ),
                        );
                      }).toList(),
                    SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _showLogMedicationDialog(context),
                        child: Text('Log New Medication'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
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
          ),
        ],
      ),
    );
  }

  Widget _buildMedicationHistory() {
    final medicines = profileData?['medicinePurchases'] ?? [];
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (medicines.isEmpty)
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green[100]!, Colors.green[300]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: EdgeInsets.all(16),
                child: Text(
                  'No medication purchase history.',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            )
          else
            ...medicines.map<Widget>((med) {
              return Card(
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green[100]!, Colors.green[300]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ExpansionTile(
                    title: Text(
                      med['name'] ?? 'Medication',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green[900]),
                    ),
                    subtitle: Text(
                      med['purchaseDate'] ?? 'Unknown date',
                      style: TextStyle(color: Colors.green[700]),
                    ),
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow(
                                'Dosage', med['dosage'] ?? 'Not specified'),
                            _buildInfoRow(
                                'Category', med['category'] ?? 'Not specified'),
                            _buildInfoRow('Quantity',
                                med['quantity']?.toString() ?? 'Not specified'),
                            _buildInfoRow('Store',
                                med['store']?['storeName'] ?? 'Not specified'),
                            _buildInfoRow('Next Refill',
                                med['nextRefillDate'] ?? 'Not specified'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.green[900]),
          ),
          Expanded(
            child: Text(
              value.isEmpty ? 'Not specified' : value,
              style: TextStyle(color: Colors.grey[800]),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogMedicationDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController dosageController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Log Medication'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Medication Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: dosageController,
              decoration: InputDecoration(
                labelText: 'Dosage',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Medication logged successfully!')),
              );
              Navigator.pop(context);
            },
            child: Text('Save'),
            style: ElevatedButton.styleFrom(backgroundColor: primaryColor),
          ),
        ],
      ),
    );
  }
}
