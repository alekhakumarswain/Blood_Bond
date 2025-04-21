import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medicine_store.dart';
import '../../providers/cart_provider.dart';
import 'MedicineDetailScreen.dart';

class ShopDetailScreen extends StatelessWidget {
  final MedicineStore store;

  const ShopDetailScreen({required this.store});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(store.storeName),
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
              'Store Information',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            _buildDetailRow('Area', store.area),
            _buildDetailRow('Address', store.address),
            if (store.contactNumber != null)
              _buildDetailRow('Contact', store.contactNumber!),
            _buildDetailRow('Location',
                'Lat: ${store.latitude.toStringAsFixed(6)}, Long: ${store.longitude.toStringAsFixed(6)}'),
            SizedBox(height: 20),
            Text(
              'Available Medicines',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: store.medicines.length,
              itemBuilder: (context, index) {
                final medicine = store.medicines[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 4),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Color(0xFFBE179A).withOpacity(0.5),
                  child: ListTile(
                    title: Text(
                      medicine.name,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('₹${medicine.price} (${medicine.offers})'),
                        Text('Category: ${medicine.category}'),
                        Text('Stock: ${medicine.stock}'),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.add_shopping_cart,
                          color: Color(0xFFBE179A)),
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MedicineDetailScreen(
                              medicine: medicine, store: store),
                        ),
                      );
                    },
                  ),
                );
              },
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
