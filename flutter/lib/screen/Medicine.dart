import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/medicine_store.dart';
import '../providers/cart_provider.dart';
import 'medicine/ShopDetailScreen.dart';
import 'medicine/CartScreen.dart';

class MedicineScreen extends StatefulWidget {
  @override
  _MedicineScreenState createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<MedicineProvider>(context, listen: false).loadMedicineData();
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<MedicineProvider>(context);
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    // Filter stores based on search query
    final filteredStores = _searchQuery.isEmpty
        ? medicineProvider.stores
        : medicineProvider.stores
            .where((store) => store.storeName
                .toLowerCase()
                .contains(_searchQuery.toLowerCase()))
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Medicine Shops'),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search medicine stores...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: medicineProvider.isLoading
                ? Center(child: CircularProgressIndicator())
                : filteredStores.isEmpty
                    ? Center(child: Text('No medicine stores found'))
                    : ListView.builder(
                        itemCount: filteredStores.length,
                        itemBuilder: (context, index) {
                          final store = filteredStores[index];
                          return Card(
                            margin: EdgeInsets.all(8),
                            elevation: 2,
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.teal[100],
                                child: Text(
                                  store.storeName.isNotEmpty
                                      ? store.storeName[0]
                                      : '?',
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
          ),
        ],
      ),
    );
  }
}
