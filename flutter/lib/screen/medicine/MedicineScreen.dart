import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medicine_store.dart'; // Assuming this holds your medicine data

class MedicineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicineStore = Provider.of<MedicineStore>(context);

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900]!, Colors.blue[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text('Medicine Store',
            style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
      ),
      body: medicineStore.medicineList.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: medicineStore.medicineList.length,
              itemBuilder: (context, index) {
                final medicine = medicineStore.medicineList[index];
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child:
                          Icon(Icons.local_pharmacy, color: Colors.blue[900]),
                    ),
                    title: Text(medicine.name,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    subtitle: Text('Price: \$${medicine.price}',
                        style: TextStyle(color: Colors.grey[600])),
                    trailing: ElevatedButton(
                      child: Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () => medicineStore.addToCart(medicine),
                    ),
                    onTap: () {
                      // Navigate to medicine details
                    },
                  ),
                );
              },
            ),
    );
  }
}
