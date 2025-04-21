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
        backgroundColor: Color(0xFFD32F2F), // Crimson Red primary accent
        elevation: 4,
        shadowColor: Colors.black45,
        actions: [
          Builder(
            builder: (context) {
              bool isNavigating = false;
              return IconButton(
                icon: Icon(Icons.shopping_cart, color: Colors.white),
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
      body: Container(
        color: Color(0xFFF4F6F8), // Soft Light Gray background
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Card(
            color: Colors.white,
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            shadowColor: Color(0xFFD32F2F).withOpacity(0.3),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Medicine Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121), // Dark Charcoal
                    ),
                  ),
                  Divider(color: Color(0xFF616161)), // Medium Grey
                  _buildDetailRow('Price', '₹${medicine.price}'),
                  _buildDetailRow('Offers', medicine.offers),
                  _buildDetailRow('Category', medicine.category),
                  _buildDetailRow('Dosage', medicine.dosage),
                  _buildDetailRow('Stock', medicine.stock.toString()),
                  _buildDetailRow('Store', store.storeName),
                  _buildDetailRow('Store Location', store.address),
                  SizedBox(height: 24),
                  Text(
                    'Generic Alternative',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  Divider(color: Color(0xFF616161)),
                  _buildDetailRow('Name',
                      medicine.genericAlternative['Name'] ?? 'Not available'),
                  _buildDetailRow('Price',
                      '₹${medicine.genericAlternative['Price']?.toString() ?? 'N/A'}'),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add_shopping_cart),
                      label: Text('Add to Cart'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(255, 9, 154, 81),
                        padding:
                            EdgeInsets.symmetric(horizontal: 36, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      onPressed: () {
                        cartProvider.addItem(medicine, store);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added ${medicine.name} to cart'),
                            duration: Duration(seconds: 1),
                            backgroundColor: Color(0xFFD32F2F),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                color: Color(0xFF616161),
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
