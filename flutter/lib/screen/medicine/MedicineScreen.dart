import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/medicine_store.dart';
import '../../providers/cart_provider.dart';
import 'MedicineDetailScreen.dart';
import 'ShopDetailScreen.dart';

class MedicineScreen extends StatefulWidget {
  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<MedicineProvider>(context, listen: false).loadMedicineData();
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Shops'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  // Navigate to cart screen
                },
              ),
              if (cartProvider.itemCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 10,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartProvider.itemCount.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: medicineProvider.isLoading
          ? Center(child: CircularProgressIndicator())
          : medicineProvider.stores.isEmpty
              ? Center(child: Text('No medicine stores available'))
              : ListView.builder(
                  itemCount: medicineProvider.stores.length,
                  itemBuilder: (context, index) {
                    final store = medicineProvider.stores[index];
                    return Card(
                      margin: EdgeInsets.all(8),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.teal[100],
                          child: Text(
                            store.storeName[0],
                            style: TextStyle(color: Colors.teal[900]),
                          ),
                        ),
                        title: Text(store.storeName),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(store.area),
                            Text(store.address),
                            Text(
                              '${store.medicines.length} medicines available',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ShopDetailScreen(store: store),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
