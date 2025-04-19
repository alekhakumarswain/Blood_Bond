import 'package:flutter/material.dart';

class BloodDonateReceivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donate & Receive'),
        backgroundColor: Colors.redAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Donate Blood Section
              _buildSectionHeader('Donate Blood'),
              _buildTextField('Name', Icons.person),
              _buildTextField('Blood Group', Icons.bloodtype),
              _buildTextField('Location', Icons.location_on),
              _buildTextField('Contact Info', Icons.phone),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  // Handle donate blood action
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.volunteer_activism, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Donate Blood', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Receive Blood Section
              _buildSectionHeader('Receive Blood'),
              _buildTextField('Name', Icons.person),
              _buildTextField('Required Blood Group', Icons.bloodtype),
              _buildTextField('Location', Icons.location_on),
              _buildTextField('Urgency Level', Icons.priority_high),
              SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {
                  // Handle receive blood action
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_hospital, color: Colors.white),
                    SizedBox(width: 8),
                    Text('Request Blood',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Search Available Blood Section
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {
                    // Handle search blood availability action
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Search Available Blood',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build section headers
  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.redAccent,
        ),
      ),
    );
  }

  // Helper method to build text fields
  Widget _buildTextField(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.redAccent),
          filled: true,
          fillColor: Colors.red.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
