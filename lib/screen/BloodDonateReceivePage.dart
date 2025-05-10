import 'package:flutter/material.dart';
import 'package:blood_bond/widgets/Navbar.dart';

class BloodDonateReceivePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Donate & Receive'),
        backgroundColor: Colors.redAccent,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NavScreen()));
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(top: 20, left: 15, right: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Manage Blood Donation & Requests",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            _buildDonateBloodCard(),
            SizedBox(height: 20),
            _buildReceiveBloodCard(),
            SizedBox(height: 20),
            _buildSearchBloodCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildDonateBloodCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.volunteer_activism,
                    color: Colors.white, size: 30),
              ),
              SizedBox(width: 10),
              Text(
                'Donate Blood',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField('Name', Icons.person),
          _buildDropdownField(
            'Blood Group',
            [
              'A+',
              'A-',
              'B+',
              'B-',
              'AB+',
              'AB-',
              'O+',
              'O-'
            ], // Comprehensive blood group list
            Icons.bloodtype,
          ),
          _buildTextField('Location', Icons.location_on),
          _buildTextField('Contact Info', Icons.phone),
          _buildTextField('Date Available', Icons.calendar_today),
          _buildDropdownField(
            'Donation Type',
            ['Whole Blood', 'Plasma', 'Platelets'],
            Icons.bloodtype,
          ),
          _buildDropdownField(
            'Donation Frequency',
            ['One-time', 'Monthly', 'Quarterly'],
            Icons.schedule,
          ),
          _buildTextField(
              'Medical Conditions', Icons.medical_services), // New field
          _buildDropdownField(
            'Eligibility Criteria',
            ['First-time Donor', 'Regular Donor', 'Special Approval'],
            Icons.verified_user,
          ), // New option
          _buildCheckbox('Notify Me About Campaigns', false),
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
        ],
      ),
    );
  }

  Widget _buildReceiveBloodCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.redAccent,
                  shape: BoxShape.circle,
                ),
                child:
                    Icon(Icons.local_hospital, color: Colors.white, size: 30),
              ),
              SizedBox(width: 10),
              Text(
                'Receive Blood',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField('Name', Icons.person),
          _buildDropdownField(
            'Required Blood Group',
            [
              'A+',
              'A-',
              'B+',
              'B-',
              'AB+',
              'AB-',
              'O+',
              'O-'
            ], // Comprehensive blood group list
            Icons.bloodtype,
          ),
          _buildTextField('Location', Icons.location_on),
          _buildTextField('Urgency Level', Icons.priority_high),
          _buildTextField('Preferred Date', Icons.calendar_today),
          _buildDropdownField(
            'Reason for Request',
            ['Surgery', 'Emergency', 'Chronic Condition'],
            Icons.note,
          ),
          _buildDropdownField(
            'Delivery Option',
            ['Pickup', 'Hospital Delivery'],
            Icons.local_shipping,
          ),
          _buildTextField('Medical History', Icons.history), // New field
          _buildDropdownField(
            'Required Quantity',
            ['1 Unit', '2 Units', '3+ Units'],
            Icons.format_list_numbered,
          ), // New option
          _buildCheckbox('Urgent Notification', false),
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
                Text('Request Blood', style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBloodCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.greenAccent.shade700,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.search, color: Colors.white, size: 30),
              ),
              SizedBox(width: 10),
              Text(
                'Search Available Blood',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 16),
          _buildTextField('City', Icons.location_city),
          _buildTextField('Hospital Name', Icons.local_hospital),
          _buildDropdownField(
            'Blood Quantity',
            ['1 Unit', '2 Units', '3+ Units'],
            Icons.format_list_numbered,
          ),
          _buildDropdownField(
            'Sort By',
            ['Nearest', 'Latest', 'Most Available'],
            Icons.sort,
          ),
          _buildDropdownField(
            'Filter by Rh Factor',
            ['+', '-'],
            Icons.filter_alt,
          ), // New option
          SizedBox(height: 10),
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
    );
  }

  Widget _buildTextField(String label, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
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

  Widget _buildDropdownField(String label, List<String> items, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
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
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (value) {
          // Handle dropdown selection
        },
      ),
    );
  }

  Widget _buildCheckbox(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Checkbox(
            value: value,
            onChanged: (newValue) {
              // Handle checkbox change
            },
            activeColor: Colors.redAccent,
          ),
          Text(label, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
