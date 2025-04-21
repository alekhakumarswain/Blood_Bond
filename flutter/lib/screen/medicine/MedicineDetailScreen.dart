import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Added this import
import '../../models/medicine_store.dart';
import '../../providers/cart_provider.dart';

class MedicineDetailScreen extends StatelessWidget {
  final Medicine medicine;
  final MedicineStore store;

  const MedicineDetailScreen({
    required this.medicine,
    required this.store,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(medicine.name),
        backgroundColor: Color(0xFFBE179A),
        actions: [
          Builder(
            builder: (context) {
              bool isNavigating = false;
              return IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  if (isNavigating) return;
                  isNavigating = true;
                  Navigator.pushNamed(context, '/cart').then((_) {
                    isNavigating = false;
                  });
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Medicine Details',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            _buildDetailRow('Price', '₹${medicine.price}'),
            _buildDetailRow('Offers', medicine.offers),
            _buildDetailRow('Category', medicine.category),
            _buildDetailRow('Dosage', medicine.dosage),
            _buildDetailRow('Stock', medicine.stock.toString()),
            _buildDetailRow('Store', store.storeName),
            _buildDetailRow('Store Location', store.address),
            SizedBox(height: 20),
            Text(
              'Generic Alternative',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            _buildDetailRow(
                'Name', medicine.genericAlternative['Name'] ?? 'Not available'),
            _buildDetailRow('Price',
                '₹${medicine.genericAlternative['Price']?.toString() ?? 'N/A'}'),
            SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.add_shopping_cart),
                label: Text('Add to Cart'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFBE179A),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () {
                  cartProvider.addItem(medicine, store);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${medicine.name} to cart'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
