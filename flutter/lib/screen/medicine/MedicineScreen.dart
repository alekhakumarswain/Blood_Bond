import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medicine_store.dart'; // Assuming this holds your medicine data
import 'MedicineDetailScreen.dart';
import 'ShopDetailScreen.dart';

class MedicineScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final medicineStore = Provider.of<MedicineStore>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Shops'),
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal[900]!, Colors.teal[300]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: medicineStore.isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: EdgeInsets.all(8),
              itemCount: medicineStore.medicineList.length,
              itemBuilder: (context, index) {
                final medicine = medicineStore.medicineList[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.teal[100],
                      child: Text(
                        medicine.name[0],
                        style: TextStyle(fontSize: 20, color: Colors.teal[800]),
                      ),
                    ),
                    title: Text(medicine.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    subtitle: Text(
                      'Price: \$${medicine.price}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios,
                        size: 16, color: Colors.teal),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            MedicineDialog(medicine: medicine),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}

class MedicineDialog extends StatelessWidget {
  final Medicine medicine;

  MedicineDialog({required this.medicine});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(medicine.name, style: Theme.of(context).textTheme.titleLarge),
      content: Container(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(medicine.description,
                style: Theme.of(context).textTheme.bodyMedium),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<MedicineStore>(context, listen: false)
                      .addToCart(medicine);
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${medicine.name} added to cart!'),
                        backgroundColor: Colors.teal),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text('Add to Cart', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Close', style: TextStyle(color: Colors.teal)),
        ),
      ],
    );
  }
}
